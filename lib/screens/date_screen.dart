import 'package:devtime/api_service.dart';
import 'package:devtime/models/plan.dart';
import 'package:devtime/models/plan_model.dart';
import 'package:devtime/new_plan.dart';
import 'package:http/http.dart' as http;
import 'package:devtime/plan_item.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DateScreen extends StatefulWidget {
  const DateScreen({
    super.key,
  });
  // final void Function(Plan plan) onAddPlan;

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  DateTime? _selectedDate;
  final Category _selectedCategory = Category.toy;

  late Map<DateTime, List<Plan>> mySelectedEvents;

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  DateTime? selectedCalendarDate;

  final Future<List<PlanModel>> _registeredPlans = ApiService.getTodaysPlans();

  @override
  void initState() {
    selectedCalendarDate = focusedDay;
    mySelectedEvents = {};

    super.initState();
  }

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

  //ChatGPT가 알려줌..
  Future<List<PlanModel>> _getPlansForSelectedDate(
      DateTime selectedDate) async {
    final plans = await _registeredPlans;
    final plansForSelectedDate =
        plans.where((plan) => isSameDay(plan.date, selectedDate)).toList();
    return plansForSelectedDate;
  }

  @override
  void dispose() {
    //컨트롤러의 불필요한 메모리 차지 제거
    _descpController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _openAddPlanOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      //아래에서 위로 올라오는 화면
      context: context,
      builder: (ctx) => const NewPlan(),
      backgroundColor: Colors.white,
    );
    /*setState(() {
      _registeredPlans = ApiService.getTodaysPlans();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DevTIME',
          style: TextStyle(
              color: Color.fromRGBO(2, 73, 255, 1),
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      //계획 추가용 플로팅 버튼
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddPlanOverlay(),
        label: const Text(
          'Add',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(2, 73, 255, 1),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: TableCalendar(
                locale: 'ko_KR', //캘린더 한국어 설정
                focusedDay: focusedDay,
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(
                  2100,
                  12,
                  31,
                ),

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMMMd(locale).format(date),
                  formatButtonVisible: false, //2weeks 버튼이 사라짐
                  titleTextStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  headerPadding: const EdgeInsets.symmetric(vertical: 2.0),

                  leftChevronIcon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(2, 73, 255, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  //선택된 날짜의 상태 갱신

                  setState(() {
                    this.selectedDay = selectedDay;
                    this.focusedDay = focusedDay;
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  //선택된 날짜와 동일한 날짜 선택 시 모양 변경
                  return isSameDay(selectedDay, day);
                },

                calendarStyle: const CalendarStyle(
                  tablePadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  selectedDecoration: BoxDecoration(
                      color: Colors.orange, shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(
                    //오늘 날짜 표시
                    color: Color.fromRGBO(2, 73, 255, 1),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    return FutureBuilder<List<PlanModel>>(
                      future: _getPlansForSelectedDate(day),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Handle loading state
                          return const SizedBox
                              .shrink(); // or a loading indicator
                        } else if (snapshot.hasError) {
                          // Handle error state
                          return const SizedBox.shrink(); // or an error widget
                        } else {
                          final plansForDate = snapshot.data ?? [];
                          if (plansForDate.isNotEmpty) {
                            return Positioned(
                              bottom: 1,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 개발',
                    style: TextStyle(
                        color: Color.fromRGBO(2, 73, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: _getPlansForSelectedDate(selectedDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터를 아직 가져오지 못한 경우 로딩 표시
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // 데이터 가져오기 중에 오류가 발생한 경우
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // 데이터가 없는 경우 또는 빈 리스트인 경우
                  return const Center(
                    child: Text('No plans available.'),
                  );
                } else {
                  // 데이터가 있을 경우 ListView.builder를 사용하여 데이터 표시
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final plan = snapshot.data![index];
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(2, 73, 255, 1),
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                            title: Text(
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(plan.date),
                              style: const TextStyle(color: Colors.white),
                            ), // 예시로 projectId를 표시

                            subtitle: Text(
                              plan.language,
                              style: const TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(
                              Icons.computer_rounded,
                              color: Colors.white,
                            )),
                      );
                    },
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
