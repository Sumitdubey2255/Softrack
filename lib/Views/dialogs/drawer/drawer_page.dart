import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_defaults.dart';
import '../../../constants/app_icons.dart';
import '../../../core/components/app_back_button.dart';
import '../../../core/components/app_settings_tile.dart';
import '../../../routes/app_routes.dart';
import '../../../supabase/supabase.dart';
import 'package:device_info/device_info.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class DrawerPage extends StatefulWidget {
  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  // const DrawerPage({super.key});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          children: [
            // AppSettingsListTile(
            //   label: 'Invite Friend',
            //   trailing: SvgPicture.asset(AppIcons.right),
            // ),
            AppSettingsListTile(
              label: 'About Us',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.aboutUs),
            ),
            // AppSettingsListTile(
            //   label: 'FAQs',
            //   trailing: SvgPicture.asset(AppIcons.right),
            //   onTap: () => Navigator.pushNamed(context, AppRoutes.faq),
            // ),
            AppSettingsListTile(
              label: 'Terms & Conditions',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.termsAndConditions),
            ),
            // AppSettingsListTile(
            //   label: 'Help Center',
            //   trailing: SvgPicture.asset(AppIcons.right),
            //   onTap: () => Navigator.pushNamed(context, AppRoutes.help),
            // ),
            AppSettingsListTile(
              label: 'Rate This App',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () async {
                const String appPackageName = 'com.example.softrack';
                const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$appPackageName';
                if (await canLaunch(playStoreUrl)) {
                  await launch(playStoreUrl);
                } else {
                  print('Could not launch $playStoreUrl');
                }
              },
            ),
            AppSettingsListTile(
              label: 'Contact Us',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.contactUs),
            ),
            // const SizedBox(height: AppDefaults.padding * 12),
            // const SizedBox(height: AppDefaults.padding * 3),
            AppSettingsListTile(
              label: 'Logout',
              trailing: SvgPicture.asset(AppIcons.right),
              // onTap: () => _logout(context),
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
                          ]
                      );
                    }
                );
              },
            ),
            AppSettingsListTile(
              label: 'Administrator Login',
              trailing: SvgPicture.asset(AppIcons.right),
              onTap: () => Navigator.pushNamed(context, AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
