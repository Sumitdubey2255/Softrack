import 'package:flutter/material.dart';

// import '../../../core/constants/constants.dart';
// import '../../../core/routes/app_routes.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_icons.dart';
import 'profile_squre_tile.dart';

class ProfileHeaderOptions extends StatelessWidget {
  const ProfileHeaderOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        boxShadow: AppDefaults.boxShadow,
      ),
      child: Flexible(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileSqureTile(
            label: 'All Order',
            icon: AppIcons.truckIcon,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing added')),
              );
              // Navigator.pushNamed(context, AppRoutes.myOrder);
            },
          ),
          ProfileSqureTile(
            label: 'Payments',
            icon: AppIcons.profilePayment,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing added')),
              );
              // Navigator.pushNamed(context, AppRoutes.coupon);
            },
          ),
          ProfileSqureTile(
            label: 'Address',
            icon: AppIcons.homeProfile,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing added')),
              );
              // Navigator.pushNamed(context, AppRoutes.deliveryAddress);
            },
          ),
        ],
      ),
      ),
    );
  }
}
