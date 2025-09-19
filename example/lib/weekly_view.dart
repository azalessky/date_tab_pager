import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_tab_pager/date_tab_pager.dart';

class WeeklyView extends StatefulWidget {
  final DateTime initialDate;
  final List<int> weekdays;
  final int maxItems;
  final void Function(DateTime date)? onDateChanged;

  const WeeklyView({
    super.key,
    required this.initialDate,
    required this.weekdays,
    required this.maxItems,
    this.onDateChanged,
  });

  @override
  State<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends State<WeeklyView> {
  late PositionController _controller;
  late SyncController _sync;

  @override
  void initState() {
    super.initState();

    _controller = PositionController(
      position: widget.initialDate,
      weekdays: widget.weekdays,
      maxItems: widget.maxItems,
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
        WeeklyTabBar(
          controller: _controller,
          sync: _sync,
          tabBuilder: (_, date) => _buildTab(date),
          onTabScrolled: widget.onDateChanged,
          onTabChanged: widget.onDateChanged,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: WeeklyTabView(
            controller: _controller,
            sync: _sync,
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
        '${start.day}–${end.day}',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPage(DateTime date) {
    final start = _weekStart(date, widget.weekdays);
    final end = _weekEnd(date, widget.weekdays);

    final days = List<DateTime>.generate(
      end.difference(start).inDays + 1,
      (i) => start.add(Duration(days: i)),
    ).where((d) => widget.weekdays.contains(d.weekday)).toList();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: days
              .map((day) => Text(
                    DateFormat.yMMMMEEEEd().format(day),
                    style: Theme.of(context).textTheme.titleMedium,
                  ))
              .toList(),
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
