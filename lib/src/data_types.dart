import 'package:flutter/material.dart';

typedef TabBuilder = Widget Function(BuildContext context, DateTime date);
typedef PageBuilder = Widget Function(BuildContext context, DateTime date);
typedef DateTimeCallback = void Function(DateTime date);
