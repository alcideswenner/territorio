import 'package:flutter/cupertino.dart';

class SeePasswordStore extends ValueNotifier<bool> {
  SeePasswordStore() : super(false);

  void setValue() {
    value = !value;
    notifyListeners();
  }

  void init() {
    value = false;
    notifyListeners();
  }
}
