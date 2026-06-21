import 'package:flutter/material.dart';
import '../../../../../translations.dart';

class WorkerStatsCard extends StatelessWidget {
  final int completedJobs;
  final int totalHours;

  const WorkerStatsCard({
    super.key,
    required this.completedJobs,
    required this.totalHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Completed Jobs
          Column(
            children: [
              Text(
                completedJobs.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'completed_jobs'.i18n,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          // Divider
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          // Working Hours
          Column(
            children: [
              Text(
                totalHours.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'working_hours'.i18n,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}