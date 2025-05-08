// import 'package:flutter/material.dart';
// import 'package:softrack/JsonModels/users.dart';
//
// // import '../../../core/constants/constants.dart';
// // import '../../../core/routes/app_routes.dart';
// import '../../../../constants/app_defaults.dart';
// import '../../../../constants/app_icons.dart';
// import '../../../../routes/app_routes.dart';
// import 'profile_list_tile.dart';
//
// class ProfileMenuOptions extends StatelessWidget {
//   final Users? userData;
//   const ProfileMenuOptions({
//     super.key, this.userData,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(AppDefaults.padding),
//       padding: const EdgeInsets.all(AppDefaults.padding),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: AppDefaults.boxShadow,
//         borderRadius: AppDefaults.borderRadius,
//       ),
//       child: Column(
//         children: [
//           ProfileListTile(
//             title: 'My Profile',
//             icon: AppIcons.profilePerson,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.profileEdit, arguments: userData),
//           ),
//           const Divider(thickness: 0.1),
//           // ProfileListTile(
//           //   title: 'Notification',
//           //   icon: AppIcons.profileNotification,
//           //   onTap: () => Navigator.pushNamed(context, AppRoutes.notifications, arguments: userData),
//           // ),
//           // const Divider(thickness: 0.1),
//           ProfileListTile(
//             title: 'Setting',
//             icon: AppIcons.profileSetting,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.settings, arguments: userData),
//           ),
//           // const Divider(thickness: 0.1),
//           // ProfileListTile(
//           //   title: 'Payment',
//           //   icon: AppIcons.profilePayment,
//           //   onTap: () => Navigator.pushNamed(context, AppRoutes.paymentMethod),
//           // ),
//           const Divider(thickness: 0.1),
//           ProfileListTile(
//             title: 'Logout',
//             icon: AppIcons.profileLogout,
//             onTap: () => Navigator.pushNamed(context, AppRoutes.login),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softrack/JsonModels/users.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_icons.dart';
import '../../../../routes/app_routes.dart';
import '../../../../supabase/supabase.dart';
import 'profile_list_tile.dart';
import 'package:device_info/device_info.dart';

class ProfileMenuOptions extends StatefulWidget {
  final Users? userData;
  const ProfileMenuOptions({
    super.key, this.userData,
  });

  @override
  State<ProfileMenuOptions> createState() => _ProfileMenuOptionsState();
}

class _ProfileMenuOptionsState extends State<ProfileMenuOptions> {
  final db = SupaBaseDatabaseHelper();
  String _androidId = '';
  String usersUuid = '';

  Future<void> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    setState(() {
      _androidId = androidInfo.androidId ?? '';
      String kvAscii = '${'K'.codeUnitAt(0)}${'V'.codeUnitAt(0)}';
      usersUuid = _androidId + kvAscii;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    db.updateStatus(usersUuid);
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  // Future<void> _logout(BuildContext context) async {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.padding),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        children: [
          ProfileListTile(
            title: 'My Profile',
            icon: AppIcons.profilePerson,
            onTap: () => Navigator.pushNamed(context, AppRoutes.profileEdit, arguments: widget.userData),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Setting',
            icon: AppIcons.profileSetting,
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings, arguments: widget.userData),
          ),
          const Divider(thickness: 0.1),
          // ProfileListTile(
          //   title: 'Payment',
          //   icon: AppIcons.profilePayment,
          //   onTap: () => Navigator.pushNamed(context, AppRoutes.paymentCardAdd),
          // ),
          ProfileListTile(
            title: 'Payment',
            icon: AppIcons.profilePerson,
            onTap: () => Navigator.pushNamed(context, AppRoutes.paymentMethod, arguments: widget.userData),
          ),
          const Divider(thickness: 0.1),
          ProfileListTile(
            title: 'Logout',
            icon: AppIcons.profileLogout,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Logging Out?'),
                        content: const Text('Are you sure you want to Logout the app?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _logout(context);
                              },
                            child: const Text('Logout'),
                          ),
                        ]);
                  }
              );
            }
          ),
        ],
      ),
    );
  }
}
