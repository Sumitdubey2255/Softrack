import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softrack/JsonModels/users.dart';
import 'package:softrack/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Authtentication/otp_service.dart';
import '../../../JsonModels/comp_details.dart';
import '../../../JsonModels/create_comp.dart';
import '../../../constants/app_defaults.dart';
import '../../../core/components/app_back_button.dart';
import '../../../core/components/title_and_action_button.dart';
import '../../../supabase/supabase.dart';
import '../utils/validators.dart';
import '../verified_comp.dart';
import 'components/recent_pack.dart';
import 'package:http/http.dart' as http;

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
// green = 0xFFE8FFE0
// yellow = 0xFFFFFCEC
class distributorDetailsPage extends StatefulWidget {
  final Users? usersData;
  const distributorDetailsPage({super.key, this.usersData});
  // const _distributorDetailsPageState({super.key});

  @override
  State<distributorDetailsPage> createState() => _distributorDetailsPageState();
}

class _distributorDetailsPageState extends State<distributorDetailsPage> {
  final db = SupaBaseDatabaseHelper();
  late Future<List<CreateComp>> allCustomers;
  int? selectedSize; // Start with no selection
  List<CompDetails> compDetails = [];
  String days = "0";
  String activeStatus = "";
  final name = TextEditingController();
  final shopName = TextEditingController();
  final emailC = TextEditingController();
  final phone = TextEditingController();
  final aadhaar = TextEditingController();
  final compKey = TextEditingController();
  final otpController = TextEditingController();
  final startDate = TextEditingController();
  final previousServicesDay = TextEditingController();
  final endDate = TextEditingController();
  final userCount = TextEditingController();
  final daysExtend = TextEditingController();
  final daysCount = TextEditingController();
  final amount = TextEditingController();
  final OTPService _otpService = OTPService(); // Instantiate the OTP service
  String? generatedOtp; // Store the generated OTP
  bool isOtpVerified = false; // Track OTP verification status
  bool isEmailValid = false; // Track email validity
  bool isOtpValid = false; // Track OTP validity
  int points = 0;
  int totalAmount = 0;

  // final List<String> yrItems=['Default','1 month', '2 months', '3 months', '6 months', '8 months', '1 year'];
  // final List<String> userItems=['1 admin 0 user', '1 admin 1 user', '1 admin 2 user', '1 admin 3 user', '1 admin 4 user'];
  // final List<String> serviceItems=['Free Trial', 'Subscription'];
  // String? _selectedServiceDays;
  // String? _selectedServiceType;
  // String? _selectedAccountsAllowed;
  late SupaBaseDatabaseHelper handler;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
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

