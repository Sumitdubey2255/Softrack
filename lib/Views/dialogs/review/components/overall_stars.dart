import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../core/components/review_stars.dart';

class OverallStars extends StatelessWidget {
  const OverallStars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDefaults.padding),
          decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle),
          child: Text(
            '4.5',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '320 Reviews',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black,
              ),
        ),
        const ReviewStars(starsGiven: 4),
      ],
    );
  }
}
