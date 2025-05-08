import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:softrack/JsonModels/users.dart';

import '../../../../Authtentication/otp_service.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_icons.dart';
import '../../../../core/components/app_back_button.dart';
import '../../../../supabase/supabase.dart';
import '../../utils/validators.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatelessWidget {
  final Users? usersData;
  TextEditingController _emailController;
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  final _key = GlobalKey<FormState>();
  final db = SupaBaseDatabaseHelper();
  final OTPService _otpService = OTPService();
  String? generatedOtp;
  bool isEmailValid = false;
  bool isOtpValid = false;
  String? userEmail;
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  ChangePasswordPage({super.key, this.usersData}):
        _emailController = TextEditingController(text: usersData!.usrEmail),
        _userNameController = TextEditingController(text: usersData.usrUserName),
        _passwordController = TextEditingController(text: usersData.usrPassword);

  Future<void> _refreshData() async {
    _emailController = TextEditingController(text: usersData!.usrEmail);
    _passwordController = TextEditingController(text: usersData!.usrPassword);
    _userNameController = TextEditingController(text: usersData!.usrUserName);
  }

  void sendEmail(String email, String subject, String message, String toName) async {
    var serviceId = 'service_bfwqbno',
        templateId = 'template_6spyyhv',
        userId = 'HTqVXzJ3HxAhX5v10';

    var response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'user_id': userId,
        'template_id': templateId,
        'template_params': {
          'name': toName,
          'subject': subject,
          'message': message,
          'sender_email': email,
        },
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Check your email again')),
      );
    }
  }

  void _sendOtp() async {
    if (isEmailValid && userEmail != null) {
      generatedOtp = _otpService.generateOTP().toString(); // Convert OTP to String
      sendEmail(
        userEmail!,
        "Verify Your Email",
        "Your OTP for verifying email on Softrack for KeepVeda is $generatedOtp. The code will be valid until the next Resend of new OTP.",
        "Dear Customer",
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Invalid email or username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Change Password Page',
        ),
      ),
      backgroundColor: AppColors.cardColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(AppDefaults.padding),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDefaults.padding,
              vertical: AppDefaults.padding * 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: AppDefaults.borderRadius,
            ),
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Registered Email"),
                  const SizedBox(height: 8),
                  /* <----  Email -----> */
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email.call,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    child: const Text('Get OTP'),
                    onPressed: () => _sendOtp,
                  ),
                  const SizedBox(height: AppDefaults.padding),
                  /* <---- New Password -----> */
                  const Text("New Password"),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    controller: passwordController,
                    validator: Validators.password.call,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(AppIcons.eye),
                      ),
                      suffixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(height: AppDefaults.padding),
                  /* <---- Confirm Password-----> */
                  const Text("Confirm Password"),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: Validators.password.call,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(AppIcons.eye),
                      ),
                      suffixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(height: AppDefaults.padding),
                  /* <----  OTP -----> */
                  const Text("Enter OTP"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppDefaults.padding),

                  /* <---- Submit -----> */
                  const SizedBox(height: AppDefaults.padding),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Verify & Update'),
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          if(generatedOtp == otpController.text.toString()) {
                            int result = await db.updateUserPhone(
                                _emailController.text,
                                _passwordController.text,
                                _userNameController.text
                            );
                            if (result == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                    'Phone number updated. You need to login again.')),
                              );
                              _refreshData(); // Call your refresh method if needed
                              Navigator.pop(context, true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Update Failed')),
                              );
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('OTP is not valid')
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
