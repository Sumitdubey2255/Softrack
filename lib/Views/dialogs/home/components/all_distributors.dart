import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:softrack/Views/dialogs/home/components/recent_pack.dart';
import '../../../../Authtentication/otp_service.dart';
import '../../../../JsonModels/create_comp.dart';
import '../../../../JsonModels/users.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_icons.dart';
import '../../../../core/components/app_back_button.dart';
import '../../../../routes/app_routes.dart';
import '../../../../supabase/supabase.dart';
import 'package:http/http.dart' as http;

class AllDistributors extends StatefulWidget {
  final Users? userData;
  const AllDistributors({super.key, this.userData});

  @override
  State<AllDistributors> createState() => _AllDistributorsState();
}

class _AllDistributorsState extends State<AllDistributors> {
  late SupaBaseDatabaseHelper handler;
  late Future<List<Users>> notes;
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

  Future<int> _userCount(String usrUserName, String usrType) async {
    List<CreateComp> usersList = await handler.getDistributorsData(usrUserName, usrType);
    return usersList.length; // Return the count of users found for the username
  }

  Future<int> _amount(String usrUserName, String usrType) async {
    List<CreateComp> usersList = await handler.getDistributorsData(usrUserName, usrType); // Fetch users
    int totalAmount = 0; // Initialize total amount to 0.0 for decimal values

    for (var user in usersList) {
      totalAmount += int.tryParse(user.usrPaidAmt) ?? 0;
    }
    return totalAmount;
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

  Future<List<Users>> getAllUsers() {
    return handler.getUsers(widget.userData!.usrUserName, widget.userData!.usrActive); // Fetch notes for the current user
  }

  Future<List<Users>> searchUsers() {
    return handler.searchUsers(keyword.text, widget.userData!.usrUserName, widget.userData!.usrActive);
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllUsers();
    });
  }

  @override
  void initState() {
    handler = SupaBaseDatabaseHelper();
    notes = handler.getUsers(widget.userData!.usrUserName, widget.userData!.usrActive); // Fetch notes for the current user
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Distributors'),
          automaticallyImplyLeading: false, // Remove the back button
          leading: const AppBackButton(),
        ),
        body: Column(
          children: [
            _SearchPageHeader(
              searchController: keyword,
              onSearchChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    notes = value.isNotEmpty ? searchUsers() : getAllUsers();
                  });
                }
              },
            ),
            Expanded(
              child: FutureBuilder<List<Users>>(
                future: notes,
                builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    final items = snapshot.data ?? <Users>[];
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return GestureDetector(
                          onTap: () {
                            // Navigate to the CompDetailsPage
                            Navigator.pushNamed(
                              context,
                              AppRoutes.distributorDetails,
                              arguments: item,
                            );
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: FutureBuilder<int>(
                              future: _userCount(item.usrUserName, item.usrActive), // Fetch user count
                              builder: (context, userCountSnapshot) {
                                if (userCountSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (userCountSnapshot.hasError) {
                                  return const Text("Error loading user count");
                                } else {
                                  return FutureBuilder<int>(
                                    future: _amount(item.usrUserName, item.usrActive), // Fetch total amount
                                    builder: (context, amountSnapshot) {
                                      if (amountSnapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (amountSnapshot.hasError) {
                                        return const Text("Error loading amount");
                                      } else {
                                        return DistributorCard(
                                          status: item.usrActive,
                                          name: item.usrName,
                                          email: item.usrEmail,
                                          users: userCountSnapshot.data ?? 0, // Use the fetched user count
                                          amt: amountSnapshot.data ?? 0, // Use the fetched amount
                                          phone: item.usrPhone,
                                          onDelete: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Delete Confirmation"),
                                                  content: const Text("Are you sure you want to delete this shop data?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(); // Close the dialog
                                                      },
                                                      child: const Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        db.deleteDistributor(item.usrId, widget.userData!.usrUserName).whenComplete(() {
                                                          _refresh();
                                                        });
                                                        Navigator.of(context).pop(); // Close the dialog after deletion
                                                      },
                                                      child: const Text("Delete"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}
class _SearchPageHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;

  const _SearchPageHeader({
    required this.searchController,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Form(
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        child: SvgPicture.asset(
                          AppIcons.search,
                          color: AppColors.primary,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                      contentPadding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    textInputAction: TextInputAction.search,
                    autofocus: true,
                    onChanged: onSearchChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
