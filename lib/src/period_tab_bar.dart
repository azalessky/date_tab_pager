import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_adapter.dart';
import 'position_controller.dart';

class PeriodTabBar extends StatefulWidget implements PreferredSizeWidget {
  static const maxUnits = 1000;
  static const widgetHeight = 70.0;
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  final PositionController controller;
  final PeriodAdapter adapter;
  final TabBuilder tabBuilder;
  final DateTimeCallback? onTabScrolled;
  final DateTimeCallback? onTabChanged;
  final ScrollPhysics? scrollPhysics;

  const PeriodTabBar({
    required this.controller,
    required this.adapter,
    required this.tabBuilder,
    this.onTabScrolled,
    this.onTabChanged,
    this.scrollPhysics,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(widgetHeight);

  @override
  State<PeriodTabBar> createState() => _PeriodTabBarState();
}

class _PeriodTabBarState extends State<PeriodTabBar> with TickerProviderStateMixin {
  late DateTime _centerPageStart;
  late int _centerIndex;
  late PageController _pageController;
  final Map<int, TabController> _tabControllers = {};

  @override
  void initState() {
    super.initState();

    _centerPageStart = widget.adapter.pageStartFor(widget.controller.position);
    _centerIndex = PeriodTabBar.maxUnits;
    _pageController = PageController(initialPage: _centerIndex);
    widget.controller.addListener(_updatePosition);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePosition);
    _pageController.dispose();
    for (var c in _tabControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PeriodTabBar.widgetHeight,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final pageDate = widget.adapter.addPages(_centerPageStart, index - _centerIndex);
          final tabController = _initTabController(index: index, pageDate: pageDate);

          return _buildTabBar(pageDate, tabController);
        },
        onPageChanged: (index) {
          final pageDate = widget.adapter.addPages(_centerPageStart, index - _centerIndex);
          widget.onTabScrolled?.call(pageDate);
        },
      ),
    );
  }

  TabController _initTabController({
    required int index,
    required DateTime pageDate,
  }) {
    final count = widget.adapter.subCount(pageDate);

    var tabController = _tabControllers[index];
    if (tabController == null || tabController.length != count) {
      final initialIndex = widget.adapter.dateToSubIndex(pageDate, widget.controller.position);

      tabController?.dispose();
      tabController = TabController(length: count, vsync: this, initialIndex: initialIndex);

      tabController.addListener(() {
        if (!tabController!.indexIsChanging) return;
        final date = widget.adapter.subIndexToDate(pageDate, tabController.index);
        widget.controller.animateTo(date);
        widget.onTabChanged?.call(date);
      });

      _tabControllers[index] = tabController;
    }

    return tabController;
  }

  Widget _buildTabBar(DateTime pageStart, TabController tabController) {
    final isSelected = pageStart == widget.adapter.pageStartFor(widget.controller.position);

    final labelColor = isSelected
        ? null
        : Theme.of(context).tabBarTheme.unselectedLabelColor ??
            Theme.of(context).colorScheme.onSurfaceVariant;
    final labelStyle = isSelected
        ? null
        : Theme.of(context).tabBarTheme.unselectedLabelStyle ??
            Theme.of(context).textTheme.titleSmall;

    final count = widget.adapter.subCount(pageStart);

    return TabBar(
      controller: tabController,
      indicator: isSelected ? null : const BoxDecoration(),
      labelColor: labelColor,
      labelStyle: labelStyle,
      tabs: List.generate(
        count,
        (index) => widget.tabBuilder(
          context,
          widget.adapter.subIndexToDate(pageStart, index),
        ),
      ),
      onTap: (index) {
        final date = widget.adapter.subIndexToDate(pageStart, index);
        widget.controller.animateTo(date);
        widget.onTabChanged?.call(date);
      },
    );
  }

  void _updatePosition() {
    final pageOffset =
        widget.adapter.dateToPageOffset(_centerPageStart, widget.controller.position);
    final pageStart = widget.adapter.addPages(_centerPageStart, pageOffset);
    final pageIndex = _centerIndex + pageOffset;

    final subIndex = widget.adapter.dateToSubIndex(pageStart, widget.controller.position);

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        pageIndex,
        duration: PeriodTabBar.animationDuration,
        curve: PeriodTabBar.animationCurve,
      );
    }

    final tabController = _tabControllers[pageIndex];
    if (tabController != null && subIndex >= 0 && subIndex < tabController.length) {
      tabController.animateTo(subIndex);
    }
  }
}
