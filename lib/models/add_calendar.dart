// To parse this JSON data, do
//
//     final addCalendar = addCalendarFromJson(jsonString);

import 'dart:convert';

AddCalendar addCalendarFromJson(String str) =>
    AddCalendar.fromJson(json.decode(str));

String addCalendarToJson(AddCalendar data) => json.encode(data.toJson());

class AddCalendar {
  String memberId;
  DateTime date;
  String projectId;
  String language;

  AddCalendar({
    required this.memberId,
    required this.date,
    required this.projectId,
    required this.language,
  });

  factory AddCalendar.fromJson(Map<String, dynamic> json) => AddCalendar(
        memberId: json["memberId"],
        date: DateTime.parse(json["date"]),
        projectId: json["projectId"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "date": date.toIso8601String(),
        "projectId": projectId,
        "language": language,
      };
}
