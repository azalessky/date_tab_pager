import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

class PeriodTabView extends StatefulWidget {
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  final PositionController controller;
  final SyncController sync;
  final PeriodAdapter adapter;
  final PageBuilder pageBuilder;
  final DateTimeCallback? onPageChanged;

  const PeriodTabView({
    required this.controller,
    required this.sync,
    required this.adapter,
    required this.pageBuilder,
    this.onPageChanged,
    super.key,
  });

  @override
  State<PeriodTabView> createState() => _PeriodTabViewState();
}

class _PeriodTabViewState extends State<PeriodTabView>
    with TickerProviderStateMixin {
  late DateTime _centerPage;
  late int _centerIndex;
  late int _itemCount;
  late TabController _tabController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _centerPage = widget.adapter.pageStart(widget.controller.position);
    _itemCount =
        widget.adapter.itemCount(_centerPage, widget.controller.maxItems);
    _centerIndex = _itemCount ~/ 2;

    final initialIndex = _centerIndex +
        widget.adapter.dateToIndex(_centerPage, widget.controller.position);

    _tabController = TabController(
        initialIndex: initialIndex, length: _itemCount, vsync: this);
    _tabController.addListener(_syncTabIndex);
    _tabController.animation?.addListener(_syncTabOffset);

    widget.controller.addListener(_updateFromController);
    widget.sync.barPosition.addListener(_updatePosition);
  }

  @override
  void dispose() {
    _tabController.removeListener(_syncTabIndex);
    _tabController.animation?.removeListener(_syncTabOffset);
    _tabController.dispose();

    widget.controller.removeListener(_updatePosition);
    widget.sync.barPosition.removeListener(_updatePosition);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: List.generate(
        _itemCount,
        (index) {
          final date =
              widget.adapter.indexToDate(_centerPage, index - _centerIndex);
          return widget.pageBuilder(context, date);
        },
      ),
    );
  }

  void _updateFromController() {
    if (!widget.controller.isInternalUpdate) {
      _updatePosition();
    }
  }

  void _updatePosition() {
    final pageIndex =
        widget.adapter.dateToIndex(_centerPage, widget.controller.position);

    _isAnimating = true;
    _tabController.animateTo(
      _centerIndex + pageIndex,
      duration: PeriodTabView.animationDuration,
      curve: PeriodTabView.animationCurve,
    );

    Future.delayed(PeriodTabView.animationDuration, () => _isAnimating = false);
  }

  void _syncTabIndex() {
    final index = _tabController.index - _centerIndex;
    final date = widget.adapter.indexToDate(_centerPage, index);

    if (widget.controller.position != date) {
      widget.controller.setPosition(date, true);
      widget.sync.viewPosition.value = date;
      widget.onPageChanged?.call(date);
    }
  }

  void _syncTabOffset() {
    if (!_isAnimating) {
      final offset = _tabController.offset;
      widget.sync.viewOffset.value = offset;
    }
  }
}
