import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

class PeriodTabBar extends StatefulWidget implements PreferredSizeWidget {
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  final PositionController controller;
  final SyncController sync;
  final PeriodAdapter adapter;
  final double height;
  final EdgeInsets? labelPadding;
  final TabBuilder tabBuilder;
  final DateTimeCallback? onTabScrolled;
  final DateTimeCallback? onTabChanged;

  const PeriodTabBar({
    required this.controller,
    required this.sync,
    required this.adapter,
    required this.height,
    this.labelPadding,
    required this.tabBuilder,
    this.onTabScrolled,
    this.onTabChanged,
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<PeriodTabBar> createState() => _PeriodTabBarState();
}

class _PeriodTabBarState extends State<PeriodTabBar>
    with TickerProviderStateMixin {
  late DateTime _centerPage;
  late int _centerIndex;
  late int _pageCount;
  late PageController _pageController;
  final Map<int, TabController> _tabControllers = {};

  @override
  void initState() {
    super.initState();

    _centerPage = widget.adapter.pageDate(widget.controller.position);
    _pageCount =
        widget.adapter.pageCount(_centerPage, widget.controller.maxItems);
    _centerIndex = _pageCount ~/ 2;
    _pageController = PageController(initialPage: _centerIndex);

    widget.controller.addListener(_updateFromContoller);
    widget.sync.viewPosition.addListener(_updateFromView);
    widget.sync.viewOffset.addListener(_syncTabOffset);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabControllers.forEach((_, c) => c.dispose());
    _tabControllers.clear();

    widget.controller.removeListener(_updateFromContoller);
    widget.sync.viewPosition.removeListener(_updateFromView);
    widget.sync.viewOffset.removeListener(_syncTabOffset);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _pageCount,
        itemBuilder: (_, index) => _buildTabBar(index),
        onPageChanged: (index) {
          final pageDate =
              widget.adapter.pageToDate(_centerPage, index - _centerIndex);
          widget.onTabScrolled?.call(pageDate);
        },
      ),
    );
  }

  TabController _initTabController(int pageIndex, DateTime pageDate) {
    final tabCount = widget.adapter.pageSize(pageDate);

    var tabController = _tabControllers[pageIndex];
    if (tabController == null || tabController.length != tabCount) {
      final tabIndex =
          widget.adapter.dateToSubIndex(pageDate, widget.controller.position);

      tabController?.dispose();
      tabController =
          TabController(initialIndex: tabIndex, length: tabCount, vsync: this);
      _tabControllers[pageIndex] = tabController;
    }

    return tabController;
  }

  Widget _buildTabBar(int pageIndex) {
    final pageDate =
        widget.adapter.pageToDate(_centerPage, pageIndex - _centerIndex);
    final tabController = _initTabController(pageIndex, pageDate);
    final tabCount = widget.adapter.pageSize(pageDate);
    final isSelected =
        pageDate == widget.adapter.pageDate(widget.controller.position);

    return TabBar(
      controller: tabController,
      indicator: isSelected ? null : const BoxDecoration(),
      labelColor: _labelColor(context, isSelected),
      labelStyle: _labelStyle(context, isSelected),
      labelPadding: widget.labelPadding,
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
        widget.sync.barPosition.value = date;
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

  void _updateFromView() {
    _updatePosition(false);
  }

  void _updateFromContoller() {
    _updatePosition(true);
  }

  void _updatePosition(bool animate) {
    final pageOffset =
        widget.adapter.dateToPage(_centerPage, widget.controller.position);
    final pageDate = widget.adapter.pageToDate(_centerPage, pageOffset);
    final pageIndex = _centerIndex + pageOffset;
    final subIndex =
        widget.adapter.dateToSubIndex(pageDate, widget.controller.position);

    _pageController.animateToPage(
      pageIndex,
      duration: PeriodTabBar.animationDuration,
      curve: PeriodTabBar.animationCurve,
    );

    final tabController = _tabControllers[pageIndex];
    if (tabController != null) {
      if (animate) {
        tabController.animateTo(subIndex);
      } else {
        tabController.index = subIndex;
      }
    }
  }

  void _syncTabOffset() {
    final pageOffset =
        widget.adapter.dateToPage(_centerPage, widget.controller.position);
    final pageIndex = _centerIndex + pageOffset;

    final tabController = _tabControllers[pageIndex];
    if (tabController == null) return;

    final index = tabController.index;
    final offset = widget.sync.viewOffset.value;

    if (!tabController.indexIsChanging && offset.abs() < 1) {
      if (index == 0 && offset < 0) return;
      if (index == tabController.length - 1 && offset > 0) return;
      tabController.offset = offset;
    }
  }
}
