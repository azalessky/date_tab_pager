import 'package:flutter/material.dart';
import 'package:weekly_tab_pager/weekly_tab_pager.dart';
import 'package:intl/intl.dart';

class MonthlyView extends StatefulWidget {
  final DateTime initialDate;
  final List<int> weekdays;
  final int weekCount;
  final void Function(DateTime date)? onDateChanged;

  const MonthlyView({
    super.key,
    required this.initialDate,
    required this.weekdays,
    required this.weekCount,
    this.onDateChanged,
  });

  @override
  State<MonthlyView> createState() => _MonthlyViewState();
}

class _MonthlyViewState extends State<MonthlyView> with TickerProviderStateMixin {
  late PositionController _controller;
  late SyncController _sync;

  @override
  void initState() {
    super.initState();

    _controller = PositionController(
      position: widget.initialDate,
      weekdays: widget.weekdays,
    );
    _sync = SyncController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _sync.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthlyTabBar(
          controller: _controller,
          sync: _sync,
          weekdays: widget.weekdays,
          tabBuilder: (_, date) => _buildTab(date),
          onTabScrolled: widget.onDateChanged,
          onTabChanged: widget.onDateChanged,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: MonthlyTabView(
            controller: _controller,
            sync: _sync,
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
    final start = _weekStart(date, widget.weekdays);
    final end = _weekEnd(date, widget.weekdays);
    return Center(
      child: Text(
        '${start.day} - ${end.day}',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPage(DateTime date) {
    final start = _weekStart(date, widget.weekdays);
    final end = _weekEnd(date, widget.weekdays);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Start: ${DateFormat.yMMMMd().format(start)}\nEnd: ${DateFormat.yMMMMd().format(end)}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  DateTime _weekStart(DateTime date, List<int> days) =>
      date.add(Duration(days: days.first - date.weekday));

  DateTime _weekEnd(DateTime date, List<int> days) =>
      date.add(Duration(days: days.last - date.weekday));

  void _resetPosition() {
    _controller.animateTo(DateTime.now());
    widget.onDateChanged?.call(_controller.position);
  }
}
