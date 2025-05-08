import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../Authtentication/otp_service.dart';
import '../../../../JsonModels/create_comp.dart';
import '../../../../JsonModels/users.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_icons.dart';
import '../../../../core/components/app_back_button.dart';
import '../../../../routes/app_routes.dart';
import '../../../../supabase/supabase.dart';
import '../../search/search_CompKey.dart';
import '../../utils/validators.dart';
import 'package:http/http.dart' as http;

import '../../verified_comp.dart';

class AllRecentPackPage extends StatefulWidget {
  final Users? userData;
  const AllRecentPackPage({super.key, this.userData});

  @override
  State<AllRecentPackPage> createState() => _NotesState();
}

class _NotesState extends State<AllRecentPackPage> {
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
  final aadhaar = TextEditingController();
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

  String _status(String totalDays){
    // String totalDays = widget.users!.usrNoOfDays;
    String activeStatus = "";
    List<String> parts = totalDays.split('/');
    if (parts.length == 2) { // "90/active"
      activeStatus = "${parts[1]}/0";   // "active"
    } else if (parts.length == 3) { // "90/active/0"
      activeStatus = "${parts[1]}/${parts[2]}";   // "active"
    } else if (parts.length == 4) { // "06/90/active/02"
      activeStatus = "${parts[2]}/${parts[3]}";   // "active/02"
    } else {
      activeStatus = '';
    }
    return activeStatus; // "active/0"
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
          title: const Text('Recent Records'),
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
                    notes = value.isNotEmpty ? searchCompKey() : getAllCompKey();
                  });
                }
              },
            ),
            Expanded(
              child: FutureBuilder<List<CreateComp>>(
                future: notes,
                builder: (BuildContext context, AsyncSnapshot<List<CreateComp>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    final currentDate = DateTime.now();
                    final currentMonth = currentDate.month;
                    final currentYear = currentDate.year;

                    // Filter records to only include those from the current month and year
                    final filteredItems = snapshot.data!.where((item) {
                      try {
                        DateTime createdAt = DateTime.parse(
                          item.createdAt.split("/").length == 2
                              ? item.createdAt.split("/")[0]
                              : item.createdAt,
                        );
                        return createdAt.month == currentMonth && createdAt.year == currentYear;
                      } catch (e) {
                        return false; // Skip records with invalid dates
                      }
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return const Center(child: Text("No recent records available"));
                    }

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        String formattedDate;
                        try {
                          formattedDate = DateFormat("dd/MM/yyyy").format(
                            DateTime.parse(
                              item.createdAt.split("/").length == 2
                                  ? item.createdAt.split("/")[0]
                                  : item.createdAt,
                            ),
                          );
                        } catch (e) {
                          formattedDate = "Invalid date";
                        }

                        return GestureDetector(
                          onTap: () {
                            // Navigate to the CompDetailsPage
                            Navigator.pushNamed(
                              context,
                              AppRoutes.comp_detailsPage,
                              arguments: item,
                            );
                          },
                          child: CompKeyCard(
                            customerName: item.usrName,
                            shopName: item.usrShopName,
                            email: item.usrEmail,
                            phone: item.usrPhone,
                            status: _status(item.usrNoOfDays).split("/")[0],
                            // username: widget.userData!.usrUserName,
                            username: widget.userData!.usrActive,
                            distributor: item.usrName,
                            formattedDate: formattedDate,
                            onEdit: () {
                              setState(() {
                                name.text = item.usrName;
                                shopName.text = item.usrShopName;
                                emailC.text = item.usrEmail;
                                phone.text = item.usrPhone;
                                aadhaar.text = item.usrAadharNo;
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              if (generatedOtp != null && generatedOtp!.trim() == otpController.text.trim()) {
                                                db.updateCompKey(
                                                  name.text,
                                                  shopName.text,
                                                  emailC.text,
                                                  phone.text,
                                                  aadhaar.text,
                                                  item.usrId,
                                                  widget.userData!.usrUserName,
                                                ).whenComplete(() {
                                                  showGeneralDialog(
                                                    barrierLabel: 'Dialog',
                                                    barrierDismissible: true,
                                                    context: context,
                                                    pageBuilder: (ctx, anim1, anim2) =>
                                                        VerifiedComp(username: widget.userData),
                                                    transitionBuilder: (ctx, anim1, anim2, child) =>
                                                        ScaleTransition(scale: anim1, child: child),
                                                  );
                                                  setState(() {
                                                    notes = db.getCompKeyByUsername(widget.userData!.usrUserName, widget.userData!.usrActive);
                                                  });
                                                  Navigator.pop(context);
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Invalid OTP')),
                                                );
                                              }
                                            },
                                            child: const Text("Update"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                        ],
                                      ),
                                    ],
                                    title: const Text("Update data"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: name,
                                            validator: Validators.requiredWithFieldName('Name').call,
                                            textInputAction: TextInputAction.next,
                                            decoration: const InputDecoration(
                                              label: Text("Name"),
                                            ),
                                          ),
                                          const SizedBox(height: AppDefaults.padding),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: phone,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            validator: Validators.phone.call,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: const InputDecoration(
                                              label: Text("Phone"),
                                            ),
                                          ),
                                          const SizedBox(height: AppDefaults.padding),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: shopName,
                                            validator: Validators.requiredWithFieldName('Shop Name').call,
                                            textInputAction: TextInputAction.next,
                                            decoration: const InputDecoration(
                                              label: Text("Shop Name"),
                                            ),
                                          ),
                                          const SizedBox(height: AppDefaults.padding),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: aadhaar,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            validator: Validators.aadhaarNo.call,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: const InputDecoration(
                                              label: Text("Aadhaar No."),
                                            ),
                                          ),
                                          const SizedBox(height: AppDefaults.padding),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: emailC,
                                                  validator: Validators.email.call,
                                                  textInputAction: TextInputAction.next,
                                                  onChanged: (value) => _validateEmail(),
                                                  decoration: const InputDecoration(
                                                    label: Text("Email"),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.send),
                                                tooltip: "Send OTP",
                                                onPressed: _sendOtp,
                                                color: isEmailValid ? Colors.green : Colors.red,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: AppDefaults.padding),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: otpController,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            validator: Validators.requiredWithFieldName("OTP").call,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: const InputDecoration(
                                              label: Text("OTP"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
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
                                          db.deleteNote(item.usrId, widget.userData!.usrUserName).whenComplete(() {
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
