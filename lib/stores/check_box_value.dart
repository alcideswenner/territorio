import 'package:flutter/cupertino.dart';

class CheckBoxValue extends ValueNotifier<Map<String, bool>> {
  CheckBoxValue() : super({});

  void setValue(Map<String, bool> vl) {
    vl.removeWhere((key, value) => value == false);
    value = vl;
    notifyListeners();
  }

  void init() {
    value = {};
    notifyListeners();
  }
}
