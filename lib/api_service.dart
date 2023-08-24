import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:devtime/models/plan_model.dart';

class ApiService {
  static Future<List<PlanModel>> getTodaysPlans() async {
    List<PlanModel> planInstances = [];
    final url = Uri.parse('http://129.154.52.27:8080/calendars');
    final response = await http.get(url); //uri를 매개변수로 전달
    if (response.statusCode == 200) {
      //상태코드 200 확인
      final List<dynamic> newplans = jsonDecode(response.body);
      for (var plan in newplans) {
        planInstances.add(PlanModel.fromJson(plan));
      }

      return planInstances;
    }
    throw Error();
  }
  //서버가 응답할 때까지 기다려라.
}
