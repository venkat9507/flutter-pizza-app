import 'package:flutter/material.dart';
import 'package:flutter_app_pizza_demo/pizza%20order/pizza_order_provider.dart';

class PizzaCartIcon extends StatefulWidget {
  @override
  _PizzaCartIconState createState() => _PizzaCartIconState();
}

class _PizzaCartIconState extends State<PizzaCartIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animationScaleOut;
  Animation<double> _animationScaleIn;
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animationScaleOut =
        CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5));
    _animationScaleIn =
        CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierCartIconAnimation.addListener(() {
        counter = bloc.notifierCartIconAnimation.value;
        _controller.forward(from: 0.0);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context,snapshot){
        double scale;
        const scaleFactor = 0.5;
        if(_animationScaleOut.value < 1.0){
          scale = 1.0 + scaleFactor * _animationScaleOut.value;
        } else if(_animationScaleIn.value <= 1.0){
          scale = (1.0 + scaleFactor) - scaleFactor * _animationScaleIn.value;
        }
      return Transform.scale(
        alignment: Alignment.center,
        scale: scale,
        child: Stack(
          children: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.brown,
                ),
                onPressed: null),
            if(_animationScaleOut.value > 0)
            Positioned(
                top: 7,
                right: 7,
                child: Transform.scale(
                  alignment: Alignment.center,
                  scale: _animationScaleOut.value,
                  child: CircleAvatar(
              radius: 7,
              backgroundColor: Colors.red,
              child: Text(counter.toString(),style: TextStyle(fontSize: 12),),
            ),
                ))
          ],
        )
      );
      }
    );
  }
}
