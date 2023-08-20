import 'package:flutter/material.dart';
import 'package:devtime/models/plan.dart';

class PlanItem extends StatelessWidget {
  const PlanItem(this.plan, {super.key});

  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(categoryIcons[plan.category]), //icon 동적으로
                const SizedBox(
                  width: 8,
                ),
                Text(plan.title),
                const Spacer(), //위젯사이공간
                Row(
                  children: [
                    Text(plan.formattedDate), //date formatting
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
