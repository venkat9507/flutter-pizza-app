import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_pizza_demo/pizza%20order/pizza_order_bloc.dart';
import 'package:flutter_app_pizza_demo/pizza%20order/pizza_order_provider.dart';
import 'ingredient.dart';
import 'pizza_size_button.dart';

class PizzaDetails extends StatefulWidget {
  @override
  PizzaDetailsState createState() => PizzaDetailsState();
}

class PizzaDetailsState extends State<PizzaDetails>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController animationRotationController;
  List<Animation> animationList = <Animation>[];
  BoxConstraints pizzaConstraints;
  final _keyPizza = GlobalKey();

  Widget buildIngredientsWidget(Ingredient deletedIngredient) {
    List<Widget> element = [];
    final listIngredients =
        List.from(PizzaOrderProvider.of(context).listIngredients);
    if (deletedIngredient != null) {
      listIngredients.add(deletedIngredient);
    }
    if (animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingredient = listIngredients[i];
        final ingredientWidget = Image.asset(
          ingredient.imageUnit,
          height: 40,
        );
        for (int j = 0; j < ingredient.postion.length; j++) {
          final animation = animationList[j];
          final position = ingredient.postion[j];
          final postionX = position.dx;
          final positionY = position.dy;

          if (i == listIngredients.length - 1 &&
              animationController.isAnimating) {
            double fromX = 0.0, fromY = 0.0;
            if (j < 1) {
              fromX = -pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -pizzaConstraints.maxHeight * (1 - animation.value);
            } else {
              fromY = pizzaConstraints.maxHeight * (1 - animation.value);
            }

            final opacity = animation.value;

            if (animation.value > 0) {
              element.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        fromX + pizzaConstraints.maxWidth * postionX,
                        fromY + pizzaConstraints.maxHeight * positionY,
                      ),
                    child: ingredientWidget,
                  ),
                ),
              );
            }
          } else {
            element.add(
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    pizzaConstraints.maxWidth * postionX,
                    pizzaConstraints.maxHeight * positionY,
                  ),
                child: ingredientWidget,
              ),
            );
          }
        }
      }
      return Stack(
        children: element,
      );
    }
    return SizedBox.fromSize();
  }

  void buildIngredientsAnimation() {
    animationList.clear();
    animationList.add(CurvedAnimation(
      curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.2, 0.8, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.4, 1.0, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.1, 0.7, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.3, 1.0, curve: Curves.decelerate),
      parent: animationController,
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    animationRotationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierPizzaBoxAnimation.addListener(() {
        if (bloc.notifierPizzaBoxAnimation.value) {
          print('Add Pizza');
          _addPizzaToCart();
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    animationRotationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredient>(
            onAccept: (ingredient) {
              print('accept');
              bloc.notifierFocused.value = false;
              bloc.addIngredient(ingredient);
              buildIngredientsAnimation();
              animationController.forward(from: 0.0);
            },
            onWillAccept: (ingredient) {
              print('onWillAccept');
              bloc.notifierFocused.value = true;
              return bloc.constaintsIngredient(ingredient);
            },
            onLeave: (ingredient) {
              print('onLeave');
              bloc.notifierFocused.value = false;
            },
            builder: (context, list, rejects) {
              return LayoutBuilder(builder: (context, constraints) {
                pizzaConstraints = constraints;
                print(constraints);
                return ValueListenableBuilder<PizzaMetaData>(
                  valueListenable: bloc.notifierImagePizza,
                  builder: (context, data, child) {
                    if (data != null) {
                      Future.microtask(() => _startPizzaBoxAnimation(data));
                    }

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 60),
                      opacity: data != null ? 0.0 : 1,
                      child: ValueListenableBuilder(
                          valueListenable: bloc.notifierPizzaSize,
                          builder: (context, pizzaSize, _) {
                            return RepaintBoundary(
                              key: _keyPizza,
                              child: RotationTransition(
                                turns: CurvedAnimation(
                                    parent: animationRotationController,
                                    curve: Curves.elasticOut),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: ValueListenableBuilder(
                                          valueListenable: bloc.notifierFocused,
                                          builder: (context, focused, _) {
                                            return AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              height: focused
                                                  ? constraints.maxHeight *
                                                      pizzaSize.factor
                                                  : constraints.maxHeight *
                                                          pizzaSize.factor -
                                                      50,
                                              child: Stack(
                                                children: [
                                                  DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 10,
                                                            color:
                                                                Colors.black26,
                                                            offset: Offset(
                                                                0.0, 5.0),
                                                            spreadRadius: 5.0,
                                                          )
                                                        ]),
                                                    child: Image.asset(
                                                      'assets/pizza_order/dish.png',
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Image.asset(
                                                        'assets/pizza_order/pizza-1.png'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    ValueListenableBuilder<Ingredient>(
                                      valueListenable:
                                          bloc.notiferDeletedIngredient,
                                      builder: (context, deletedIngredient, _) {
                                        _animateDeletedIngredient(
                                            deletedIngredient);
                                        return AnimatedBuilder(
                                            animation: animationController,
                                            builder: (context, _) {
                                              return buildIngredientsWidget(
                                                  deletedIngredient);
                                            });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  },
                );
              });
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
        ValueListenableBuilder<int>(
          valueListenable: bloc.notifierTotal,
          builder: (context, totalvalue, _) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(Tween<Offset>(
                      begin: Offset(0.0, 0.0),
                      end: Offset(
                        0.0,
                        animation.value,
                      ),
                    )),
                    child: child,
                  ),
                );
              },
              child: Text(
                '\$ $totalvalue',
                key: UniqueKey(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 15,
        ),
        ValueListenableBuilder(
            valueListenable: bloc.notifierPizzaSize,
            builder: (context, pizzaSize, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PizzaSizeButton(
                    text: 'S',
                    onTap: () {
                      _updatePizzaSize(PizzaSizeValue.s);
                    },
                    selected: pizzaSize.value == PizzaSizeValue.s,
                  ),
                  PizzaSizeButton(
                    text: 'M',
                    onTap: () {
                      _updatePizzaSize(PizzaSizeValue.m);
                    },
                    selected: pizzaSize.value == PizzaSizeValue.m,
                  ),
                  PizzaSizeButton(
                      text: 'L',
                      onTap: () {
                        _updatePizzaSize(PizzaSizeValue.l);
                      },
                      selected: pizzaSize.value == PizzaSizeValue.l),
                ],
              );
            })
      ],
    );
  }

  Future<void> _animateDeletedIngredient(Ingredient deletedIngredient) async {
    if (deletedIngredient != null) {
      await animationController.reverse(from: 1.0);
      final bloc = PizzaOrderProvider.of(context);
      bloc.refreshDeletedIngredient();
    }
  }

  void _updatePizzaSize(PizzaSizeValue value) {
    final bloc = PizzaOrderProvider.of(context);
    bloc.notifierPizzaSize.value = PizzaSizeState(value);
    animationRotationController.forward(from: 0.0);
  }

  void _addPizzaToCart() {
    final bloc = PizzaOrderProvider.of(context);
    RenderRepaintBoundary boundary =
        _keyPizza.currentContext.findRenderObject();
    bloc.transformToImage(boundary);
  }

  OverlayEntry _overlayEntry;
  void _startPizzaBoxAnimation(PizzaMetaData metaData) {
    final bloc = PizzaOrderProvider.of(context);

    if (_overlayEntry == null) {
      print('_Overlay Entry');
      _overlayEntry = OverlayEntry(builder: (context) {
        return PizzaOrderAnimation(
          metaData: metaData,
          onComplete: () {
            _overlayEntry.remove();
            _overlayEntry = null;
            bloc.reset();
          },
        );
      });
      Overlay.of(context).insert(_overlayEntry);
    }
  }
}

class PizzaOrderAnimation extends StatefulWidget {
  const PizzaOrderAnimation({Key key, this.metaData, this.onComplete})
      : super(key: key);
  final PizzaMetaData metaData;
  final VoidCallback onComplete;

  @override
  _PizzaOrderAnimationState createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _pizzaScaleAnimation;
  Animation<double> _pizzaOpacityAnimation;
  Animation<double> _boxEnterScaleAnimation;
  Animation<double> _boxExitScaleAnimation;
  Animation<double> _boxExitToCartAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 2500,
        ));
    _pizzaScaleAnimation = Tween(begin: 1.0, end: 0.5).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.2)));
    _pizzaOpacityAnimation =
        CurvedAnimation(parent: _controller, curve: Interval(0.4, 0.4));
    _boxEnterScaleAnimation =
        CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.4));
    _boxExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.6, 0.75)));
    _boxExitToCartAnimation =
        CurvedAnimation(parent: _controller, curve: Interval(0.85, 1.0));
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        widget.onComplete();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.metaData;
    return Positioned(
      top: metadata.position.dy,
      left: metadata.position.dx,
      width: metadata.size.width,
      height: metadata.size.height,
      child: GestureDetector(
        onTap: () {
          widget.onComplete;
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            final moveToX = _boxExitToCartAnimation.value > 0 ? metadata.position.dx + metadata.size.width/2* _boxExitToCartAnimation.value : 0.0;
            final moveToY = _boxExitToCartAnimation.value > 0 ? -metadata.size.height/1.5 * _boxExitToCartAnimation.value : 0.0;
            return Opacity(
              opacity: 1 - _boxExitToCartAnimation.value,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..translate(moveToX,moveToY)..rotateZ(_boxExitToCartAnimation.value)..scale(_boxExitScaleAnimation.value),
                child: Transform.scale(
                  scale:  1- _boxExitToCartAnimation.value,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      _buildBox(),
                      Opacity(
                        opacity: 1 - _pizzaOpacityAnimation.value,
                        child: Transform(
                          alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(_pizzaScaleAnimation.value)..translate(0.0,20 * (1-_pizzaOpacityAnimation.value)),

                            child: Image.memory(widget.metaData.imageBytes)),
                      ),
                      _buildBox(),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildBox() {
    return LayoutBuilder(builder: (context, constraints) {
      final boxheight = constraints.maxHeight / 2.0;
      final boxwidth = constraints.maxWidth / 2.0;
      final minAngle = -45.0;
      final maxAngle = -125.0;
      final boxClosingValue = lerpDouble(minAngle,maxAngle, 1- _pizzaOpacityAnimation.value);
      return Opacity(
        opacity: _boxEnterScaleAnimation.value,
        child: Transform.scale(
          scale: _boxEnterScaleAnimation.value,
          child: Stack(
            children: [
              Center(
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateX(
                      degreesToRads(minAngle),
                    ),
                  child: Image.asset(
                    'assets/pizza_order/box_inside.png',
                    height: boxheight,
                    width: boxwidth,
                  ),
                ),
              ),
              Center(
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateX(
                      degreesToRads(boxClosingValue),
                    ),
                  child: Image.asset(
                    'assets/pizza_order/box_inside.png',
                    height: boxheight,
                    width: boxwidth,
                  ),
                ),
              ),
              if(boxClosingValue >=-90)
              Center(
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateX(
                      degreesToRads(minAngle),
                    ),
                  child: Image.asset(
                    'assets/pizza_order/box_front.png',
                    height: boxheight,
                    width: boxwidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

num degreesToRads(num deg) {
  return (deg * pi) / 230.0;
}
