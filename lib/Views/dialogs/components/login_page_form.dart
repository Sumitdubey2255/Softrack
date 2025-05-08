import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../JsonModels/users.dart';
import '../../../constants/constants.dart';
import '../../../core/themes/app_themes.dart';
import '../../../supabase/supabase.dart';
import '../entrypoint/entrypoint_ui.dart';
import '../forget_password_page.dart';
import '../utils/validators.dart';
import 'login_button.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class LoginPageForm extends StatefulWidget {
  const LoginPageForm({
    super.key,
  });

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

// class _LoginPageFormState extends State<LoginPageForm> {
//   final username = TextEditingController();
//   final password = TextEditingController();
//   final db = SupaBaseDatabaseHelper(); // Update this instance
//
//   final _key = GlobalKey<FormState>();
//   bool isLoginTrue = false;
//   bool isLoading = false; // Loading state
//
//   bool isPasswordShown = false;
//   onPassShowClicked() {
//     isPasswordShown = !isPasswordShown;
//     setState(() {});
//   }
//
//   // Now we should call this function in login button
//   login() async {
//     final bool isFormOkay = _key.currentState?.validate() ?? false;
//     if (isFormOkay) {
//       setState(() {
//         isLoading = true; // Start loading
//       });
//
//       Users? usrDetails = await db.getUser(username.text);
//       var response = await db.login(Users(
//         usrUserName: username.text,
//         usrPassword: password.text,
//         usrName: "",
//         usrEmail: "",
//         usrPhone: "",
//         usrActive: "",
//       ));
//       if (response == true) {
//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => EntryPointUI(userData: usrDetails)),
//         );
//       } else {
//         // If not, show error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid credentials')),
//         );
//         setState(() {
//           isLoginTrue = true;
//         });
//       }
//
//       setState(() {
//         isLoading = false; // End loading
//       });
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     // Show confirmation dialog
//     bool? exit = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Exit App'),
//         content: const Text('Are you sure you want to exit the app?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//               if (Platform.isAndroid) {
//                 SystemNavigator.pop(); // Closes the app on Android
//               } else if (Platform.isIOS) {
//                 // Show message or do nothing for iOS, since direct app closing is not allowed
//                 // You could show a message instructing users to swipe up to close the app
//               }
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//     // Return true if the user confirmed, otherwise return false
//     return exit ?? false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Theme(
//       data: AppTheme.defaultTheme.copyWith(
//         inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(AppDefaults.padding),
//         child: Form(
//           key: _key,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Username Field
//               const Text("Username"),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: username,
//                 validator: Validators.requiredWithFieldName('Username').call,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: AppDefaults.padding),
//
//               // Password Field
//               const Text("Password"),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: password,
//                 validator: Validators.password.call,
//                 onFieldSubmitted: (v) => login(),
//                 textInputAction: TextInputAction.done,
//                 obscureText: !isPasswordShown,
//                 decoration: InputDecoration(
//                   suffixIcon: Material(
//                     color: Colors.transparent,
//                     child: IconButton(
//                       onPressed: onPassShowClicked,
//                       icon: SvgPicture.asset(
//                         AppIcons.eye,
//                         width: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Forget Password labelLarge
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const ForgetPasswordPage()),
//                     );
//                   },
//                   child: const Text('Forget Password?'),
//                 ),
//               ),
//               const SizedBox(height: AppDefaults.padding),
//               // Login Button or Loading Indicator
//               isLoading
//                   ? const Center(child: CircularProgressIndicator()) // Show loading indicator when logging in
//                   : LoginButton(onPressed: login), // Show login button when not loading
//             ],
//           ),
//         ),
//       ),
//     ),
//     );
//   }
// }

class _LoginPageFormState extends State<LoginPageForm> {
  final username = TextEditingController();
  final password = TextEditingController();
  final db = SupaBaseDatabaseHelper();

  final _key = GlobalKey<FormState>();
  bool isLoginTrue = false;
  bool isLoading = false;
  bool isPasswordShown = false;
  bool rememberMe = false; // Add this for "Remember Me" status

  onPassShowClicked() {
    isPasswordShown = !isPasswordShown;
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    // Show confirmation dialog
    bool? exit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              if (Platform.isAndroid) {
                SystemNavigator.pop(); // Closes the app on Android
              } else if (Platform.isIOS) {
                // Show message or do nothing for iOS, since direct app closing is not allowed
                // You could show a message instructing users to swipe up to close the app
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    // Return true if the user confirmed, otherwise return false
    return exit ?? false;
  }

  // Now we should call this function in login button
  // login() async {
  //   final bool isFormOkay = _key.currentState?.validate() ?? false;
  //   if (isFormOkay) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     Users? usrDetails = await db.getUser(username.text);
  //     var response = await db.login(
  //       Users(
  //         usrUserName: username.text,
  //         usrPassword: password.text,
  //         usrName: "",
  //         usrEmail: "",
  //         usrPhone: "",
  //         usrActive: "${rememberMe ? '1' : '0'}/${usrDetails!.usrActive.split("/")[1]}",
  //       ),
  //     );
  //     if (response == true) {
  //       if (!mounted) return;
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => EntryPointUI(userData: usrDetails)),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Invalid credentials')),
  //       );
  //       setState(() {
  //         isLoginTrue = true;
  //       });
  //     }
  //
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  login() async {
    final bool isFormOkay = _key.currentState?.validate() ?? false;
    if (isFormOkay) {
      setState(() {
        isLoading = true;
      });

      Users? usrDetails = await db.getUser(username.text);
      if (usrDetails == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        return;
      }

      var response = await db.login(
        Users(
          usrUserName: username.text,
          usrPassword: password.text,
          usrName: "",
          usrEmail: "",
          usrPhone: "",
          usrActive: "${rememberMe ? '1' : '0'}/${usrDetails.usrActive.split("/")[1]}",
        ),
      );

      if (response) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EntryPointUI(userData: usrDetails)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
        setState(() {
          isLoginTrue = true;
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Theme(
        data: AppTheme.defaultTheme.copyWith(
          inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username Field
                const Text("Username"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: username,
                  validator: Validators.requiredWithFieldName('Username').call,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDefaults.padding),

                // Password Field
                const Text("Password"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: password,
                  validator: Validators.password.call,
                  onFieldSubmitted: (v) => login(),
                  textInputAction: TextInputAction.done,
                  obscureText: !isPasswordShown,
                  decoration: InputDecoration(
                    suffixIcon: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: onPassShowClicked,
                        icon: SvgPicture.asset(
                          AppIcons.eye,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                // Remember Me Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),

                // Forget Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgetPasswordPage()),
                      );
                    },
                    child: const Text('Forget Password?'),
                  ),
                ),
                const SizedBox(height: AppDefaults.padding),

                // Login Button or Loading Indicator
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : LoginButton(onPressed: login),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
