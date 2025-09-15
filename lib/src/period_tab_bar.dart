import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_adapter.dart';
import 'position_controller.dart';

class PeriodTabBar extends StatefulWidget implements PreferredSizeWidget {
  static const maxPages = 2000;
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
  late DateTime _centerPage;
  late int _centerIndex;
  late PageController _pageController;
  final Map<int, TabController> _tabControllers = {};

  @override
  void initState() {
    super.initState();

    _centerPage = widget.adapter.pageDate(widget.controller.position);
    _centerIndex = PeriodTabBar.maxPages ~/ 2;
    _pageController = PageController(initialPage: _centerIndex);

    widget.controller.addListener(_updatePosition);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePosition);

    _pageController.dispose();
    _tabControllers.forEach((_, c) => c.dispose());
    _tabControllers.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PeriodTabBar.widgetHeight,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (_, index) => _buildTabBar(index),
        onPageChanged: (index) {
          final pageDate = widget.adapter.addPages(_centerPage, index - _centerIndex);
          widget.onTabScrolled?.call(pageDate);
        },
      ),
    );
  }

  TabController _initTabController(int pageIndex, DateTime pageDate) {
    final tabCount = widget.adapter.subCount(pageDate);

    var tabController = _tabControllers[pageIndex];
    if (tabController == null || tabController.length != tabCount) {
      final tabIndex = widget.adapter.dateToSubIndex(pageDate, widget.controller.position);

      tabController?.dispose();
      tabController = TabController(initialIndex: tabIndex, length: tabCount, vsync: this);
      _tabControllers[pageIndex] = tabController;
    }

    return tabController;
  }

  Widget _buildTabBar(int pageIndex) {
    final pageDate = widget.adapter.addPages(_centerPage, pageIndex - _centerIndex);
    final tabController = _initTabController(pageIndex, pageDate);
    final tabCount = widget.adapter.subCount(pageDate);
    final isSelected = pageDate == widget.adapter.pageDate(widget.controller.position);

    return TabBar(
      controller: tabController,
      indicator: isSelected ? null : const BoxDecoration(),
      labelColor: _labelColor(context, isSelected),
      labelStyle: _labelStyle(context, isSelected),
      tabs: List.generate(
        tabCount,
        (index) => widget.tabBuilder(
          context,
          widget.adapter.subIndexToDate(pageDate, index),
        ),
      ),
      onTap: (index) => setState(() {
        final date = widget.adapter.subIndexToDate(pageDate, index);
        widget.controller.setPosition(date);
        widget.onTabChanged?.call(date);
      }),
    );
  }

  Color? _labelColor(BuildContext context, bool isSelected) {
    return isSelected
        ? null
        : Theme.of(context).tabBarTheme.unselectedLabelColor ??
            Theme.of(context).colorScheme.onSurfaceVariant;
  }

  TextStyle? _labelStyle(BuildContext context, bool isSelected) {
    return isSelected
        ? null
        : Theme.of(context).tabBarTheme.unselectedLabelStyle ??
            Theme.of(context).textTheme.titleSmall;
  }

  void _updatePosition() {
    final pageOffset = widget.adapter.dateToPageOffset(_centerPage, widget.controller.position);
    final pageDate = widget.adapter.addPages(_centerPage, pageOffset);
    final pageIndex = _centerIndex + pageOffset;
    final subIndex = widget.adapter.dateToSubIndex(pageDate, widget.controller.position);

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
