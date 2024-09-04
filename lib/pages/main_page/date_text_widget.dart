import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../color_schemes.dart';
import '../../selector_dialog.dart';

import '../../data/data_provider.dart';

class DateTextWidget extends StatelessWidget {
  final TextStyle textStyle;

  const DateTextWidget(this.textStyle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IssuesDataProvider>(builder: (context, issuesDataProvider, child) {
      final date = issuesDataProvider.issuesData.dailyLatest?.key ?? DateTime.now();
      return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
              // onTap: () => showDialog(context: context, builder: chooserDialogBuilderBuilder(RDColors.glass)),
              onTap: () => showSelectorDialog(context: context, colors: RDColors.glass, initialDate: date),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(
                  "[${DateFormat('y.M.d').format(date)}]",
                  style: textStyle,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(Icons.arrow_drop_down, color: Colors.white, size: 40),
                )
              ])));
    });
  }
}
