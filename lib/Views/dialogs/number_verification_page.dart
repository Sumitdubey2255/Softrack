import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softrack/JsonModels/users.dart';

import '../../Authtentication/otp_service.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_images.dart';
import '../../core/components/network_image.dart';
import '../../core/themes/app_themes.dart';
import '../../routes/app_routes.dart';
import '../../supabase/supabase.dart';
import 'verified_dialogs.dart'; // Adjust import as necessary

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class NumberVerificationPage extends StatefulWidget {
  final OTPService otpService;
  final Users? userData;
  const NumberVerificationPage({super.key, required this.otpService, required this.userData});

  @override
  _NumberVerificationPageState createState() => _NumberVerificationPageState();
}
final db = SupaBaseDatabaseHelper();
class _NumberVerificationPageState extends State<NumberVerificationPage> {
  final _otpControllers = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    final allFilled = _otpControllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      final otpValues = _otpControllers.map((controller) => controller.text).join();
      print('OTP Values: $otpValues');
      if (widget.otpService.verifyOTP(otpValues)) {
        db.signup(
          Users(
            usrId: widget.userData!.usrId,
            usrName: widget.userData!.usrName,
            usrEmail: widget.userData!.usrEmail,
            usrPhone: widget.userData!.usrPhone,
            usrUserName: widget.userData!.usrUserName,
            usrPassword: widget.userData!.usrPassword,
          ),
        ).whenComplete(() {
          showGeneralDialog(
            barrierLabel: 'Dialog',
            barrierDismissible: true,
            context: context,
            pageBuilder: (ctx, anim1, anim2) => const VerifiedDialog(),
            transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
              scale: anim1,
              child: child,
            ),
          ).then((_) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          });
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
                      const ResendButton(),
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
  const ResendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Did you not get the code?'),
        TextButton(
          onPressed: () {},
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
