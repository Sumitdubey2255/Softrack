// sign_up_form.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../../Authtentication/otp_service.dart';
import '../../../JsonModels/users.dart';
import '../../../constants/constants.dart';
import '../../../supabase/supabase.dart';
import '../number_verification_page.dart';
import '../utils/validators.dart';
import 'already_have_accout.dart';
import 'package:device_info/device_info.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

final db = SupaBaseDatabaseHelper();
const uuid = Uuid();

class _SignUpFormState extends State<SignUpForm> {
  final _key = GlobalKey<FormState>();
  bool isPasswordShown = false;

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final OTPService _otpService = OTPService(); // Instantiate the OTP service

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

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }

  void onPassShowClicked() {
    setState(() {
      isPasswordShown = !isPasswordShown;
    });
  }

  String _androidId = '';
  String usersUuid = '';

  Future<void> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    setState(() {
      _androidId = androidInfo.androidId ?? '';
      String kvAscii = '${'K'.codeUnitAt(0)}${'V'.codeUnitAt(0)}';
      usersUuid = _androidId + kvAscii;
      // usersUuid = "2550d1c254ee41557586";
    });
  }

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    return Container(
      margin: const EdgeInsets.all(AppDefaults.margin),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name"),
            const SizedBox(height: 8),
            TextFormField(
              controller: name,
              validator: Validators.requiredWithFieldName('Name').call,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Email"),
            const SizedBox(height: 8),
            TextFormField(
              controller: email,
              validator: Validators.email.call,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Phone Number"),
            const SizedBox(height: 8),
            TextFormField(
              controller: phone,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: Validators.phone.call,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Username"),
            const SizedBox(height: 8),
            TextFormField(
              controller: username,
              validator: Validators.requiredWithFieldName('Username').call,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("Password"),
            const SizedBox(height: 8),
            TextFormField(
              controller: password,
              validator: Validators.password.call,
              textInputAction: TextInputAction.next,
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
            const SizedBox(height: AppDefaults.padding),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDefaults.padding * 2),
              child: Row(
                children: [
                  Text(
                    'Sign Up',
                    style: textStyle,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        String? errorMessage = await db.checkUserExists(email.text, phone.text, username.text);
                        if (errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(errorMessage),
                          ));
                        } else {
                          sendEmail(
                            email.text.toString(),
                            "Verify Your Email",
                            "Your OTP for verifying email on Softrack is ${_otpService.generateOTP()}. The code will be valid until the next Resend of new OTP.",
                            "Dear Customer",
                          );
                          // db.signup(
                          //   Users(
                          //     usrId: uuid.v4(),
                          //     usrName: name.text,
                          //     usrEmail: email.text,
                          //     usrPhone: phone.text,
                          //     usrUserName: username.text,
                          //     usrPassword: password.text,
                          //   ),
                          // ).whenComplete(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NumberVerificationPage(
                                  otpService: _otpService,
                                  userData: Users(
                                    // usrId: uuid.v4(),
                                    usrId: usersUuid,
                                    usrName: name.text,
                                    usrEmail: email.text,
                                    usrPhone: phone.text,
                                    usrUserName: username.text,
                                    usrPassword: password.text,
                                  ),// Pass the OTP service instance
                                ),
                              ),
                            );
                          // });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(elevation: 1),
                    child: SvgPicture.asset(AppIcons.arrowForward, color: Colors.white),
                  ),
                ],
              ),
            ),
            const AlreadyHaveAnAccount(),
            const SizedBox(height: AppDefaults.padding),
          ],
        ),
      ),
    );
  }
}
