import 'package:flutter/material.dart';

import 'date_time_extension.dart';
import 'weekly_tab_controller.dart';

class WeeklyTabBar extends StatefulWidget implements PreferredSizeWidget {
  static const widgetHeight = 70.0;
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  final WeeklyTabController controller;
  final TabController tabController;
  final List<int> weekdays;
  final int weekCount;
  final Widget Function(BuildContext context, DateTime date) tabBuilder;
  final ScrollPhysics? scrollPhysics;
  final Function(DateTime date)? onTabScrolled;
  final Function(DateTime date)? onTabChanged;

  const WeeklyTabBar({
    required this.controller,
    required this.tabController,
    required this.weekdays,
    required this.weekCount,
    required this.tabBuilder,
    this.scrollPhysics,
    this.onTabScrolled,
    this.onTabChanged,
    super.key,
  });

  @override
  State<WeeklyTabBar> createState() => _WeeklyTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(widgetHeight);
}

class _WeeklyTabBarState extends State<WeeklyTabBar>
    with TickerProviderStateMixin {
  late DateTime centerPosition;
  late int centerIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    centerPosition = widget.controller.position.weekStart(widget.weekdays);
    centerIndex = widget.weekCount;

    pageController = PageController(initialPage: centerIndex);
    widget.controller.addListener(_updatePosition);
    widget.controller.animateTo(widget.controller.position);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePosition);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WeeklyTabBar.widgetHeight,
      child: PageView.builder(
        controller: pageController,
        itemCount: widget.weekCount * 2,
        itemBuilder: (context, index) => _buildTabBar(_weekToDate(index)),
        onPageChanged: (index) =>
            widget.onTabScrolled?.call(_weekToDate(index)),
      ),
    );
  }

  Widget _buildTabBar(DateTime date) {
    final isSelectedWeek = date.isSameWeek(widget.controller.position);
    final labelColor = isSelectedWeek
        ? null
        : Theme.of(context).tabBarTheme.unselectedLabelColor ??
            Theme.of(context).colorScheme.onSurfaceVariant;
    final labelStyle = isSelectedWeek
        ? null
        : Theme.of(context).tabBarTheme.unselectedLabelStyle ??
            Theme.of(context).textTheme.titleSmall;

    return TabBar(
      controller: widget.tabController,
      indicator: date.isSameWeek(widget.controller.position)
          ? null
          : const BoxDecoration(),
      labelColor: labelColor,
      labelStyle: labelStyle,
      tabs: List.generate(
        widget.weekdays.length,
        (index) => widget.tabBuilder(context, _indexToDate(date, index)),
      ),
      onTap: (index) => setState(() {
        widget.controller.setPosition(_indexToDate(date, index));
        widget.onTabChanged?.call(widget.controller.position);
      }),
    );
  }

  void _updatePosition() {
    final week = _dateToWeek(widget.controller.position);
    final index = _dateToIndex(widget.controller.position);

    if (pageController.hasClients) {
      pageController.animateToPage(
        week,
        duration: WeeklyTabBar.animationDuration,
        curve: WeeklyTabBar.animationCurve,
      );
    }
    widget.tabController.index = index;
  }

  DateTime _indexToDate(DateTime position, int index) {
    return position.add(Duration(days: widget.weekdays[index] - 1));
  }

  int _dateToIndex(DateTime date) {
    int index = widget.weekdays.indexOf(date.weekday);
    return index < 0 ? 0 : index;
  }

  DateTime _weekToDate(int week) {
    return DateUtils.addDaysToDate(
      centerPosition,
      (week - centerIndex) * DateTime.daysPerWeek,
    );
  }

  int _dateToWeek(DateTime date) {
    return centerIndex + date.differenceInWeeks(centerPosition);
  }
}
