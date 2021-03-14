import 'package:flutter/material.dart';
import 'ingredient.dart';





class PizzaIngredientItem extends StatelessWidget {
  const PizzaIngredientItem({this.ingredient,this.exist,this.onTap});
  final Ingredient ingredient;
   final bool exist;
  final VoidCallback onTap;

  @override
  Widget _buildChild({bool withImage = true}) {
    return  GestureDetector(
      onTap: exist ? null : onTap ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            shape: BoxShape.circle,
            border: exist ? null: Border.all(color: Colors.red,width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(
              ingredient.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: exist ==false ? _buildChild() :
      Draggable(
        childWhenDragging: _buildChild(withImage: false),
        child: _buildChild(),
        data: ingredient,
        feedback: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
              offset: Offset(0.0, 5.0),
              spreadRadius: 5,
            ),
          ]),
          child: _buildChild(),
        ),

      ),
    );
  }
}
