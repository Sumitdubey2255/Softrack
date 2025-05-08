import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../Authtentication/otp_service.dart';
import '../../../../JsonModels/create_comp.dart';
import '../../../../JsonModels/users.dart';
import '../../../../core/components/app_back_button.dart';
import '../../../../supabase/supabase.dart';
import '../../utils/validators.dart';
import 'package:http/http.dart' as http;

import 'recent_pack.dart';

class AllAppsPage extends StatefulWidget {
  final Users? userData;
  const AllAppsPage({super.key, this.userData});

  @override
  State<AllAppsPage> createState() => _AllAppsPageState();
}

class _AllAppsPageState extends State<AllAppsPage> {
  late SupaBaseDatabaseHelper handler;
  late Future<List<CreateComp>> notes;
  final db = SupaBaseDatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();
  final OTPService _otpService = OTPService(); // Instantiate the OTP service

  final name = TextEditingController();
  final emailC = TextEditingController();
  final phone = TextEditingController();
  final shopName = TextEditingController();
  final compKey = TextEditingController();
  final otpController = TextEditingController();
  final verified = TextEditingController();

  String? generatedOtp; // Store the generated OTP
  bool isOtpVerified = false; // Track OTP verification status
  bool isEmailValid = false; // Track email validity
  bool isOtpValid = false;

  void sendEmail(String email, String subject, String message, String toName) async {
    var serviceId = 'service_bfwqbno',
        templateId = 'template_6spyyhv',
        userId = 'HTqVXzJ3HxAhX5v10';

    // Create a text file with the OTP
    const fileName = 'OTP.txt';
    final file = File(fileName);
    await file.writeAsString('Your OTP is: $generatedOtp');

    // Convert the file to a base64 string
    final fileBytes = await file.readAsBytes();
    final base64File = base64Encode(fileBytes);

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
          'attachment': base64File,
          'attachment_name': fileName,
        },
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully with attachment')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Check your email again')),
      );
    }

    // Delete the file after sending
    await file.delete();
  }

  void _sendOtp() {
    if (isEmailValid) {
      generatedOtp = _otpService.generateOTP().toString(); // Convert OTP to String
      sendEmail(
        emailC.text.toString(),
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

  void _validateEmail() {
    setState(() {
      isEmailValid = Validators.email(emailC.text) == null;
    });
  }

  Future<List<CreateComp>> getAllCompKey() {
    return handler.getCompKeyByUsername(widget.userData!.usrUserName, widget.userData!.usrActive); // Fetch notes for the current user
  }

  Future<List<CreateComp>> searchCompKey() {
    return handler.searchCompKey(keyword.text, widget.userData!.usrUserName, widget.userData!.usrActive);
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllCompKey();
    });
  }

  @override
  void initState() {
    handler = SupaBaseDatabaseHelper();
    notes = handler.getCompKeyByUsername(widget.userData!.usrUserName, widget.userData!.usrActive); // Fetch notes for the current user
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Software\'s'),
          automaticallyImplyLeading: false, // Remove the back button
          leading: const AppBackButton(),
        ),
        body: const Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding as needed
              child: SoftwareCard(
                imageUrl: 'lib/assets/keepveda.png',
                title: 'KeepVeda',
                subtitle: 'Medical Billing Software',
                url: 'https://drive.google.com/file/d/1PVJDYgS_RxgxR3GnOD7QH3urU7l7DQRv/view?usp=drive_link',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding as needed
              child: SoftwareCard(
                imageUrl: 'lib/assets/daybook.png',
                title: 'Day Book',
                subtitle: 'Billing Software',
                url: 'https://drive.google.com/file/d/12XIrrcfAAbyYwE8PxWAqUtr5Xge94j3H/view?usp=drive_link',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding as needed
              child: SoftwareCard(
                imageUrl: 'lib/assets/shozzer.png',
                title: 'Shozzer',
                subtitle: 'Footwear Management',
                url: 'https://drive.google.com/file/d/1PVJDYgS_RxgxR3GnOD7QH3urU7l7DQRv/view?usp=drive_link',
              ),
            ),
          ],
        )
    );
  }
}