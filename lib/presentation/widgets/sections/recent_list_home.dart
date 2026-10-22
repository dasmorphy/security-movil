import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              Column(
                children: [
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () => context.push(routeLink),
                    child: Text(
                      "Ver más",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.colors.info,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
