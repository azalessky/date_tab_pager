import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weekly_tab_view/weekly_tab_controller.dart';
import 'package:weekly_tab_view/weekly_tab_view.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final weekdays = [1, 2, 3, 4, 5];
  final weekCount = 100;
  final controller = WeeklyTabController(position: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: WeeklyTabView(
                  controller: controller,
                  weekdays: weekdays,
                  weekCount: weekCount,
                  tabBuilder: (context, date) => _buildTab(context, date),
                  pageBuilder: (context, date) => _buildPage(context, date),
                  scrollPhysics: const PaginatorScrollPhysics(),
                  onTabScrolled: (value) => debugPrint('onTabScrolled: $value'),
                  onTabChanged: (value) => debugPrint('onTabChanged: $value'),
                  onPageChanged: (value) => debugPrint('onPageChanged: $value'),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _resetPosition,
                child: const Text('Reset Position'),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, DateTime date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(DateFormat('E').format(date).toUpperCase()),
        const SizedBox(height: 4),
        Text(date.day.toString()),
      ],
    );
  }

  Widget _buildPage(BuildContext context, DateTime date) {
    return Card(
      margin: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          DateFormat.yMMMMd().format(date),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  void _resetPosition() {
    setState(() => controller.animateTo(DateTime.now()));
  }
}

class PaginatorScrollPhysics extends ScrollPhysics {
  const PaginatorScrollPhysics({super.parent});

  @override
  PaginatorScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PaginatorScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 40,
        stiffness: 100,
        damping: 1,
      );
}
