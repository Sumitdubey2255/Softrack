import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class TitleAndActionButton extends StatelessWidget {
  const TitleAndActionButton({
    super.key,
    required this.title,
    this.actionLabel,
    required this.onTap,
    this.isHeadline = true,
  });

  final String title;
  final String? actionLabel;
  final void Function() onTap;
  final bool isHeadline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isHeadline
                ? Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.black)
                : Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(actionLabel ?? 'View All'),
          ),
        ],
      ),
    );
  }
}

// class TitleAndInfoButton extends StatelessWidget {
//   const TitleAndInfoButton({
//     super.key,
//     required this.title,
//     this.actionLabel,
//     required this.onTap,
//     this.isHeadline = true,
//   });
//
//   final String title;
//   final String? actionLabel;
//   final void Function() onTap;
//   final bool isHeadline;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: isHeadline
//                 ? Theme.of(context)
//                 .textTheme
//                 .headlineSmall
//                 ?.copyWith(color: Colors.black)
//                 : Theme.of(context)
//                 .textTheme
//                 .bodyLarge
//                 ?.copyWith(color: Colors.black),
//           ),
//           const SizedBox(width: 50),
//           TextButton(
//             onPressed: onTap,
//             child: Text(actionLabel ?? 'View All', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, ),),
//           ),
//         ],
//       ),
//     );
//   }
// }

class TitleAndInfoButton extends StatelessWidget {
  const TitleAndInfoButton({
    super.key,
    required this.title,
    this.actionLabel,
    this.isHeadline = true,
  });

  final String title;
  final String? actionLabel;
  final bool isHeadline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isHeadline
                ? Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.black)
                : Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black),
          ),
          const SizedBox(width: 50),
          TextButton(
            onPressed: () => _showInfoDialog(context),
            child: Text(
              actionLabel ?? 'View All',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Credit Card Info'),
          content: Text(
              'This card shows how many points you earned from the customer.\nDo not share this with anyone.\n\nThank you.'),
        );
      },
    );

    // Close the dialog after 3 seconds (or any duration you prefer)
    Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Dismiss the dialog
      }
    });
  }
}