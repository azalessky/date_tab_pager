import 'package:flutter/material.dart';
import 'data_types.dart';
import 'period_adapter.dart';
import 'position_controller.dart';

class PeriodTabView extends StatefulWidget {
  final PositionController controller;
  final PeriodAdapter adapter;
  final PageBuilder pageBuilder;
  final DateTimeCallback? onPageChanged;
  final ScrollPhysics? scrollPhysics;

  const PeriodTabView({
    required this.controller,
    required this.adapter,
    required this.pageBuilder,
    this.onPageChanged,
    this.scrollPhysics,
    super.key,
  });

  @override
  State<PeriodTabView> createState() => _PeriodTabViewState();
}

class _PeriodTabViewState extends State<PeriodTabView> with TickerProviderStateMixin {
  late DateTime _centerPageStart;
  late int _centerIndex;
  late PageController _pageController;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _centerPageStart = widget.adapter.pageStartFor(widget.controller.position);
    _centerIndex = 1000;
    _pageController = PageController(initialPage: _centerIndex);

    _initTabController(_centerPageStart);

    widget.controller.addListener(_updatePosition);
  }

  void _initTabController(DateTime pageStart) {
    final subCount = widget.adapter.subCount(pageStart);
    final initialIndex =
        widget.adapter.dateToSubIndex(pageStart, widget.controller.position).clamp(0, subCount - 1);

    _tabController?.dispose();
    _tabController = TabController(length: subCount, vsync: this, initialIndex: initialIndex);

    // Плавная синхронизация с таббаром
    _tabController!.animation!.addListener(() {
      final offset = _tabController!.offset;
      final index = _tabController!.index;
      final fractionalIndex = index + offset;

      final date =
          widget.adapter.subIndexToDate(pageStart, fractionalIndex.clamp(0, subCount - 1).round());
      widget.controller.setPosition(date);
      widget.controller.animateTo(date);
      widget.onPageChanged?.call(date);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController?.dispose();
    widget.controller.removeListener(_updatePosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, pageIndex) {
        final pageStart = widget.adapter.addPages(_centerPageStart, pageIndex - _centerIndex);
        final subCount = widget.adapter.subCount(pageStart);

        if (_tabController == null || _tabController!.length != subCount) {
          _initTabController(pageStart);
        }

        return TabBarView(
          controller: _tabController,
          physics: widget.scrollPhysics,
          children: List.generate(subCount, (i) {
            final date = widget.adapter.subIndexToDate(pageStart, i);
            return widget.pageBuilder(context, date);
          }),
        );
      },
      onPageChanged: (pageIndex) {
        final pageStart = widget.adapter.addPages(_centerPageStart, pageIndex - _centerIndex);
        widget.onPageChanged?.call(pageStart);

        final subCount = widget.adapter.subCount(pageStart);
        if (_tabController == null || _tabController!.length != subCount) {
          _initTabController(pageStart);
        }
      },
    );
  }

  void _updatePosition() {
    final pageOffset =
        widget.adapter.dateToPageOffset(_centerPageStart, widget.controller.position);
    final pageStart = widget.adapter.addPages(_centerPageStart, pageOffset);
    final pageIndex = _centerIndex + pageOffset;
    final subIndex = widget.adapter.dateToSubIndex(pageStart, widget.controller.position);

    if (_tabController != null && subIndex >= 0 && subIndex < _tabController!.length) {
      _tabController!.animateTo(subIndex);
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
