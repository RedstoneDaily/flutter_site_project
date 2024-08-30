// To parse this JSON data, do
//
//     final newsPaper = newsPaperFromJson(jsonString);

import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:memoize/memoize.dart';
import 'package:redstone_daily_site/jsonobject/NewsPaper.dart';

typedef DailiesMonthData = Map<DateTime, NewsPaper>;
typedef DailiesYearData = Map<int, DailiesMonthData>;
typedef DailiesData = Map<int, DailiesYearData>;

IssuesData parseIssuesData(String str) =>
    IssuesData.fromJson((jsonDecode(str) as Map).cast<String, dynamic>());

class IssuesData {
  /// Guaranteed to be sorted, and not null
  final DailiesData dailies;

  IssuesData({DailiesData? dailies}) : dailies = dailies ?? SplayTreeMap();

  MapEntry<DateTime, NewsPaper>? get dailyLatest {
    try {
      return dailies.values.last.values.last.entries.last;
    } catch (e) {
      return null;
    }
  }

  Map<DateTime, NewsPaper> get dailiesFlattened =>
      dailies.values
          .expand((e) => e.values)
          .expand((e) => e.entries)
          .fold(SplayTreeMap(), (map, entry) => map..putIfAbsent(entry.key, () => entry.value));

  void update(IssuesData newIssuesList) {
    newIssuesList.dailies.forEach((yearKey, newYearData) {
      dailies.update(yearKey, (thisYearData) {
        newYearData.forEach((monthKey, newMonthData) {
          thisYearData.update(monthKey, (thisMonthData) => thisMonthData..addAll(newMonthData), ifAbsent: () => newMonthData);
        });
        return thisYearData;
      }, ifAbsent: () => newYearData);
    });
  }

  // @formatter:off
  factory IssuesData.fromJson(Map<String, dynamic> jsonDailies) => IssuesData(
        dailies: (
            jsonDailies.entries
                .where((entry) => entry.value.isNotEmpty)
                .map((entry) => MapEntry(
                  DateFormat('yyyy-MM-dd').parse(entry.key),
                  NewsPaper.fromJson((entry.value as List).cast<Map<String, dynamic>>()),
                ))
                .toList()
                ..sort((a, b) => a.key.compareTo(b.key)))
                .fold<DailiesData>(
                  SplayTreeMap(),
                  (DailiesData map, MapEntry<DateTime, NewsPaper> item) {
                    final year = item.key.year;
                    final month = item.key.month;
                    map.putIfAbsent(year, () => SplayTreeMap());
                    map[year]!.putIfAbsent(month, () => SplayTreeMap());
                    map[year]![month]!.putIfAbsent(item.key, () => item.value);
                    return map;
                  },
                ),
      );
  // @formatter:on

// Map<int, Map<int, List<String>>> toJsonObject() => daily.map<int, Map<int, List<String>>>(
//     (yearKey, year) => MapEntry(
//         yearKey,
//         year.map((monthKey, month) => MapEntry(
//             monthKey, month.map((day) => day.toString()).toList())
//         )
//     )
// );
}
