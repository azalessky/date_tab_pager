import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weekly_tab_pager/weekly_tab_pager.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final weekdays = [1, 2, 3, 4, 5];
  final weekCount = 100;
  late DateTime startDate;
  late WeeklyTabController controller;

  @override
  void initState() {
    super.initState();
    startDate = WeeklyTabNavigator.calcSafeDate(DateTime.now(), weekdays);
    controller = WeeklyTabController(position: startDate);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: WeeklyTabNavigator(
                  controller: controller,
                  weekdays: weekdays,
                  weekCount: weekCount,
                  tabBuilder: (context, date) => _buildTab(context, date),
                  pageBuilder: (context, date) => _buildPage(context, date),
                  onTabScrolled: (value) => debugPrint('onTabScrolled: $value'),
                  onTabChanged: (value) => debugPrint('onTabChanged: $value'),
                  onPageChanged: (value) => debugPrint('onPageChanged: $value'),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => controller.animateTo(startDate),
                child: const Text('Reset Position'),
              ),
              const SizedBox(height: 200),
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
}
