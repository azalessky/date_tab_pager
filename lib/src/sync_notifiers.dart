import 'package:flutter/material.dart';

class VoidNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

class AlwaysNotifier<T> extends ValueNotifier<T> {
  AlwaysNotifier(super.value);

  @override
  set value(T value) {
    super.value = value;
    notifyListeners();
  }
}
