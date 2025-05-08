
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add this import
import '../../../JsonModels/users.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_icons.dart';
import '../components/create_comp_key.dart';
import '../home/components/all_pack.dart';
import '../home/home_page.dart';
import '../notification/create_notification_page.dart';
import '../profile/profile_page.dart';
import 'components/app_navigation_bar.dart';

class EntryPointUI extends StatefulWidget {
  final Users? userData;
  const EntryPointUI({super.key, this.userData});

  @override
  State<EntryPointUI> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends State<EntryPointUI> {
  int currentIndex = 0;
  int backButtonPressCount = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(users: widget.userData!),
      AllPackPage(userData: widget.userData),
      ShopCompanyKeyForm(userData: widget.userData),
      CreateNotificationPage(userData: widget.userData),
      ProfilePage(usrData: widget.userData!),
    ];
  }

  void onBottomNavigationTap(int index) {
    currentIndex = index;
    setState(() {
      backButtonPressCount = 0; // Reset count on navigation
    });
  }

  Future<bool> _onWillPop() async {
    if (currentIndex == 0) {
      // If on HomePage, show toast
      backButtonPressCount++;
      if (backButtonPressCount == 1) {
        Fluttertoast.showToast(
          msg: "Press Back Again To Exit",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return false; // Do not exit
      } else {
        // Exit the app
        Navigator.of(context).pop(true);
        if (Platform.isAndroid) {
          SystemNavigator.pop(); // Closes the app on Android
        } else if (Platform.isIOS) {
          // Since iOS does not allow direct app closing, provide a message or custom action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Swipe up to close the app.')),
          );
        }
        return true;
      }
    } else {
      // If not on HomePage, navigate back to HomePage
      setState(() {
        currentIndex = 0; // Set to HomePage
        backButtonPressCount = 0; // Reset count
      });
      return false; // Do not exit
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: AppColors.scaffoldBackground,
              child: child,
            );
          },
          duration: AppDefaults.duration,
          child: pages[currentIndex],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onBottomNavigationTap(2);
          },
          backgroundColor: AppColors.primary,
          child: SvgPicture.asset(AppIcons.addRounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: currentIndex,
          onNavTap: onBottomNavigationTap,
        ),
      ),
    );
  }
}
