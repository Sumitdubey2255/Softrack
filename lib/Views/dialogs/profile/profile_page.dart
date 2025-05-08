import 'package:flutter/material.dart';
import 'package:softrack/JsonModels/users.dart';

import '../../../constants/app_colors.dart';
import 'components/profile_header.dart';
import 'components/profile_menu_options.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class ProfilePage extends StatefulWidget {
  final Users? usrData;
  const ProfilePage({super.key, this.usrData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardColor,
      child: Column(
        children: [
          ProfileHeader(usrData: widget.usrData),
          ProfileMenuOptions(userData: widget.usrData),
        ],
      ),
    );
  }
}
