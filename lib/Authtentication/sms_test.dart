import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

import '../Views/dialogs/utils/validators.dart';
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/

class EmailMessage extends StatefulWidget {
  const EmailMessage({super.key});

  @override
  State<EmailMessage> createState() => _EmailMessageState();
}

class _EmailMessageState extends State<EmailMessage> {
  final emailController = TextEditingController();
  final OTPController = TextEditingController();
  String message = "";
  final value = 5;
  final formKey = GlobalKey<FormState>();
  final Telephony telephony = Telephony.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      validator: Validators.email.call,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        sendEmail(
                          emailController.text.toString(),
                          "Verify Your Email",
                          "Your OTP for verifying email on Softrack is ${generateOTP()}. The code will be valid until the next Resend of new OTP.",
                          "Dear Customer",
                        );
                      }
                    },
                    child: const Text('Send'),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    child: TextFormField(
                      controller: OTPController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "OTP",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      verify();
                    },
                    child: const Text('Verify'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  var OTP = 0;

  int generateOTP() {
    final random = Random();
    OTP = 1000 + random.nextInt(9000);
    return OTP;
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
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }

  void verify() {
    if (OTP == int.tryParse(OTPController.text)) {
      print('Verified');
    } else {
      print('Invalid OTP');
    }
  }
}
