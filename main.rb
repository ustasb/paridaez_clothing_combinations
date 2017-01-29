require_relative 'rules'
require_relative 'catalog'

DELIMITER = '|'

class ParidaezClothingCombinationSolver
  attr_accessor :combinations, :grouped_catalog

  def initialize
    @combinations = {}
    @grouped_catalog = CATALOG.group_by { |item| item[:type] }
  end

  def solve
    joins = build_innerwear_joins
    valid_joins = select_valid_innerwear_joins(joins)
    build_combinations_from_joins(valid_joins)

    add_outerwear
    add_accessories

    uniq_combinations_by_piece

    print_combinations
  end

  private

  def innerwear_rules_for_type(type)
    RULES[:innerwear].find { |item| type == item[:type] }
  end

  def build_innerwear_joins
    innerwear_joins = []

    RULES[:innerwear].each do |innerwear|
      types = innerwear[:whitelist] + [ innerwear[:type] ]

      (1..types.size).each do |i|
        innerwear_joins += types.combination(i).to_a.map { |comb| comb.sort.join(DELIMITER) }
      end
    end

    innerwear_joins
  end

  def select_valid_innerwear_joins(joins)
    joins.uniq.find_all do |join|
      types = join.split(DELIMITER)

      functions = types.map do |type|
        innerwear_rules_for_type(type)[:function]
      end

      is_complete_innerwear = (
        functions.include?('topbottom') or
        (functions.include?('top') and functions.include?('bottom'))
      )

      next false unless is_complete_innerwear

      first_type_whitelist = innerwear_rules_for_type(types.first)[:whitelist] + [types.first]

      # Assumes all whitelist relationships are mirrored.
      is_allowed = types.all? do |type|
        first_type_whitelist.include?(type)
      end

      is_allowed
    end
  end

  def build_combinations_from_joins(joins)
    joins.each do |join|
      types = join.split(DELIMITER)

      articles_per_types = types.map do |type|
        CATALOG.find_all { |item| type == item[:type] }.reject do |item|
          (item[:blacklist] & types).any? if item.has_key?(:blacklist)
        end
      end

      # cartesian product of the first against the rest
      combinations[join] = articles_per_types.first.product(*articles_per_types.slice(1..-1))
    end
  end

  def add_outerwear
    all_outerwear_items = RULES[:outerwear].map do |outerwear|
      grouped_catalog[outerwear[:type]]
    end.flatten

    combinations.keys.each do |comb_key|
      new_comb_key = "#{comb_key}|outerwear"
      combinations[new_comb_key] = []

      combinations[comb_key].each do |comb|
        all_outerwear_items.each do |outerwear_item|
          combinations[new_comb_key] << comb + [ outerwear_item ]
        end
      end
    end
  end

  def add_accessories
    combinations.keys.each do |comb_key|
      types = comb_key.split(DELIMITER)
      new_comb_key = "#{comb_key}|accessory"
      combinations[new_comb_key] = []

      RULES[:accessories].map do |accessory|
        if accessory.has_key?(:blacklist) and (accessory[:blacklist] & types).any?
          next
        end

        accessories = grouped_catalog[accessory[:type]]

        combinations[comb_key].each do |comb|
          accessories.each do |accessory|
            combinations[new_comb_key] << comb + [ accessory ]
          end
        end
      end
    end
  end

  # e.g. Don't allow a combination of a Hummingbird shirt + skirt.
  # They're both the same piece.
  def uniq_combinations_by_piece
    joins = combinations.keys

    joins.each do |join|
      combinations[join].reject! do |comb|
        comb.uniq { |c| c[:piece] }.size < comb.size
      end
    end
  end

  def print_combinations
    puts "\nThe following groupings were created:\n\n"
    sorted_keys = combinations.keys.sort
    sorted_keys.each { |key| puts "- #{key} (#{combinations[key].size} combinations)" }

    puts "\nClothing combinations for each grouping:"
    variant_num = 1

    sorted_keys.each do |key|
      puts "\n- GROUP: #{key}"

      if combinations[key].empty?
        puts "\n  no valid combinations"
      else
        combinations[key].sort_by do |comb|
          comb.first[:name]
        end.each do |comb|
          puts "\n  #{variant_num}"
          variant_num += 1

          values = comb.map { |item| "#{item[:type]}: " + item[:name] }
          values.each do |value|
            puts "  - #{value}"
          end
        end
      end
    end
  end
end

ParidaezClothingCombinationSolver.new.solve
