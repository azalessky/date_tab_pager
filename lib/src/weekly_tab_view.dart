import 'package:flutter/material.dart';

import 'date_time_extension.dart';
import 'weekly_tab_types.dart';
import 'weekly_tab_controller.dart';

class WeeklyTabView extends StatefulWidget {
  final WeeklyTabController controller;
  final WeeklyTabBuilder pageBuilder;
  final WeeklyTabCallback? onPageChanged;
  final ScrollPhysics? scrollPhysics;

  const WeeklyTabView({
    required this.controller,
    required this.pageBuilder,
    this.onPageChanged,
    this.scrollPhysics,
    super.key,
  });

  @override
  State<WeeklyTabView> createState() => _WeeklyTabViewState();
}

class _WeeklyTabViewState extends State<WeeklyTabView>
    with TickerProviderStateMixin {
  late List<int> _weekdays;
  late int _weekCount;
  late DateTime _centerPosition;
  late int _centerIndex;
  late PositionController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _weekdays = widget.controller.weekdays;
    _weekCount = widget.controller.weekCount;
    _controller = widget.controller.tabViewController;

    final itemCount = _weekCount * _weekdays.length;
    final initialPage = _weekdays.indexOf(_controller.position.weekday);

    _centerPosition = _controller.position.weekStart(_weekdays);
    _centerIndex = itemCount;

    _tabController = TabController(
      initialIndex: _centerIndex + initialPage,
      length: itemCount * 2,
      vsync: this,
    );

    _tabController.addListener(_syncTabIndex);
    _tabController.animation!.addListener(_syncTabOffset);
    _controller.addListener(_updatePosition);
  }

  @override
  void dispose() {
    _tabController.removeListener(_syncTabIndex);
    _tabController.animation!.removeListener(_syncTabOffset);
    _tabController.dispose();
    _controller.removeListener(_updatePosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      physics: widget.scrollPhysics,
      children: List.generate(
        _tabController.length,
        (index) => widget.pageBuilder(
          context,
          _pageToDate(index - _centerIndex),
        ),
      ),
    );
  }

  void _syncTabIndex() {
    final date = _pageToDate(_tabController.index - _centerIndex);
    widget.controller.animateTo(date);
    widget.onPageChanged?.call(date);
  }

  void _syncTabOffset() {
    final tabController = widget.controller.tabController;
    final index = tabController.index;
    final offset = _tabController.offset;

    if (!tabController.indexIsChanging && offset < 1 && offset > -1) {
      if (index == 0 && offset < 0) return;
      if (index == tabController.length - 1 && offset > 0) return;
      tabController.offset = offset;
    }
  }

  void _updatePosition() {
    final page = _centerIndex + _dateToPage(_controller.position);
    _tabController.animateTo(page);
  }

  DateTime _pageToDate(int page) {
    final weeks = page < 0
        ? (page + 1) ~/ _weekdays.length - 1
        : page ~/ _weekdays.length;
    final day = _weekdays[page % _weekdays.length] + weeks * 7;

    return _centerPosition.add(Duration(days: day - _centerPosition.weekday));
  }

  int _dateToPage(DateTime date) {
    final diff = date.differenceInDays(_centerPosition);
    final days = _weekdays.indexOf(date.weekday) -
        _weekdays.indexOf(_centerPosition.weekday);
    final weeks = diff ~/ 7 +
        (diff < 0 && days > 0 ? -1 : 0) +
        (diff > 0 && days < 0 ? 1 : 0);

    return days + _weekdays.length * weeks;
  }
}
