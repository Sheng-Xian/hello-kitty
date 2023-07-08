// To parse this JSON data, do
//
//     final publishResponse = publishResponseFromJson(jsonString);

import 'dart:convert';

PublishResponse publishResponseFromJson(String str) =>
    PublishResponse.fromJson(json.decode(str));

String publishResponseToJson(PublishResponse data) =>
    json.encode(data.toJson());

class PublishResponse {
  PublishResponse({
    required this.code,
  });

  int code;

  factory PublishResponse.fromJson(Map<String, dynamic> json) =>
      PublishResponse(
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
      };
}
