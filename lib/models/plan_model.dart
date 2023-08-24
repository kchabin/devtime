import 'package:intl/intl.dart';

//모델을 Postman의 add new calendar에 연결함.
class PlanModel {
  final String projectId, language, id;
  final int memberId;
  DateTime date;
  //named constructor
  PlanModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        memberId = json['member']['id'],
        date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['startDate']),
        language = json['language'],
        projectId = json['project']['id'].toString();
}
