import 'package:flutter/material.dart';
import 'package:devtime/models/plan.dart';

class PlanItem extends StatelessWidget {
  const PlanItem(this.plan, {super.key});

  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(2, 73, 255, 1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  categoryIcons[plan.category],
                  color: Colors.white,
                ), //icon 동적으로
                const SizedBox(
                  width: 8,
                ),
                Text(
                  plan.title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(), //위젯사이공간
                Row(
                  children: [
                    Text(
                      plan.formattedDate,
                      style: const TextStyle(color: Colors.white),
                    ), //date formatting
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
