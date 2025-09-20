import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_tab_pager/date_tab_pager.dart';

class DailyView extends StatefulWidget {
  final DateTime initialDate;
  final List<int> weekdays;
  final int maxItems;
  final void Function(DateTime date)? onDateChanged;

  const DailyView({
    required this.initialDate,
    required this.weekdays,
    required this.maxItems,
    this.onDateChanged,
    super.key,
  });

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
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
        DailyTabBar(
          controller: _controller,
          sync: _sync,
          height: 70.0,
          tabBuilder: (_, date) => _buildTab(date),
          onTabScrolled: widget.onDateChanged,
          onTabChanged: widget.onDateChanged,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: DailyTabView(
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  void _resetPosition() {
    _controller.animateTo(DateTime.now());
    widget.onDateChanged?.call(_controller.position);
  }
}
