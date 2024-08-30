import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:redstone_daily_site/color_schemes.dart';
import 'package:redstone_daily_site/jsonobject/IssuesData.dart';
import 'package:redstone_daily_site/jsonobject/NewsPaper.dart';
import 'package:redstone_daily_site/main.dart';
import 'package:redstone_daily_site/media_type.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../data_provider.dart';
import 'content_widget.dart';


double lerp(double a, double b, double t) {
  return a + (b - a) * t;
}

double inverseLerp(double a, double b, double x) {
  return (x - a) / (b - a);
}

// 网站内容列表
class SilverContentList extends StatefulWidget {
  const SilverContentList({super.key, required this.date});

  final DateTime date;
  get year => date.year.toString();
  get month => date.month.toString().padLeft(2, '0');
  get day => date.day.toString().padLeft(2, '0');

  @override
  State<SilverContentList> createState() => _SilverContentListState();
}

class _SilverContentListState extends State<SilverContentList> {
  static const double listPaddingMedium = 280;
  static const double listPaddingSmall = 0;
  static const double listInnerPadding = 20;

  // for large device, it is free
  static const double itemPadding = 20;

  @override
  void initState() {
    super.initState();
  }

  Widget getErrorWidget() {
    return SliverFillRemaining(
      child: Container(
        color: RDColors.white.surface,
        child: Center(child: Text('无法加载内容，请刷新页面重试', style: TextStyle(color: RDColors.white.onSurface))),
      ),
    );
  }

  Widget getLoadingUI(){
    return SliverFillRemaining(
      child: Container(
        color: RDColors.white.surface,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<IssuesDataProvider>(context, listen: true);
    Provider.of<IssuesDataProvider>(context).updateSingle(widget.date);
    // return FutureBuilder(
    //     future: provider.updateSingle(widget.date),
    //     builder: (context, snapshot){
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return getLoadingUI();
    //       } else if (snapshot.hasError) {
    //         return getErrorWidget();
    //       } else {
    //         return buildWithNewsPaper(snapshot.data!.dailiesFlattened[widget.date], context);
    //       }
    //     }
    // );
    return Consumer<IssuesDataProvider>(builder: (context, provider, child) {
      final newspaper = provider.issuesData.dailiesFlattened[widget.date];
      if(newspaper == null) return getLoadingUI();
      return buildWithNewsPaper(newspaper, context);
    });
  }

  List<ContentWidget> buildItemWidgets(NewsPaper paper) {
    List<ContentWidget> items = [];
    paper.content.asMap().entries.forEach((entry) {
      var index = entry.key;
      var content = entry.value;
      items.add(ContentWidget(
        key: Key('content-${content.url}'),
        url: content.url,
        imageUrl: content.cover,
        title: content.title,
        description: content.description,
        ranking: index + 1,
      ));
    });
    return items;
  }

  // 根据NewsPaper结构进行页面的构建
  Widget buildWithNewsPaper(NewsPaper paper, BuildContext context) {
    var mediaType = getMediaType(context);
    var size = MediaQuery.of(context).size;
    var itemScaling = min(1.0, size.width / MediaType.medium.width);

    var items = buildItemWidgets(paper);

    var commonItems = <ContentWidget>[];
    commonItems.addAll(items);
    commonItems.removeRange(0, 3);

    var maxWidth = MediaType.large.width - 2 * listPaddingMedium;

    return SliverPadding(
        // 设置两边平行同步
        padding: EdgeInsets.symmetric(
          horizontal: switch (mediaType) {
            MediaType.small => listPaddingSmall,
            MediaType.medium => lerp(listPaddingSmall, listPaddingMedium, inverseLerp(MediaType.medium.width, MediaType.large.width, size.width)),
            MediaType.large => (size.width - maxWidth) / 2,
          },
        ),
        sliver: DecoratedSliver(
          decoration: BoxDecoration(
            color: RDColors.white.surface,
          ),
          sliver: SliverPadding(
            padding: EdgeInsets.fromLTRB(listInnerPadding, itemPadding * itemScaling, listInnerPadding, 0),
            sliver: MultiSliver(
              children: [
                SliverPadding(
                    padding: EdgeInsets.only(bottom: 25 * itemScaling),
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                      height: ContentWidget.maxHeightHeader * itemScaling,
                      child: items[0],
                    ))),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: itemPadding * itemScaling),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: mediaType == MediaType.small ? 1 : 2,
                      mainAxisExtent: (mediaType == MediaType.small ? 1.5 : 1) * ContentWidget.maxHeightSubHeader * itemScaling,
                      crossAxisSpacing: itemPadding * itemScaling,
                      mainAxisSpacing: itemPadding * itemScaling,
                    ),
                    delegate: SliverChildListDelegate([items[1], items[2]]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 30),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: mediaType == MediaType.small ? 1 : 2,
                      mainAxisExtent: (mediaType == MediaType.small ? 1.5 : 1) * ContentWidget.maxHeightContent * itemScaling,
                      crossAxisSpacing: itemPadding * itemScaling,
                      mainAxisSpacing: itemPadding * itemScaling,
                    ),
                    delegate: SliverChildListDelegate(commonItems),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
