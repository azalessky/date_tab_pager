import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weekly_tab_pager/weekly_tab_pager.dart';

class WeeklyView extends StatefulWidget {
  final DateTime initialDate;
  final List<int> weekdays;
  final int weekCount;
  final void Function(DateTime date)? onDateChanged;

  const WeeklyView({
    required this.initialDate,
    required this.weekdays,
    required this.weekCount,
    this.onDateChanged,
    super.key,
  });

  @override
  State<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends State<WeeklyView> with TickerProviderStateMixin {
  late PositionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PositionController(
      position: widget.initialDate,
      weekdays: widget.weekdays,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyTabBar(
          controller: _controller,
          weekdays: widget.weekdays,
          tabBuilder: (_, date) => _buildTab(date),
          onTabScrolled: widget.onDateChanged,
          onTabChanged: widget.onDateChanged,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: WeeklyTabView(
            controller: _controller,
            weekdays: widget.weekdays,
            pageBuilder: (_, date) => _buildPage(date),
            onPageChanged: widget.onDateChanged,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _resetPosition,
          child: const Text('Reset Position'),
        ),
      ],
    );
  }

  Widget _buildTab(DateTime date) {
    final child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(DateFormat('E').format(date).toUpperCase()),
        const SizedBox(height: 4),
        Text(date.day.toString()),
      ],
    );
    return date.weekday >= 6
        ? DefaultTextStyle.merge(style: const TextStyle(color: Colors.red), child: child)
        : child;
  }

  Widget _buildPage(DateTime date) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          DateFormat.yMMMMd().format(date),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  void _resetPosition() {
    _controller.animateTo(DateTime.now());
    widget.onDateChanged?.call(_controller.position);
  }
}
