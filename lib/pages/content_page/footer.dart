import 'dart:math';

import 'package:flutter/material.dart';

import '../../color_schemes.dart';
import '../../media_type.dart';
import '../../nav_underlined_text.dart';


class FootWidget extends StatelessWidget {
  const FootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var scaling = min(1.0, size.width / MediaType.medium.width);
    var footerTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSecondary,
      fontSize: 20 * scaling,
      letterSpacing: 3 * scaling,
    );
    // 底部
    return Container(
      height: 100 * scaling,
      // 设置容器的高度
      width: size.width,
      color: RDColors.scarlet.surface,
      padding: EdgeInsets.all(4.0 * scaling),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '本报所有内容均由互联网平台用户创作，本报只提供收集、筛选、整理与链接等服务，所有内容均与本报无关',
            style: footerTextStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          Text(
            '本报由RSDaily项目组开发，版面由creepebucket设计',
            style: footerTextStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NavUnderlinedText.url(
                  dst: "https://beian.miit.gov.cn/",
                  text: "闽ICP备2024058720号-2",
                  style: footerTextStyle,
                  textAlign: TextAlign.center,
                  underlineColor: RDColors.scarlet.onPrimary,
                  underlineAlign: Alignment.bottomCenter
              ),
              const Padding(padding: EdgeInsets.only(left: 8)),
              Text(
                  '支持我们: ',
                  style: footerTextStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
              ),
              NavUnderlinedText.url(
                  dst: "https://afdian.com/a/crebet",
                  text: "afdian.com/a/crebet",
                  style: footerTextStyle,
                  textAlign: TextAlign.center,
                  underlineColor: RDColors.scarlet.onPrimary,
                  underlineAlign: Alignment.bottomCenter
              ),
              const Padding(padding: EdgeInsets.only(left: 8)),
              Text(
                  '开源链接: ',
                  style: footerTextStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
              ),
              NavUnderlinedText.url(
                  dst: "https://github.com/RedstoneDaily",
                  text: "github.com/RedstoneDaily",
                  style: footerTextStyle,
                  textAlign: TextAlign.center,
                  underlineColor: RDColors.scarlet.onPrimary,
                  underlineAlign: Alignment.bottomCenter
              ),
            ],
          ),
        ],
      ),
    );
  }
}
