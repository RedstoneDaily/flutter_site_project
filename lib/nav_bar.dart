import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redstone_daily_site/color_schemes.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'nav_underlined_text.dart';
import 'underlined_text.dart';
class NavBar extends StatelessWidget {
  ///
  /// 布局行为：
  /// 宽度会拉伸至最大宽度 --- 即宽度等于maxWidth约束；
  /// 高度会收缩至文字排版所需的最多高度，除非受父级限制 --- 即高度等于内部最大高度与minHeight约束的最大值。
  /// - 以上行为定义其实等效于Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center)
  /// - 原则上内部文字所需的高度是不可预测的，即使它是由textStyle.fontSize等决定的。
  ///   因此在没有约束最小高度的条件下整个导航栏的高度，包围着各文字的高度，也是不可预测的。
  ///   所以请酌情设定保留一个足够的高度（）
  const NavBar({
    super.key,
    required this.style,
  });

  final TextStyle style;
  static const flexPadding = 1;
  static const flexNavItem = 3;
  static const flexSearchBarMargin = 2;
  static const flexSearchBar = 10;

  @override
  Widget build(BuildContext context) {
    Widget navItem({required String dst, required String text, bool isRoute = true}) {
      return Flexible(
        flex: flexNavItem,
        fit: FlexFit.tight,
        child: NavUnderlinedText(
          dst: dst,
          text: text,
          isRoute: isRoute,
          style: style,
          underlineColor: RDColors.glass.onPrimary,
          underlineWidth: 1.5,
        ),
      );
    }

    Widget item({required void Function()? onTap, required String text}) {
      return Flexible(
        flex: flexNavItem,
        fit: FlexFit.tight,
        child: UnderlinedText(
          onTap: onTap,
          text: text,
          style: style,
          underlineColor: RDColors.glass.onPrimary,
          underlineWidth: 1.5,
        ),
      );
    }

    Future showConfirmDialog({required void Function()? onConfirm, required BuildContext context, required ColorScheme colors}) {
      return showDialog(
          context: context,
          barrierColor: const Color(0x45000000),
          builder: (BuildContext context) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Dialog(
                  shape: const RoundedRectangleBorder(), // actually not rounded at all
                  // shadowColor: const Color(0x22FFFFFF),
                  backgroundColor: colors.background,
                  surfaceTintColor: const Color(0x00000000), // sb
                  child: Theme(
                      data: ThemeData(colorScheme: colors),
                      child: SizedBox(
                        width: 600,
                        height: 400,
                        child: Column(mainAxisSize: MainAxisSize.max, children: [
                          const Flexible(
                              flex: 2,
                              child: Align(
                                  alignment: Alignment(0, 0.5),
                                  child: Text(
                                      "基于Vue框架和新设计开发的新页面\n"
                                      "目前仍在开发当中，\n"
                                      "您可点击此处预览，是否确认？",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20, height: 2)))),
                          Flexible(
                              flex: 1,
                              child: Center(
                                  child: InkWell(
                                      onTap: onConfirm,
                                      child: Container(
                                        width: 100,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: colors.primary,
                                        ),
                                        child: const Center(child: Text("确认", style: TextStyle(fontSize: 24))),
                                      ),
                                  ),
                              ))
                        ]),
                      )),
                ));
          });
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: flexPadding),
        Text(" / ", style: style),
        navItem(text: "日报", dst: "/daily"),
        Text(" / ", style: style),
        item(
            text: "新界面！",
            onTap: () => showConfirmDialog(
                  onConfirm: () => launchUrlString("https://rsdaily-pages.pages.dev"),
                  context: context,
                  colors: RDColors.glass,
                )),
        Text(" / ", style: style),
        navItem(text: "更多", dst: "/articles/more-info.md"),
        Text(" / ", style: style),
        const Spacer(flex: flexSearchBarMargin),
        Flexible(flex: flexSearchBar, child: searchBar()),
        const Spacer(flex: flexSearchBarMargin),
        Text(" / ", style: style),
        navItem(text: "赞助", dst: "https://afdian.com/a/crebet", isRoute: false),
        Text(" / ", style: style),
        navItem(text: "源码", dst: "https://github.com/RedstoneDaily/redstone_daily", isRoute: false),
        Text(" / ", style: style),
        navItem(text: "贡献", dst: "/articles/contribution.md"),
        Text(" / ", style: style),
        const Spacer(flex: flexPadding),
      ],
    );
  }

  Widget searchBar() {
    return TextField(
      textAlign: TextAlign.center,
      style: style,
      decoration: InputDecoration(
        hintText: "搜索日报内容",
        hintStyle: style,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        enabledBorder: UnderlineInputBorder(
          // 不是焦点的时候颜色
          borderSide: BorderSide(color: RDColors.glass.onPrimary),
        ),
        focusedBorder: UnderlineInputBorder(
          // 焦点集中的时候颜色
          borderSide: BorderSide(color: RDColors.glass.onSecondary),
        ),
      ),
    );
  }
}
