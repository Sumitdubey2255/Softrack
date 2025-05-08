import 'package:flutter/material.dart';
import 'package:softrack/Views/dialogs/login_page.dart';
import 'package:softrack/Views/dialogs/utils/validators.dart';
import 'package:uuid/uuid.dart';

import '../../Authtentication/otp_service.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../core/components/app_back_button.dart';
import '../../supabase/supabase.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class PasswordResetPage extends StatefulWidget {
  final OTPService otpService;
  final String otp;
  final String username;

  const PasswordResetPage({
    super.key,
    required this.otpService,
    required this.otp,
    required this.username,
  });

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

final db = SupaBaseDatabaseHelper();
const uuid = Uuid();

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (widget.otpService.verifyOTP(widget.otp)) {
      final result = await db.resetPasswordCompKey(widget.username, _newPasswordController.text);
      if (result == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update password')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('New Password'),
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
                      'Add New password',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppDefaults.padding * 1),
                    const Text("OTP"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _otpController,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppDefaults.padding * 3),
                    const Text("New Password"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newPasswordController,
                      autofocus: true,
                      validator: Validators.password.call,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppDefaults.padding),
                    const Text("Confirm Password"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: Validators.password.call,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppDefaults.padding * 2),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        child: const Text('Done'),
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
