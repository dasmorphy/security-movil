import 'package:flutter/material.dart';


class TechTaskHeader {
  final String client;
  final String codeTask;
  final String location;
  final String createdBy;

  const TechTaskHeader({
    required this.client,
    required this.codeTask,
    required this.location,
    required this.createdBy,
  });
}

class RecordTechnicalHeader extends StatelessWidget {
  final TechTaskHeader taskData;


  const RecordTechnicalHeader({
    super.key,
    required this.taskData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 75, 83, 83),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CLIENTE',
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    taskData.client,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 76, 195, 233),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 12,
              //     vertical: 6,
              //   ),
              //   decoration: BoxDecoration(
              //     color: getStatusColorEntryAccess(taskData.status).withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Text(
              //     taskData.status,
              //     style: TextStyle(
              //       color: getStatusColorEntryAccess(taskData.status),
              //       fontSize: 12,
              //       fontWeight: FontWeight.bold,
              //       letterSpacing: 0.5,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoColumn(
                  label: 'UBICACIÓN',
                  value: taskData.location,
                  icon: Icons.location_on,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoColumn(
                  label: 'REALIZADA POR',
                  value: taskData.createdBy,
                  icon: Icons.person,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 150, 150, 150),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 150, 150, 150),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
