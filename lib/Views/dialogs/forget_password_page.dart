import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:softrack/Views/dialogs/password_reset_page.dart';
import 'package:softrack/Views/dialogs/utils/validators.dart';
import '../../Authtentication/otp_service.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../core/components/app_back_button.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController verified = TextEditingController();
  final TextEditingController usernamee = TextEditingController();
  final OTPService _otpService = OTPService();
  String? generatedOtp;
  bool isEmailValid = false;
  bool isOtpValid = false;
  String? userEmail;

  Future<void> fetchEmail(String username) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate a delay
    userEmail = 'user@example.com'; // Replace with actual email fetching logic
    setState(() {
      isEmailValid = userEmail != null;
    });
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
          'to_email':email,
          'subject': subject,
          'message': message,
          'sender_email': "typicaldesktop@gmail.com",
        },
      }),
    );

    if (mounted) {  // Check if the widget is still mounted
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Check your email again')),
        );
      }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );

      // Add a delay of 2 seconds before navigating to the PasswordResetPage
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {  // Check if the widget is still mounted before navigating
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetPage(
              otpService: _otpService,
              otp: generatedOtp!,
              username: usernamee.text,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Forget Password'),
        backgroundColor: AppColors.scaffoldBackground,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(AppDefaults.margin),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                  vertical: AppDefaults.padding * 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppDefaults.borderRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reset your password',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppDefaults.padding),
                    const Text(
                      'Please enter your Username to get OTP on your registered Email Id. We will send this OTP\nto your mail to reset your password.',
                    ),
                    const SizedBox(height: AppDefaults.padding * 3),
                    const Text("Username"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: usernamee,
                      autofocus: true,
                      validator: Validators.requiredWithFieldName('Username').call,
                      textInputAction: TextInputAction.next,
                      // keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppDefaults.padding),
                    const SizedBox(height: AppDefaults.padding),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await fetchEmail(usernamee.text);
                          _sendOtp();
                        },
                        child: const Text('Send me OTP'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
