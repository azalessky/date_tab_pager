import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'daily_view.dart';
import 'weekly_view.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _weekdays = [1, 3, 5, 6, 7];
  final _maxItems = 2000;
  final _selectedDate = ValueNotifier(DateTime.now());
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: ValueListenableBuilder<DateTime>(
            valueListenable: _selectedDate,
            builder: (_, date, __) =>
                Center(child: Text(DateFormat.MMMM().format(date))),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _selectedView,
                  children: [
                    DailyView(
                      initialDate: _selectedDate.value,
                      weekdays: _weekdays,
                      maxItems: _maxItems,
                      onDateChanged: (date) => _selectedDate.value = date,
                    ),
                    WeeklyView(
                      initialDate: _selectedDate.value,
                      weekdays: _weekdays,
                      maxItems: _maxItems,
                      onDateChanged: (date) => _selectedDate.value = date,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Daily View')),
                  ButtonSegment(value: 1, label: Text('Weekly View')),
                ],
                selected: {_selectedView},
                onSelectionChanged: (selection) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() => _selectedView = selection.first),
                  );
                },
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
