import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:redstone_daily_site/pages/404_page.dart';
import 'package:redstone_daily_site/color_schemes.dart';
import 'package:redstone_daily_site/pages/coming_soon_page.dart';
import 'package:redstone_daily_site/pages/contentPage/content_page.dart';
import 'package:redstone_daily_site/pages/mainPage/main_page.dart';

import 'data_provider.dart';

void main() {
  // usePathUrlStrategy();
  runApp(MyApp());
}

void usePathUrlStrategy() {
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      ///
      /// 主页
      ///
      GoRoute(
        path: '/',
        builder: (context, state) => const MainPage(),
      ),

      ///
      /// 内容页-日报
      /// params: year, month, day
      ///
      GoRoute(
        path: '/daily/:year/:month/:day',
        builder: (context, state) {
          final year = state.pathParameters['year']!;
          final month = state.pathParameters['month']!;
          final day = state.pathParameters['day']!;
          // ... logic to fetch and display newspaper for the specified date
          final date = DateTime(int.parse(year), int.parse(month), int.parse(day));
          return ContentPage(date: date); // Pass date to ContentPage
        },
      ),

      /// 最新日报
      GoRoute(
        path: '/daily',
        redirect: (context, state) async {
          IssuesDataProvider issuesListProvider = Provider.of<IssuesDataProvider>(context, listen: false);
          return '/daily/${DateFormat("yyyy/MM/dd").format(await issuesListProvider.getLatestDate())}';
        },
      ),

      ///
      /// 随机页面 （目前是随机日报）
      ///
      GoRoute(
          path: "/random",
          redirect: (context, state) {
            var list = Provider.of<IssuesDataProvider>(context, listen: false).issuesData.dailiesFlattened.entries.toList();
            return '/daily/${DateFormat("yyyy/MM/dd").format(list[Random().nextInt(list.length)].key)}';
          }),

      ///
      /// 404 页面
      ///
      GoRoute(
        path: '/404/:random',
        builder: (context, state) => Status404Page(key: Key(state.pathParameters['random']!)),
      ),
      GoRoute(
        path: '/404',
        redirect: (_, state) => '/404/${Random().nextInt(100000)}',
      ),

      ///
      /// 待开发页面
      ///
      GoRoute(
        path: '/coming-soon',
        builder: (context, state) => const ComingSoonPage(), // 在路由中包含 ComingSoonPage
      ),
    ],
    errorBuilder: (context, state) => Status404Page(key: Key(state.error.toString())),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IssuesDataProvider()),
        ],
        child: MaterialApp.router(
          title: '红石日报',
          theme: ThemeData(
            colorScheme: RDColors.white,
            useMaterial3: true,
            fontFamily: 'FontquanXinYiGuanHeiTi',
            fontFamilyFallback: const ['Noto Sans SC'],
          ),
          routerConfig: _router,
        ));
  }
}
