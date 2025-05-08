import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../../Authtentication/otp_service.dart';
import '../../../JsonModels/users.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_images.dart';
import '../../../core/components/title_and_action_button.dart';
import '../../../routes/app_routes.dart';
import '../utils/validators.dart';
import '../verified_comp.dart';
import 'components/ad_space.dart';
import 'components/recent_pack.dart';
import '../../../../JsonModels/create_comp.dart'; // Make sure to import the required models
import '../../../../supabase/supabase.dart'; // Update with your actual path
import 'package:http/http.dart' as http;

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class HomePage extends StatefulWidget {
  final Users? users;
  const HomePage({super.key, this.users});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<CreateComp>> recentComps;
  late Future<List<Users>> distributorss;
  late SupaBaseDatabaseHelper handler;
  final name = TextEditingController();
  final emailC = TextEditingController();
  final phone = TextEditingController();
  final aadhaar = TextEditingController();
  final shopName = TextEditingController();
  final compKey = TextEditingController();
  final otpController = TextEditingController();
  final verified = TextEditingController();
  final db = SupaBaseDatabaseHelper();
  final OTPService _otpService = OTPService(); // Instantiate the OTP service
  String? generatedOtp; // Store the generated OTP
  bool isOtpVerified = false; // Track OTP verification status
  bool isEmailValid = false; // Track email validity
  bool isOtpValid = false; // Track OTP validity

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
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Check your email again')),
      );
    }
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
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Email is not valid')),
      );
    }
  }

  void _validateEmail() {
    setState(() {
      isEmailValid = Validators.email(emailC.text) == null;
    });
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

  Future<int> _userCount(String usrUserName,String userType) async {
    List<CreateComp> usersList = await handler.getDistributorsData(usrUserName, userType);
    return usersList.length; // Return the count of users found for the username
  }

  Future<int> _amount(String usrUserName,String userType) async {
    List<CreateComp> usersList = await handler.getDistributorsData(usrUserName, userType); // Fetch users
    int totalAmount = 0; // Initialize total amount to 0.0 for decimal values

    for (var user in usersList) {
      totalAmount += int.tryParse(user.usrPaidAmt) ?? 0;
    }
    return totalAmount;
  }

  @override
  void initState() {
    super.initState();
    handler = SupaBaseDatabaseHelper();
    if (widget.users != null) {
      recentComps = handler.getCompKeyByUsername(widget.users!.usrUserName, widget.users!.usrActive);
      distributorss = handler.getUsers(widget.users!.usrUserName, widget.users!.usrActive);
    } else {
      recentComps = Future.value([]);
      distributorss = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.drawerPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F6F3),
                    shape: const CircleBorder(),
                  ),
                  child: SvgPicture.asset(AppIcons.sidebarIcon),
                ),
              ),
              floating: true,
              title:
              // NetworkImageWithLoader(AppImages.bannerLogo),
              Image.asset(
                // "lib/assets/images/logo_head.png",
                AppImages.bannerLogo,
                height: 32,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.search, arguments: widget.users);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2F6F3),
                      shape: const CircleBorder(),
                    ),
                    child: SvgPicture.asset(AppIcons.search),
                  ),
                ),
              ],
            ),
            const SliverToBoxAdapter(
              child: AdSpace(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(right: 8, top: 6, bottom: 4, left: 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    TitleAndActionButton(
                      title: 'Recent',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.allRecentPackets, arguments: widget.users),
                    ),
                    FutureBuilder<List<CreateComp>>(
                      future: recentComps,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Container(
                            margin: const EdgeInsets.only(top: 20.0,bottom: 20.0), // Add vertical margin (top and bottom)
                            child: const Center(
                              child: Text("No recent data available"),
                            ),
                          );
                        } else {
                          final now = DateTime.now(); // Current date
                          final currentMonth = now.month;
                          final currentYear = now.year;

                          // Filter records for the current month
                          final filteredItems = snapshot.data!.where((comp) {
                            final createdAt = DateTime.parse(
                                comp.createdAt.split("/").length == 2 ? comp.createdAt.split("/")[0] : comp.createdAt
                            );
                            return createdAt.month == currentMonth && createdAt.year == currentYear;
                          }).take(2).toList(); // Show only 2 most recent records

                          if (filteredItems.isEmpty) {
                            return const Center(child: Text("No recent data available for the current month"));
                          }
                          return SizedBox(
                            height: 210.0, // Adjust the height as needed
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredItems.length, // Limit to 2 records
                              itemBuilder: (context, index) {
                                final comp = filteredItems[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0), // Add right padding for space between cards
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, AppRoutes.comp_detailsPage, arguments: comp);
                                    },
                                    child: SizedBox(
                                      width: 350.0, // Set the desired width of each card
                                      child: RecentPackCard(
                                        customerName: comp.usrName,
                                        shopName: comp.usrShopName,
                                        email: comp.usrEmail,
                                        phone: comp.usrPhone,
                                        status: _status(comp.usrNoOfDays).split("/")[0],
                                        // username: widget.users!.usrUserName,
                                        username: widget.users!.usrActive,
                                        distributor: comp.usrName,
                                        formattedDate: DateFormat("dd/MM/yyyy").format(
                                          DateTime.parse(
                                              comp.createdAt.split("/").length == 2 ? comp.createdAt.split("/")[0] : comp.createdAt
                                          ),
                                        ),
                                        onEdit: () {
                                          setState(() {
                                            name.text = comp.usrName;
                                            shopName.text = comp.usrShopName;
                                            emailC.text = comp.usrEmail;
                                            phone.text = comp.usrPhone;
                                            aadhaar.text = comp.usrAadharNo;
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
                                                              comp.usrId,
                                                              widget.users!.usrUserName,
                                                            ).whenComplete(() {
                                                              showGeneralDialog(
                                                                barrierLabel: 'Dialog',
                                                                barrierDismissible: true,
                                                                context: context,
                                                                pageBuilder: (ctx, anim1, anim2) =>
                                                                    VerifiedComp(username: widget.users),
                                                                transitionBuilder: (ctx, anim1, anim2, child) =>
                                                                    ScaleTransition(scale: anim1, child: child),
                                                              );
                                                              setState(() {
                                                                recentComps = db.getCompKeyByUsername(widget.users!.usrUserName, widget.users!.usrActive);
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
                                                      db.deleteNote(comp.usrId, widget.users!.usrUserName).whenComplete(() {
                                                        setState(() {
                                                          recentComps = db.getCompKeyByUsername(widget.users!.usrUserName, widget.users!.usrActive);
                                                        });
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
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (widget.users!.usrActive.split("/")[1] == "administrator")
              SliverPadding(
                padding: const EdgeInsets.only(right: 8, top: 6, bottom: 4, left: 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TitleAndActionButton(
                        title: 'Distributors',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.allDistributor, arguments: widget.users),
                      ),
                      FutureBuilder<List<Users>>(
                        future: distributorss,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Container(
                              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                              child: const Center(
                                child: Text("No distributor data available"),
                              ),
                            );
                          } else {
                            final filteredItems = snapshot.data!.take(2).toList(); // Limit to 2 records
                            if (filteredItems.isEmpty) {
                              return const Center(child: Text("No Distributor data available!"));
                            }
                            return SizedBox(
                              height: 210.0, // Adjust the height as needed
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) {
                                  final comp = filteredItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, AppRoutes.distributorDetails, arguments: comp);
                                      },
                                      child: SizedBox(
                                        width: 330.0, // Set the desired width of each card
                                        child: FutureBuilder<int>(
                                          future: _userCount(comp.usrUserName, comp.usrActive), // Get the count of users
                                          builder: (context, userCountSnapshot) {
                                            if (userCountSnapshot.connectionState == ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (userCountSnapshot.hasError) {
                                              return const Text("Error loading users");
                                            } else {
                                              return FutureBuilder<int>(
                                                future: _amount(comp.usrUserName, comp.usrActive), // Get the total amount
                                                builder: (context, amountSnapshot) {
                                                  if (amountSnapshot.connectionState == ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (amountSnapshot.hasError) {
                                                    return const Text("Error loading amount");
                                                  } else {
                                                    return DistributorCard(
                                                      status: comp.usrActive,
                                                      name: comp.usrName,
                                                      email: comp.usrEmail,
                                                      users: userCountSnapshot.data ?? 0, // Use the user count from FutureBuilder
                                                      amt: amountSnapshot.data ?? 0, // Use the amount from FutureBuilder
                                                      phone: comp.usrPhone,
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
                                                                    db.deleteDistributor(comp.usrId, widget.users!.usrUserName).whenComplete(() {
                                                                      setState(() {
                                                                        distributorss = db.getUsers(widget.users!.usrUserName, widget.users!.usrActive);
                                                                      });
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
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.only(right: 8, top: 6, bottom: 4, left: 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    TitleAndActionButton(
                      title: 'Applications',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.allApps, arguments: widget.users),
                    ),
                    const SoftwareCard(
                      imageUrl: AppImages.keepvedaLogo,
                      title: 'KeepVeda',
                      subtitle: 'Medical Billing Software',
                      url: 'https://drive.google.com/file/d/1PVJDYgS_RxgxR3GnOD7QH3urU7l7DQRv/view?usp=drive_link',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
