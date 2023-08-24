import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

//날짜 데이터 변환
String convertDate(DateTime dateTime) {
  return DateFormat('yyyy.MM.d').format(dateTime);
}

const uuid = Uuid();

enum Category { school, toy, competition, work } //dart가 인식해서 문자열 값으로 취급

const categoryIcons = {
  //카테고리 아이콘
  Category.school: Icons.school, //학교 프로젝트
  Category.toy: Icons.toys, //토이 프로젝트
  Category.competition: Icons.workspace_premium_rounded, //대회 및 공모전 프로젝트
  Category.work: Icons.work_rounded, //회사 프로젝트
};

class Plan {
  //계획 클래스
  Plan({
    //생성자
    required this.title, //Flutter Course, Cinema etc..
    //required this.timer,  각 계획 별 시간 정보
    required this.description,
    required this.date, //8/11/2023
    required this.category, //food, travel, ..etc
    //id는 매개변수로 요구 x, 새로운 비용개체가 생성될때마다 동적으로 고유id 생성
  }) : id = uuid.v4();

  final String id; //모든 경비에 고유한 id
  final String title;
  //final String timer;
  final DateTime date; //플러터 날짜 관련 클래스
  final Category category;
  final String description;

  String get formattedDate {
    return convertDate(date); //날짜 정리.
  }

  Object? toJson() {
    return null;
  }
}
//uuid 패키지로 고유 ID 생성 가능
