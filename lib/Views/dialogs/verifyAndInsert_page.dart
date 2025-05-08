import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softrack/JsonModels/users.dart';
import 'package:softrack/Views/dialogs/verified_comp.dart';
import '../../Authtentication/otp_service.dart';
import '../../Authtentication/signup.dart';
import '../../JsonModels/create_comp.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_images.dart';
import '../../core/components/network_image.dart';
import '../../core/themes/app_themes.dart';
import 'package:http/http.dart' as http;

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class VerifyAndInsertPage extends StatefulWidget {
  final OTPService otpService;
  final Users? userData;
  final bool isEmailValid;
  final CreateComp? compData;

  const VerifyAndInsertPage( {
    super.key,
    required this.userData,
    required this.otpService,
    required this.isEmailValid,
    required this.compData,
  });

  @override
  _VerifyAndInsertPageState createState() => _VerifyAndInsertPageState();
}

class _VerifyAndInsertPageState extends State<VerifyAndInsertPage> {
  String? generatedOtp;
  bool isOtpVerified = false;
  bool isOtpValid = false;
  final OTPService _otpService = OTPService();

  final _otpControllers = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void sendEmail(String email, String subject, String message, String toName) async {
    var serviceId = 'service_bfwqbno',
        templateId = 'template_6spyyhv',
        userId = 'HTqVXzJ3HxAhX5v10';

    try {
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

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Check your email again')),
        );
      }
    } catch (e) {
      print('Error sending email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while sending OTP')),
      );
    }
  }

  void _sendOtp() {
    if (widget.isEmailValid) {
      generatedOtp = widget.otpService.generateOTP().toString();
      print('Generated OTP: $generatedOtp');
      sendEmail(
        widget.compData!.usrEmail.toString(),
        "Verify Your Email",
        "Your OTP for verifying email on Softrack for KeepVeda is $generatedOtp. The code will be valid until the next Resend of new OTP.",
        "Dear Customer",
      );
    } else {
      print('Email is not valid');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is not valid')),
      );
    }
  }

  void _sendCompKeyEmail(String email, String compKey, String name, String shopName) async {

    var serviceId = 'service_bfwqbno',
        templateId = 'template_6spyyhv',
        userId = 'HTqVXzJ3HxAhX5v10';

    try {
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
            'name': "Dear Customer, $name",
            'to_email':email,
            'subject': "Shop Credential",
            'message': "Your company key for shop \"$shopName\" used for KeepVeda is \"$compKey\". Please keep it safe.",
            'sender_email': "typicaldesktop@gmail.com",
          },
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company key sent on your email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send company key. Check your email again')),
        );
      }
    } catch (e) {
      print('Error sending company key email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while sending company key')),
      );
    }
  }

  void _verifyOtp() {
    // Check if all OTP fields are filled
    final allFilled = _otpControllers.every((controller) => controller.text.isNotEmpty);

    if (allFilled) {
      final otpValues = _otpControllers.map((controller) => controller.text).join();
      if (widget.otpService.verifyOTP(otpValues)) {
        db.createComp(
          CreateComp(
            usrId: uuid.v4(),
            usrUserName: widget.compData!.usrUserName,
            usrName: widget.compData!.usrName,
            usrEmail: widget.compData!.usrEmail,
            usrPhone: widget.compData!.usrPhone,
            usrShopName: widget.compData!.usrShopName,
            usrCompKey: widget.compData!.usrCompKey,
            createdAt: DateTime.now().toIso8601String(),
            usrVerified: "yes",
            usrAddress: widget.compData!.usrAddress,
            usrAppName: widget.compData!.usrAppName,
            usrServiceType: widget.compData!.usrServiceType,
            usrUsersCount: widget.compData!.usrUsersCount,
            usrPayType: widget.compData!.usrPayType,
            usrAadharNo: widget.compData!.usrAadharNo,
            usrPaidAmt: widget.compData!.usrPaidAmt,
            usrNoOfDays: widget.compData!.usrNoOfDays,
            usrDeploymentType: widget.compData!.usrDeploymentType,
          ),
        ).whenComplete(() {
          _sendCompKeyEmail(
            widget.compData!.usrEmail,
            widget.compData!.usrCompKey,
            widget.compData!.usrName,
            widget.compData!.usrShopName,
          );
          // Show a general dialog to confirm the verified status
          showGeneralDialog(
            barrierLabel: 'Dialog',
            barrierDismissible: true,
            context: context,
            pageBuilder: (ctx, anim1, anim2) => VerifiedComp(username: widget.userData),
            transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
              scale: anim1,
              child: child,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  margin: const EdgeInsets.all(AppDefaults.margin),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: AppDefaults.borderRadius,
                  ),
                  child: Column(
                    children: [
                      const NumberVerificationHeader(),
                      OTPTextFields(controllers: _otpControllers),
                      const SizedBox(height: AppDefaults.padding * 3),
                      ResendButton(onResendPressed: _sendOtp),
                      const SizedBox(height: AppDefaults.padding),
                      VerifyButton(onPressed: _verifyOtp),
                      const SizedBox(height: AppDefaults.padding),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const VerifyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Verify'),
      ),
    );
  }
}

class ResendButton extends StatelessWidget {
  final VoidCallback onResendPressed;

  const ResendButton({super.key, required this.onResendPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Did you not get the code?'),
        TextButton(
          onPressed: onResendPressed,
          child: const Text('Resend'),
        ),
      ],
    );
  }
}

class NumberVerificationHeader extends StatelessWidget {
  const NumberVerificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDefaults.padding),
        Text(
          'Enter Your 4 digit code',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppDefaults.padding),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: const AspectRatio(
            aspectRatio: 1 / 1,
            child: NetworkImageWithLoader(
              AppImages.numberVerfication,
            ),
          ),
        ),
        const SizedBox(height: AppDefaults.padding * 3),
      ],
    );
  }
}

class OTPTextFields extends StatelessWidget {
  final List<TextEditingController> controllers;

  const OTPTextFields({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.otpInputDecorationTheme,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          return SizedBox(
            width: 68,
            height: 68,
            child: TextFormField(
              controller: controllers[index],
              onChanged: (v) {
                if (v.length == 1) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).previousFocus();
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          );
        }),
      ),
    );
  }
}
