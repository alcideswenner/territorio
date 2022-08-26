import 'package:flutter/cupertino.dart';

class ChangedPageValue extends ValueNotifier<int> {
  ChangedPageValue() : super(0);

  void setValue(int index) {
    value = index;
    notifyListeners();
  }

  void init() {
    value = 0;
    notifyListeners();
  }
}
