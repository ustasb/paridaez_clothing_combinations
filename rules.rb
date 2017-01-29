RULES = {
  # Innerwear requires at least 1 top and bottom.
  # Use the whitelist to dicate what can work together.
  # NOTE: All whitelist relationships should be mirrored.
  innerwear: [
    {
      type: 'shirt',
      function: 'top',
      whitelist: ['skirt', 'pants'],
    },
    {
      type: 'skirt',
      function: 'bottom',
      whitelist: ['shirt', 'pants'],
    },
    {
      type: 'dress',
      function: 'topbottom',
      whitelist: ['pants'], # All dresses can be worn over pants.
    },
    {
      type: 'pants',
      function: 'bottom',
      whitelist: ['shirt', 'skirt', 'dress'],
    },
  ],

  # To be worn above innerwear.
  # Outerwear cannot be worn together.
  outerwear: [
    {
      type: 'cardigan',
    },
  ],

  # To be worn in addition to a complete outfit.
  # Accessories cannot be worn together.
  accessories: [
    {
      type: 'shawl',
      blacklist: ['outerwear'], # A shawl cannot be worn with outerwear.
    },
    {
      type: 'scarf',
    },
    {
      type: 'hood',
    },
  ]
}
