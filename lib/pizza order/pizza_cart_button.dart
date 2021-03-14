import 'package:flutter/material.dart';

class PizzaCartButton extends StatefulWidget {
  final VoidCallback onTap;
  PizzaCartButton({this.onTap});
  @override
  PizzaCartButtonState createState() => PizzaCartButtonState();
}

class PizzaCartButtonState extends State<PizzaCartButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        lowerBound: 0.5,
        upperBound: 1.0,
        vsync: this,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    animationController.dispose();
    super.dispose();
  }

  Future<void> animationButton() async {
    await animationController.forward();
    await animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    var onTap = widget.onTap;
    return GestureDetector(
        onTap: (){
          widget.onTap();
          animationButton();
        },
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.scale(
                scale: (2 - animationController.value), child: child);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.orange.withOpacity(0.5),
                      Colors.orange,
                    ]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 4.0),
                    spreadRadius: 4.0,
                  )
                ]),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30,
            ),
          ),
        ));
  }
}
