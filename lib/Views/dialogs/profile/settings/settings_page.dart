import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:softrack/JsonModels/users.dart';

import '../../../../../core/components/app_back_button.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_icons.dart';
import '../../../../core/components/app_settings_tile.dart';
import '../../../../routes/app_routes.dart';
// import '../../../../core/constants/constants.dart';
// import '../../../core/routes/app_routes.dart';
// import '../../../core/components/app_settings_tile.dart';

class SettingsPage extends StatelessWidget {
  final Users? userData;
  const SettingsPage({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Settings',
        ),
      ),
      backgroundColor: AppColors.cardColor,
      body: Container(
        margin: const EdgeInsets.all(AppDefaults.padding),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding,
          vertical: AppDefaults.padding * 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: AppDefaults.borderRadius,
        ),
        child: Column(
          children: [
            AppSettingsListTile(
              label: 'Language',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.settingsLanguage),
            ),
            AppSettingsListTile(
              label: 'Notification',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.settingsNotifications, arguments: userData),
            ),
            AppSettingsListTile(
              label: 'Change Password',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.changePassword, arguments: userData),
            ),
            AppSettingsListTile(
              label: 'Change Phone Number',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.changePhoneNumber, arguments: userData),
            ),
            // AppSettingsListTile(
            //   label: 'Edit Home Address',
            //   trailing: SvgPicture.asset(AppIcons.right),
            //   onTap: () =>
            //       Navigator.pushNamed(context, AppRoutes.deliveryAddress),
            // ),
            // AppSettingsListTile(
            //   label: 'Location',
            //   trailing: SvgPicture.asset(AppIcons.right),
            //   onTap: () {},
            // ),
            AppSettingsListTile(
              label: 'Profile Setting',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.profileEdit, arguments: userData),
            ),
            AppSettingsListTile(
              label: 'Deactivate Account',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.introLogin),
            ),
          ],
        ),
      ),
    );
  }
}
