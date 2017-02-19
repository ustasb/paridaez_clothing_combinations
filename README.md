# Paridaez Clothing Combination Solver

**Problem:** Given a catalog of clothing and rules, what combinations exist and how many?

[SOLUTION](https://raw.githubusercontent.com/ustasb/paridaez_clothing_combinations/master/solution.txt)

**Note:** While I believe the solution is correct, I wrote it quickly one Sunday
morning as a favor and didn't spend time to verify it 100%.

## Given Rules

    Pieces/Functions:
    A. Bird of Paradise Top - 2 shirts
    B. Sparrow Top - 2 shirts
    C. Albatross- 1 shirt, 1 skirt, 1 dress
    D. Heron- 2 dresses, 1 cardigan (outerwear)
    E. Hummingbird-1 skirt, 1 shawl (accessory), 1 scarf (accessory), 1 hood (accessory), 1 shirt
    F. Pants- 1 pant

    Limitations:
    - Accessories and outwear can be worn with full outfits. Accessories cannot be worn together.
    - A shawl cannot be worn with outerwear (ex. heron as cardigan), although a scarf or hood could be worn with outerwear.
    - Hummingbird can be worn as a skirt over pants, but the albatross cannot be worn as a skirt over pants.
    - All dresses can be worn over pants.

## How to Run

In a terminal with Ruby 2+ installed: `ruby main.rb`
