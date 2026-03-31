import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecentListHome extends StatelessWidget {
  final String title;
  final String routeLink;
  final Widget childListBuild;

  const RecentListHome({
    super.key, 
    required this.title, 
    required this.routeLink,
    required this.childListBuild
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 4),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.push(routeLink),
                    child: const Padding(
                      padding: EdgeInsets.all(7),
                      child: Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          childListBuild,
        ],
      ),
    );
  }
}
