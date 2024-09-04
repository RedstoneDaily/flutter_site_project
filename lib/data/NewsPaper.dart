// To parse this JSON data, do
//
//     final newsPaper = newsPaperFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef JsonNewspaper = List<Map<String, dynamic>>;

NewsPaper newsPaperFromJson(String str) => NewsPaper.fromJson(json.decode(str)); // 临时的排序

// String newsPaperToJson(NewsPaper data) => json.encode(data.toJson());

class NewsPaper {
  DateTime date;
  String title = "";
  List<NewsItem> content;

  NewsPaper({
    required this.content,
  })  : date = content.first.date,
        title = content.first.title;

  factory NewsPaper.fromJson(JsonNewspaper json) => NewsPaper(
        content: List<NewsItem>.from(json.map((jsonItem) => NewsItem.fromJson(jsonItem))),
      );

// Map<String, dynamic> toJson() => {
//   "title": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//   "description": title,
//   "content": List<dynamic>.from(content.map((x) => x.toJson())),
// };
}

class NewsItem {
  // https://app.apifox.com/link/project/5069608/apis/api-209740178
  Type type;
  String title;
  String description;
  String cover;

  // tags: TODO
  int pubdate;

  // aid, bvid: TODO
  num weight;
  DateTime date;
  NewsItemData data;
  String url;

  NewsItem({
    required this.type,
    required this.title,
    required this.description,
    required this.cover,
    required this.pubdate,
    required this.weight,
    required this.date,
    required this.data,
    required this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        type: typeValues.map[json["type"]]!,
        title: json["title"],
        description: json["description"],
        cover: json["cover"],
        pubdate: json["pubdate"],
        weight: json["weight"],
        date: DateFormat('yyyy-MM-dd').parse(json["date"]),
        data: NewsItemData.fromJson(json["data"]),
        url: json["url"],
      );

// Map<String, dynamic> toJson() => {
//   "type": typeValues.reverse[type],
//   "title": title,
//   "description": description,
//   "url": url,
//   "cover_url": cover,
//   "pubdate": pubdate,
//   "data": data.toJson(),
//   "author": author.toJson(),
// };
}

class NewsItemData {
  int play;
  int danmaku;
  int like;
  int favorite;
  int review;
  Duration duration;
  Author author;

  NewsItemData({
    required this.play,
    required this.danmaku,
    required this.like,
    required this.favorite,
    required this.review,
    required this.duration,
    required this.author,
  });

  factory NewsItemData.fromJson(Map<String, dynamic> json) => NewsItemData(
        play: json["play"],
        review: json["review"],
        like: json["like"],
        favorite: json["favorite"],
        danmaku: json["danmaku"],
        duration: Duration(seconds: json["duration"].split(':').map((e) => int.parse(e)).toList().reduce((value, element) => value * 60 + element)),  // 通义灵码给的一串黑科技（？
        author: Author.fromJson(json["owner"]),
      );

// Map<String, dynamic> toJson() => {
//   "play": play,
//   "review": review,
//   "like": like,
//   "coin": coin,
//   "share": share,
//   "favorite": favorite,
//   "danmaku": danmaku,
//   "score": score,
// };
}

class Author {
  String name;
  String face;

  Author({
    required this.name,
    required this.face,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json["author"],
        face: json["face"],
      );

// Map<String, dynamic> toJson() => {
//   "name": name,
//   "upic": face,
// };
}

enum Type { video }

final typeValues = EnumValues({"video": Type.video});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