  Future<void> _launchCaller(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print("Could not launch ${launchUri.toString()}");
    }
  }

  Future<void> _launchSMS(String number) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: number,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print("Could not launch ${launchUri.toString()}");
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print('Could not launch $launchUri');
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print('Could not launch $launchUri');
    }
  }

  Future<void> _launchPhoneDialer(String number) async {
    try {
      const platform = MethodChannel('samples.flutter.dev/phoneDialer');
      await platform.invokeMethod('dialPhoneNumber', number);
      print("2nd");
    } on PlatformException catch (e) {
      print("Failed to launch phone dialer: '${e.message}'.");
    }
  }

  Future<int> _userCount(String usrUserName,String userType) async {
    List<CreateComp> usersList = await handler.getDistributorsData(usrUserName, userType);
    points = usersList.length * 50;
    for (var user in usersList) {
      totalAmount += int.tryParse(user.usrPaidAmt) ?? 0;
    }

    return usersList.length; // Return the count of users found for the username
  }

  Future<int> _activeUserCount(String usrUserName,String userType) async {
    int count=0;
    List<CreateComp> usersList = await handler.getDistributorsData(usrUserName, userType);
    for (CreateComp data in usersList){
      if(_status(data.usrNoOfDays).split("/")[0] == "active"){ // "active/0"
        count++;
      }
    }
    return count; // Return the count of users found for the username
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

  // Future<int> _amount(String usrUserName,String userType) async {
  //   List<CreateComp> usersList = await handler.getDistributorsData(usrUserName, userType); // Fetch users
  //   int totalAmount = 0; // Initialize total amount to 0.0 for decimal values
  //
  //   for (var user in usersList) {
  //     totalAmount += int.tryParse(user.usrPaidAmt) ?? 0;
  //   }
  //   return totalAmount;
  // }

  @override
  void initState() {
    super.initState();
    handler = SupaBaseDatabaseHelper();
    if (widget.usersData != null) {
      allCustomers = handler.getCompKeyByUsername(widget.usersData!.usrUserName, widget.usersData!.usrActive);
      _userCount(widget.usersData!.usrUserName, widget.usersData!.usrActive);
    } else {
      allCustomers = Future.value([]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AppBar(
            leading: const AppBackButton(),
            title: const Text('Details'),
            titleTextStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5DE0E6), // First color
                    Color(0xFF0078A6), // Second color
                  ],
                  begin: Alignment.topLeft, // Adjust the gradient direction as needed
                  end: Alignment.bottomRight, // Adjust the gradient direction as needed
                ),
              ),
            ),
          ),
          Container(
            color: const Color(0xFFFFFCEC),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3.0),
                          ),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child:  ClipOval(
                              child: Transform.scale(
                                scale: 1.2,
                                child: Image.asset(
                                  'lib/assets/images/distributor.png',
                                  fit: BoxFit.cover,
                                  width: 68,
                                  height: 68,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.center,
                          width: 70,
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.usersData!.usrActive.split("/")[0] == '1' ? const Color(0xFF00FF94) : Colors.red, // Conditional border color
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            widget.usersData!.usrActive.split("/")[0] == '1' ? "Active" : "Paused", // Correct text based on the status
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                            width: 210,
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Name: ${widget.usersData!.usrName}',
                              style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ),
                        // const SizedBox(height: 6),
                         Container(
                              width: 200,
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Phone: ${widget.usersData!.usrPhone}',
                                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black54),
                              ),
                            ),
                        // const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.mark_email_read, color: Colors.black, size: 25),
                            const SizedBox(width: 5.0),
                             Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(widget.usersData!.usrEmail,
                                  style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFFFFCEC),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconInfo(
                        icon: Icons.call,
                        label: 'Call',
                        onPressed: () {
                          _launchCaller(widget.usersData!.usrPhone);
                          _launchPhoneDialer(widget.usersData!.usrPhone);
                        },
                      ),
                      IconInfo(
                        icon: Icons.mail,
                        label: 'Email',
                        onPressed: () {
                          _sendEmail(widget.usersData!.usrEmail);
                        },
                      ),
                      IconInfo(
                        icon: Icons.sms,
                        label: 'SMS',
                        onPressed: ()  {
                          _launchSMS(widget.usersData!.usrPhone);
                        },
                      ),
                      IconInfo(
                        icon: Icons.maps_ugc_rounded,
                        label: 'WhatsApp',
                        onPressed: () {
                          _openWhatsApp(widget.usersData!.usrPhone);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const TitleAndInfoButton(
                    title: 'Credit Card',
                    actionLabel: "🛈",
                    // onTap: () => {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('This card shows how much points you earned from the customer. \nDo not share this with anyone.\n\nThank you')),
                    //   ),
                    // },
                  ),
                  SingleChildScrollView( // Add SingleChildScrollView here to make it scrollable
                    child: Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      padding: const EdgeInsets.all(20.0),
                      height: 200, // Set a fixed height for the card
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[800],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 8),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bank Name or Logo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                widget.usersData!.usrName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child:  ClipOval(
                                  child: Transform.scale(
                                    scale: 1.2,
                                    child: Image.asset(
                                      'lib/assets/images/Softrack.png',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Card Number
                           Text(
                            widget.usersData!.usrId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<List<int>>(
                            future: Future.wait([
                              _activeUserCount(widget.usersData!.usrUserName, widget.usersData!.usrActive),
                              _userCount(widget.usersData!.usrUserName, widget.usersData!.usrActive),
                            ]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                final data = snapshot.data!;
                                final activeCount = data[0];
                                final userCount = data[1];
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Credit Score",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "$points points",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Customers",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "$activeCount/$userCount active",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "System",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "KeepVeda 1.0.2",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return const Text('No data available');
                            },
                          ),
                          const SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Earned: $totalAmount/-",
                                style: const TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TitleAndActionButton(
                    title: 'Customers',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.allPackets, arguments: widget.usersData),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<CreateComp>>(
                    future: allCustomers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0), // Add vertical margin (top and bottom)
                          child: const Center(
                            child: Text("No recent data available"),
                          ),
                        );
                      } else {
                        final filteredItems = snapshot.data!.take(2).toList(); // Show only 2 most recent records
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
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width, // Adjust the percentage as needed
                                    ),
                                    child: RecentPackCard(
                                      customerName: comp.usrName,
                                      shopName: comp.usrShopName,
                                      email: comp.usrEmail,
                                      phone: comp.usrPhone,
                                      status: _status(comp.usrNoOfDays).split("/")[0],
                                      username: widget.usersData!.usrActive,
                                      distributor: comp.usrUserName,
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
                                                            widget.usersData!.usrUserName,
                                                          ).whenComplete(() {
                                                            showGeneralDialog(
                                                              barrierLabel: 'Dialog',
                                                              barrierDismissible: true,
                                                              context: context,
                                                              pageBuilder: (ctx, anim1, anim2) =>
                                                                  VerifiedComp(username: widget.usersData),
                                                              transitionBuilder: (ctx, anim1, anim2, child) =>
                                                                  ScaleTransition(scale: anim1, child: child),
                                                            );
                                                            setState(() {
                                                              allCustomers = db.getCompKeyByUsername(widget.usersData!.usrUserName, widget.usersData!.usrActive);
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
                                                    db.deleteNote(comp.usrId, widget.usersData!.usrUserName).whenComplete(() {
                                                      setState(() {
                                                        allCustomers = db.getCompKeyByUsername(widget.usersData!.usrUserName, widget.usersData!.usrActive);
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
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: Theme.of(context).primaryColor.withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );

  items(String title, String text, Color background) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: Theme.of(context).primaryColor.withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            const SizedBox(width: 10.0),
            const Icon(Icons.location_on_outlined, color: Color(0xFF5EC4D7), size: 18),
            const SizedBox(width: 5.0),
            Text(title.toUpperCase(),style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        Container(
          width: 285,
          // height: 100,
          margin: const EdgeInsets.all(10),
          child: Text(text),
        ),
        const SizedBox(height: 15),
      ],
    ),
  );

}

class IconInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed; // Callback for the onPressed event

  const IconInfo({super.key, required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal.withOpacity(0.1),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Icon(icon, color: Colors.teal),
          ),
          const SizedBox(height: 4.0),
          Text(label, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}

class BoxIcon extends StatelessWidget {
  final IconData icons;
  final VoidCallback onPressed; // Callback for the onPressed event

  const BoxIcon({super.key, required this.icons, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent.withOpacity(0.1),
            ),
            padding: const EdgeInsets.all(3.0),
            child: Icon(icons, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
