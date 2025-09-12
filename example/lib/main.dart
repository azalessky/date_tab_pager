import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weekly_tab_pager/weekly_tab_pager.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  final _weekdays = [1, 2, 3, 4, 5, 6];
  final _weekCount = 100;
  late WeeklyTabController _controller;
  late ValueNotifier<DateTime> _selectedDate;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    _selectedDate = ValueNotifier(today);

    _controller = WeeklyTabController(
      initialDate: today,
      weekdays: _weekdays,
      weekCount: _weekCount,
      vsync: this,
    );
    _controller.addListener(() => _selectedDate.value = _controller.position);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          bottom: WeeklyTabBar(
            controller: _controller,
            tabBuilder: _buildTab,
            onTabScrolled: _updateSelectedDate,
            onTabChanged: _updateSelectedDate,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: WeeklyTabView(
                  controller: _controller,
                  pageBuilder: _buildPage,
                  onPageChanged: _updateSelectedDate,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => _controller.animateTo(DateTime.now()),
                child: const Text('Reset Position'),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: _selectedDate,
        builder: (_, date, __) => Text(DateFormat.MMMM().format(date)),
      ),
    );
  }

  Widget _buildTab(BuildContext context, DateTime date) {
    final child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(DateFormat('E').format(date).toUpperCase()),
        const SizedBox(height: 4),
        Text(date.day.toString()),
      ],
    );

    return date.weekday >= 6
        ? DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.red),
            child: child,
          )
        : child;
  }

  Widget _buildPage(BuildContext context, DateTime date) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          DateFormat.yMMMMd().format(date),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  void _updateSelectedDate(DateTime date) {
    _selectedDate.value = date;
  }
}
