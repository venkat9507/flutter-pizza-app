import 'package:flutter/cupertino.dart';

class Ingredient {
  final String image;
  final String imageUnit;
 const  Ingredient(this.image,this.postion,this.imageUnit);
  final List<Offset> postion;
 bool compare(Ingredient ingredient) => ingredient.image == image;
}



final ingredients = const <Ingredient> [
  Ingredient('assets/pizza_order/chili.png',
      <Offset>[
        Offset(0.2, 0.2),
        Offset(0.6, 0.2),
        Offset(0.4, 0.25),
        Offset(0.5, 0.3),
        Offset(0.4, 0.65),
      ],
    'assets/pizza_order/chili_unit.png',),
  Ingredient('assets/pizza_order/mushroom.png',
      <Offset>[
        Offset(0.25, 0.5),
        Offset(0.65, 0.6),
        Offset(0.2, 0.3),
        Offset(0.4, 0.2),
        Offset(0.2, 0.6),
      ],
    'assets/pizza_order/mushroom_unit.png',
  ),
  Ingredient('assets/pizza_order/olive.png',
      <Offset>[
        Offset(0.25, 0.5),
        Offset(0.4, 0.4),
        Offset(0.3, 0.3),
        Offset(0.4, 0.2),
        Offset(0.4, 0.6),
      ],
    'assets/pizza_order/olive_unit.png',),
  Ingredient('assets/pizza_order/onion.png',

      <Offset>[
        Offset(0.2, 0.6),
        Offset(0.65, 0.3),
        Offset(0.25, 0.25),
        Offset(0.45, 0.35),
        Offset(0.4, 0.65),
      ],
    'assets/pizza_order/onion.png',
  ),
  Ingredient('assets/pizza_order/pea.png',

      <Offset>[
        Offset(0.2, 0.35),
        Offset(0.65, 0.35),
        Offset(0.3, 0.23),
        Offset(0.5, 0.2),
        Offset(0.3, 0.5),
      ],
    'assets/pizza_order/pea_unit.png',  ),
  Ingredient('assets/pizza_order/pickle.png',

      <Offset>[

        Offset(0.2, 0.65),
        Offset(0.66, 0.3),
        Offset(0.25, 0.25),
        Offset(0.45, 0.35),
        Offset(0.4, 0.65),
      ],
    'assets/pizza_order/pickle_unit.png',),
  Ingredient('assets/pizza_order/potato.png',
      <Offset>[
        Offset(0.2, 0.2),
        Offset(0.6, 0.2),
        Offset(0.4, 0.25),
        Offset(0.5, 0.3),
        Offset(0.4, 0.65),
      ],
    'assets/pizza_order/potato_unit.png',),
];