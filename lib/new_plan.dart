import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:devtime/models/plan.dart';
import 'package:http/http.dart' as http;

class NewPlan extends StatefulWidget {
  const NewPlan({
    super.key,
  });

  @override
  State<NewPlan> createState() => _NewPlanState();
}

class _NewPlanState extends State<NewPlan> {
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.toy; //project

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitPlanData() {
    //공백 시 에러
    if (_titleController.text.trim().isEmpty ||
        _descpController.text.trim().isEmpty ||
        _selectedDate == null) {
      //에러 메시지
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('유효하지 않은 입력값'),
          content: const Text('값을 제대로 입력해주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    _sendPlanData();

    Navigator.pop(context);
    setState(() {});
  }

//http post
  void _sendPlanData() async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      // 다른 원하는 헤더 필드도 여기에 추가 가능
    };

    final requestData = {
      "memberId": "1",
      "date": _selectedDate.toString(),
      "projectId": "1",
      "language": _descpController.text,
    };

    final response = await http.post(
      Uri.parse('http://129.154.52.27:8080/calendar/new'),
      headers: headers,
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descpController.dispose(); //컨트롤러의 불필요한 메모리 차지 제거
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text(
                'Project',
                style: TextStyle(
                    color: Color.fromRGBO(2, 73, 255, 1),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _descpController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Language',
                      style: TextStyle(
                          color: Color.fromRGBO(2, 73, 255, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _selectedDate == null
                        ? '선택된 날짜 없음.'
                        : convertDate(_selectedDate!),
                  ),
                  IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month_rounded))
                ],
              ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                          style: const TextStyle(
                              color: Color.fromRGBO(2, 73, 255, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: Color.fromRGBO(2, 73, 255, 1),
                  ),
                ),
              ),
              TextButton(
                onPressed: _submitPlanData,
                child: const Text(
                  '저장',
                  style: TextStyle(
                      color: Color.fromRGBO(2, 73, 255, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 400,
          ),
        ],
      ),
    );
  }
}
