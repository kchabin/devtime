import 'package:devtime/plan_item.dart';
import 'package:devtime/models/plan.dart';
import 'package:flutter/material.dart';

class PlansList extends StatelessWidget {
  const PlansList({
    super.key,
    required this.plans,
    required this.onRemovePlan,
  }); //생성자

  final List<Plan> plans;
  final void Function(Plan plan) onRemovePlan;

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return const Center(
        child: Text('계획이 없습니다.'),
      );
    }
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(plans[index]),
        onDismissed: (direction) {
          onRemovePlan(plans[index]);
        },
        child: PlanItem(
          plans[index],
        ),
      ),
    );
  }
}
