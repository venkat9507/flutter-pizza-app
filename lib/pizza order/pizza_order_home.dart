import 'package:flutter/material.dart';
import 'package:flutter_app_pizza_demo/pizza%20order/pizza_cart_icon.dart';
import 'package:flutter_app_pizza_demo/pizza%20order/pizza_order_bloc.dart';
import 'package:flutter_app_pizza_demo/pizza%20order/pizza_order_provider.dart';
import 'Pizza_ingredients.dart';
import 'ingredient.dart';
import 'pizza_details.dart';
import 'pizza_size_button.dart';
import 'pizza_cart_button.dart';
class PizzaOrderDetails extends StatefulWidget {
  @override
  _PizzaOrderDetailsState createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  static const double PizzaCartSize = 48;
  final bloc = PizzaOrderBloc();
  @override
  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'New Orleans Pizza',
            style: TextStyle(
              color: Colors.brown,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          actions: [PizzaCartIcon(),],
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Positioned.fill(
              bottom: 50,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 20,
                child: Column(
                  children: [
                    Expanded(flex: 4, child: PizzaDetails()),
                    Expanded(flex: 2, child: PizzaIngredients()),
                    Text('demo')
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              height: PizzaCartSize,
              width: PizzaCartSize,
              left: MediaQuery.of(context).size.width / 2 - PizzaCartSize / 2,
              child: PizzaCartButton(
                onTap: () {
                  print('hey you pressed the cart');
                 setState(() {
                   print('hey you pressed the cart');
                   bloc.startPizzaboxAnimation();
                 });
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return ValueListenableBuilder(
      valueListenable: bloc.notifierTotal,
      builder: (context,value,_){
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return PizzaIngredientItem(
                ingredient: ingredient,
                exist: bloc.constaintsIngredient(ingredient),
                onTap: (){
                  bloc.removeIngredient(ingredient);
                  print('delete');
                },
              );
            });
      },
    );
  }
}