
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
import 'package:flutter/material.dart';
import '../../../JsonModels/users.dart';
import '../../../constants/app_colors.dart';

class CompKeypage extends StatelessWidget {
  final Users? userData;
  const CompKeypage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const compKeyPageHeader(),
                // const SizedBox(height: AppDefaults.padding),
                // CreateCompKeyForm(userData: userData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
