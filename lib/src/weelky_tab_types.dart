import 'package:flutter/material.dart';

typedef WeeklyTabBuilder = Widget Function(BuildContext context, DateTime date);
typedef WeeklyTabCallback = void Function(DateTime date);
