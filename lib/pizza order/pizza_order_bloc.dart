import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show ChangeNotifier,ValueNotifier;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'ingredient.dart';


class PizzaMetaData {
   const PizzaMetaData(this.imageBytes, this.position, this.size);
  final Uint8List imageBytes;
  final Offset position;
  final Size size;


}


enum PizzaSizeValue {
  s,
  m,
  l,

}

class PizzaSizeState {
  final  PizzaSizeValue value;
  final double factor;
  PizzaSizeState(this.value) : factor = _getFactoryBySize(value);

  static _getFactoryBySize(PizzaSizeValue value){
    switch (value){
      case PizzaSizeValue.s:
        return 0.88;
      case PizzaSizeValue.m:
        return 1.00;
      case PizzaSizeValue.l:
        return 1.2;
    }
  }
}


const initialTotal = 15;

class PizzaOrderBloc extends ChangeNotifier {
  final listIngredients = <Ingredient>[];
  final notifierTotal = ValueNotifier(initialTotal);
  final notiferDeletedIngredient = ValueNotifier<Ingredient>( null);
  final notifierFocused = ValueNotifier(false);
  final notifierPizzaSize  = ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.m));
  final notifierPizzaBoxAnimation = ValueNotifier(false);
  final notifierCartIconAnimation = ValueNotifier(0 );
final notifierImagePizza =  ValueNotifier<PizzaMetaData>(null);
  void addIngredient(Ingredient ingredient){
    listIngredients.add(ingredient);
    notifierTotal.value++;
    notifyListeners();
  }

  void removeIngredient(Ingredient ingredient){
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notiferDeletedIngredient.value = ingredient;
  }

  void refreshDeletedIngredient(){
    notiferDeletedIngredient.value = null;
  }

  bool constaintsIngredient(Ingredient ingredient){
    for (Ingredient i in listIngredients) {
      if (i.compare(ingredient)) {
        return false;
      }
    }
    return true;
  }

  void reset(){
    notifierPizzaBoxAnimation.value = false;
    notifierImagePizza.value = null;
    listIngredients.clear();
    notifierTotal.value = initialTotal;
    notifierCartIconAnimation.value++;

  }

  void startPizzaboxAnimation(){
    notifierPizzaBoxAnimation.value = true;
    notifierImagePizza.value = null;
  }

  void transformToImage(RenderRepaintBoundary boundary) async{
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    ByteData byteData= await image.toByteData(format: ImageByteFormat.png);
    notifierImagePizza.value = PizzaMetaData(byteData.buffer.asUint8List(), position, size);
  }
}
