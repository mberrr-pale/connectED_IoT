import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MeetingMapCard extends StatelessWidget {
  const MeetingMapCard({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final int number;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: AppColors.blueLight,
          foregroundColor: AppColors.primary,
          child: Text(
            '$number',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.secondary),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.secondary,
        ),
        onTap:
            onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title akan dikembangkan berikutnya.')),
              );
            },
      ),
    );
  }
}
