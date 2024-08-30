import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'jsonobject/IssuesData.dart';
import 'package:http/http.dart' as http;

class IssuesDataProvider extends ChangeNotifier {
  static const String _defaultApiHost = "api.rsdaily.com";
  static const String apiHost = String.fromEnvironment('API_HOST', defaultValue: _defaultApiHost);
  static const String apiVer = "/v2/";
  static const String latestApi = "daily/";
  static const String earliestApi = "daily/earliest";
  static const String rangeQueryApi = "daily/query";

  final IssuesData _issuesData;

  IssuesData get issuesData => _issuesData;

  IssuesDataProvider() : _issuesData = IssuesData(dailies: SplayTreeMap());

  Future<DateTime> getLatestDate() async {
    final resLatest = await http.get(Uri.https(apiHost, apiVer + latestApi));
    if (resLatest.statusCode != 200) {
      throw Exception('Failed to load the latest newspaper content. Status code: ${resLatest.statusCode}');
    }
    return DateFormat("yyyy-MM-dd").parse((jsonDecode(resLatest.body) as List).cast<Map<String, dynamic>>().first["date"]);
  }

  Future<DateTime> getEarliestDate() async {
    final resEarliest = await http.get(Uri.https(apiHost, apiVer + earliestApi));
    if (resEarliest.statusCode != 200) {
      throw Exception('Failed to load the earliest newspaper content. Status code: ${resEarliest.statusCode}');
    }
    return DateFormat("yyyy-MM-dd").parse((jsonDecode(resEarliest.body) as List).cast<Map<String, dynamic>>().first["date"]);
  }

  Future<IssuesData> fetchAll() async {
    try {
      final latestDate = await getLatestDate();
      final earliestDate = await getEarliestDate();
      // Iterate over whole-month intervals, update the list
      for (DateTime date = DateUtils.addMonthsToMonthDate(earliestDate, 0);
          date.isBefore(DateUtils.addMonthsToMonthDate(latestDate, 1));
          date = DateUtils.addMonthsToMonthDate(date, 1)) {
        final endDate = DateUtils.addMonthsToMonthDate(date, 1).subtract(const Duration(days: 1));
        _updateRange(date, endDate, force: true);
      }
      notifyListeners();
      return _issuesData;
    } catch (error) {
      print('Error occurred: $error');
      rethrow;
    }
  }

  Future<IssuesData> updateSingle(DateTime date) async {
    final data = _updateRange(date, date.add(const Duration(days: 1)));
    notifyListeners();
    return data;
  }

  Future<IssuesData> updateMonth(DateTime monthDate) async {
    final data = _updateRange(
      DateUtils.addMonthsToMonthDate(monthDate, 0),
      DateUtils.addMonthsToMonthDate(monthDate, 1),
    );
    notifyListeners();
    return data;
  }

  Future<IssuesData> updateYear(int year) async {
    final data = _updateRange(
      DateTime(year, 1, 1),
      DateTime(year + 1, 1, 1),
    );
    notifyListeners();
    return data;
  }

  // Note: endDate is exclusive
  Future<IssuesData> updateRange(DateTime startDate, DateTime endDate) {
    final data = _updateRange(startDate, endDate);
    notifyListeners();
    return data;
  }

  // Note: endDate is exclusive
  Future<IssuesData> _updateRange(DateTime startDate, DateTime endDate, {bool force = false}) {
    return http
        .get(Uri.https(apiHost, apiVer + rangeQueryApi, {
      'start_date': DateFormat("yyyy-MM-dd").format(startDate),
      'end_date': DateFormat("yyyy-MM-dd").format(endDate.subtract(const Duration(days: 1))),
    }))
        .then((res) {
      if (res.statusCode == 200) {
        if (force || _issuesData.dailies.isEmpty) {
          _issuesData.dailies.clear();
        }
        return _issuesData..update(parseIssuesData(res.body));
      } else {
        throw Exception('Failed to load data. Status code: ${res.statusCode}');
      }
    });
  }
}
