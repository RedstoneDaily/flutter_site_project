import 'dart:io';

import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/data_provider.dart';
import 'content_list.dart';
import 'footer.dart';
import 'header.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key, required this.date});

  ContentPage.fromStr({super.key, required yearStr, required monthStr, required dayStr})
      : date = DateTime.utc(int.parse(yearStr), int.parse(monthStr), int.parse(dayStr));

  final DateTime date;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<IssuesDataProvider>(context, listen: false).updateSingle(widget.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: DynMouseScroll(
            durationMS: 50,
            builder: (context, controller, physics) {
              return CustomScrollView(scrollDirection: Axis.vertical, controller: controller, physics: physics, slivers: [
                SliverToBoxAdapter(child: HeadWidget(date: widget.date)),
                SilverContentList(date: widget.date, key: Key("daily ${DateFormat("yyyy-MM-dd").format(widget.date)}")),
                const SliverFillRemaining(hasScrollBody: false, child: Column(verticalDirection: VerticalDirection.up, children: [FootWidget()])),
              ]);
            }));
  }
}
