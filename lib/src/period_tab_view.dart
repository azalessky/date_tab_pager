import 'package:flutter/material.dart';
import 'data_types.dart';
import 'period_adapter.dart';
import 'position_controller.dart';

class PeriodTabView extends StatefulWidget {
  static const maxPages = 2000;
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  final PositionController controller;
  final PeriodAdapter adapter;
  final PageBuilder pageBuilder;
  final DateTimeCallback? onPageChanged;

  const PeriodTabView({
    required this.controller,
    required this.adapter,
    required this.pageBuilder,
    this.onPageChanged,
    super.key,
  });

  @override
  State<PeriodTabView> createState() => _PeriodTabViewState();
}

class _PeriodTabViewState extends State<PeriodTabView> with TickerProviderStateMixin {
  late DateTime _centerPage;
  late int _centerIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _centerPage = widget.adapter.pageDate(widget.controller.position);
    _centerIndex = PeriodTabView.maxPages ~/ 2;

    final initialIndex = widget.adapter.dateToSubIndex(_centerPage, widget.controller.position);
    _pageController = PageController(initialPage: _centerIndex + initialIndex);

    widget.controller.addListener(_updatePosition);
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.controller.removeListener(_updatePosition);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: PeriodTabView.maxPages,
      itemBuilder: (context, index) {
        final date = widget.adapter.indexToDate(_centerPage, index - _centerIndex);
        return widget.pageBuilder(context, date);
      },
      onPageChanged: (index) {
        final date = widget.adapter.indexToDate(_centerPage, index - _centerIndex);
        widget.onPageChanged?.call(date);
      },
    );
  }

  void _updatePosition() {
    final pageIndex = widget.adapter.dateToPage(_centerPage, widget.controller.position);
    _pageController.animateToPage(
      _centerIndex + pageIndex,
      duration: PeriodTabView.animationDuration,
      curve: PeriodTabView.animationCurve,
    );
  }
}
