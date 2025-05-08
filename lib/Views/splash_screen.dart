import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:softrack/routes/app_routes.dart';
import 'package:uuid/uuid.dart';

import 'package:device_info/device_info.dart';
import '../JsonModels/users.dart';
import '../supabase/supabase.dart';
import 'dialogs/entrypoint/entrypoint_ui.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _animationCompleted = false;
  final db = SupaBaseDatabaseHelper();
  Uuid uuid = const Uuid();

  String _androidId = '';
  String usersUuid = '';
  @override
  void initState() {
    super.initState();
    _getDeviceId();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration should match the GIF length
    );

    // Listen for the completion of the animation
    _animationController.addListener(() {
      if (_animationController.isCompleted && !_animationCompleted) {
        _animationCompleted = true;
        _checkInternetConnection(); // Check internet after animation completes
      }
    });
    // Play the GIF (animation)
    _playGif();
  }

  Future<void> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    setState(() {
      _androidId = androidInfo.androidId ?? '';
      String kvAscii = '${'K'.codeUnitAt(0)}${'V'.codeUnitAt(0)}';
      usersUuid = _androidId + kvAscii;
    });
  }

  // Check user status after checking internet connection
  checkingUserStatus() async {
    // String? userUuid = const Uuid().v4();
    print('current userUuid: $usersUuid');
    Users? usrDetails = await db.checkLogin(usersUuid);
    if (usrDetails != null) {
      bool isActive = usrDetails.usrActive.split("/")[0] == "1" ? true : false;
      if(isActive){
        print('active');
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EntryPointUI(userData: usrDetails)),
        );
      }else{
        _navigateToHome(); // If user is not active, navigate to login/signup
      }
    } else {
      _navigateToHome(); // If user is not active, navigate to login/signup
    }
  }

  // Function to play the GIF
  void _playGif() async {
    await _animationController.forward().orCancel;
  }

  // Function to check internet connectivity
  void _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    // If no internet connection, show a dialog
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      checkingUserStatus(); // Proceed with checking user status after confirming internet
    }
  }

  // Function to show no internet connection dialog
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please turn on your internet to continue."),
          actions: <Widget>[
            TextButton(
              child: const Text("Exit"),
              onPressed: () {
                SystemNavigator.pop(); // Exit the app
              },
            ),
          ],
        );
      },
    );
  }

  // Navigate to the next page if internet is available and no active user session
  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.loginOrSignup);
  }

  // Function to handle back button press (WillPopScope)
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you want to exit the app?"),
        actions: <Widget>[
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () => SystemNavigator.pop(), // Exit the app
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle the back button
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Image.asset('lib/assets/images/pop_animation.gif'), // Splash GIF
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}