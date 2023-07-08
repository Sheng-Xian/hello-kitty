// To parse this JSON data, do
//
//     final feedingRecordsModel = feedingRecordsModelFromJson(jsonString);

import 'dart:convert';

FeedingRecordsModel feedingRecordsModelFromJson(String str) =>
    FeedingRecordsModel.fromJson(json.decode(str));

String feedingRecordsModelToJson(FeedingRecordsModel data) =>
    json.encode(data.toJson());

class FeedingRecordsModel {
  FeedingRecordsModel({
    required this.data,
    required this.error,
    required this.message,
  });

  List<FeedingRecordsData> data;
  bool error;
  String message;

  factory FeedingRecordsModel.fromJson(Map<String, dynamic> json) =>
      FeedingRecordsModel(
        data: List<FeedingRecordsData>.from(
            json["data"].map((x) => FeedingRecordsData.fromJson(x))),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error": error,
        "message": message,
      };
}

class FeedingRecordsData {
  FeedingRecordsData({
    required this.feedDate,
    required this.foodWeight,
    required this.id,
    required this.index,
    required this.type,
  });

  String feedDate;
  double foodWeight;
  int id;
  int index;
  String type;

  factory FeedingRecordsData.fromJson(Map<String, dynamic> json) =>
      FeedingRecordsData(
        feedDate: json["feed_date"],
        foodWeight: json["food_weight"],
        id: json["id"],
        index: json["index"],
        type: json["type"]!,
      );

  Map<String, dynamic> toJson() => {
        "feed_date": feedDate,
        "food_weight": foodWeight,
        "id": id,
        "index": index,
        "type": type,
      };
}
