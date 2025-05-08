import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
// -----------------------------------------------
import 'package:softrack/routes/app_routes.dart';
import '../../../core/components/app_back_button.dart';
import '../../../supabase/supabase.dart';
import 'core/components/title_and_action_button.dart';
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
// green = 0xFFE8FFE0
// yellow = 0xFFFFFCEC

class BusinessCardList extends StatelessWidget {
  const BusinessCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        const CompDetailsCard(),
        CompDetailsDistributorCard(),
        const SoftwareCard(),
      ],
    );
  }
}

class CompDetailsCard extends StatelessWidget {
  const CompDetailsCard({super.key});


  void sendEmail({required String to, required String mailMessage}) async{
      String from = 'typicaldesktop@gmail.com';
      final smtpServer = gmail(from, "cwaxnlbiwdbjldsl");
      // final smtpServer = gmailSaslXoauth2(from, 'cwaxnlbiwdbjldsl');
      final message = Message()
         ..from = Address(from, "Mail service")
         ..recipients.add(to)
         ..subject = 'subject nai h'
         ..text = 'hello brother: $mailMessage';
    try{
      await send(message, smtpServer);
      print('Email sent');
    }catch(e){
      if(kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white, // Set the background color
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Transform.scale(
                      scale: 0.8,
                      child: Image.asset(
                        'images/typical_desktop.png',
                        fit: BoxFit.cover,
                        width: 65,
                        height: 65,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 26.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Name',
                        // AppLocalizations.of(context)!.helloWorld,
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Shop: Medicare',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 3.0),
                      const Row(
                        children: [
                          Icon(Icons.date_range_sharp, color: Colors.teal, size: 14),
                          SizedBox(width: 5.0),
                          Text('22/06/2024', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 16.0),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    BoxIcon(icons: Icons.edit,onPressed: () => print('Edit icon pressed')),
                    const SizedBox(height: 8.0),
                    BoxIcon(icons: Icons.delete,onPressed: () => print('delete icon pressed')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconInfo(
                  icon: Icons.call,
                  label: 'Call',
                  onPressed: () {
                    print('Call button pressed');
                  },
                ),
                IconInfo(
                  icon: Icons.mail,
                  label: 'Email',
                  onPressed: () => sendEmail(to: "sd889506@gmail.com",mailMessage: "ShutUp"),
                ),
                IconInfo(
                  icon: Icons.sms,
                  label: 'SMS',
                  onPressed: () {
                    print('SMS button pressed');
                  },
                ),
                IconInfo(
                  icon: Icons.whatshot,
                  label: 'WhatsApp',
                  onPressed: () {
                    print('WhatsApp button pressed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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

class SoftwareCard extends StatelessWidget {
  const SoftwareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child:
      Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 17.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white, // Set the background color
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Transform.scale(
                      scale: 0.8,
                      child: Image.asset('images/keepveda.png',
                        fit: BoxFit.cover, width: 65, height: 65,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                      const Text('KeepVeda',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 2.0),
                      Text('Medical Billing Software',
                        style: TextStyle(fontSize: 15.0, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white, // Set the background color
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Image.asset('images/typical_desktop.png',
                                    fit: BoxFit.cover, width: 20, height: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2.0),
                            const SizedBox(height: 2.0),
                            Text(
                              'by Typical Desktop',
                              style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    BoxIcon(icons: Icons.link,onPressed: () => print('link icon pressed')),
                    const SizedBox(height: 11.0),
                    BoxIcon(icons: Icons.share_outlined,onPressed: () => print('share icon pressed')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CompDetailsDistributorCard extends StatelessWidget {
  int status = 0;
  String name = "Sumit Sunil Dubey";
  String email = "email";
  int users = 2;
  int amt = 2000;
  String phone = "9541254785";

  CompDetailsDistributorCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 17.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status == 0? Colors.red: Colors.green, // Set the border color to red
                      width: 2.0,       // Set the border width
                    ),
                  ),
                  child: ClipOval(
                    child: Transform.scale(
                      scale: 1.3,
                      child: Image.asset(
                        'lib/assets/images/distributor.png',
                        fit: BoxFit.cover,
                        width: 68,
                        height: 68,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                       Row(
                        children: [
                          const Text('Distributor: ',
                            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          const SizedBox(width: 2.0),
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.green),
                              overflow: TextOverflow.ellipsis, // This will add "..." when text is too long
                              maxLines: 1, // Ensures that it only shows on one line
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        children: [
                          const Icon(Icons.person_add_alt_sharp, color: Colors.teal, size: 16),
                          const SizedBox(width: 5.0),
                          Text('Customers: ',
                            style: TextStyle(fontSize: 15.0, color: Colors.grey[600], fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 2.0),
                          Text('$users users',
                            style: TextStyle(fontSize: 13.0, color: Colors.grey[600], fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white, // Set the background color
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Transform.scale(
                                scale: 0.9,
                                child: Image.asset('lib/assets/images/rupee.png',
                                  fit: BoxFit.cover, width: 20, height: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text('$amt/-', style: const TextStyle(fontSize: 12,)),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    BoxIcon(icons: Icons.delete,onPressed: () => print('delete icon pressed')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconInfo(
                  icon: Icons.call,
                  label: 'Call',
                  onPressed: () {
                    print('Call button pressed');
                  },
                ),
                IconInfo(
                  icon: Icons.mail,
                  label: 'Email',
                  onPressed: () {},
                  // onPressed: () => sendEmail(to: "sd889506@gmail.com",mailMessage: "ShutUp"),
                ),
                IconInfo(
                  icon: Icons.sms,
                  label: 'SMS',
                  onPressed: () {
                    print('SMS button pressed');
                  },
                ),
                IconInfo(
                  icon: Icons.whatshot,
                  label: 'WhatsApp',
                  onPressed: () {
                    print('WhatsApp button pressed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class distributorCardDetailsPage extends StatefulWidget {
  // final CreateComp? usersData;
  // const distributorCardDetailsPage({super.key, this.usersData});
  const distributorCardDetailsPage({super.key});

  @override
  State<distributorCardDetailsPage> createState() => _distributorCardDetailsPageState();
}
final db = SupaBaseDatabaseHelper();
class _distributorCardDetailsPageState extends State<distributorCardDetailsPage> {
  // int? selectedSize; // Start with no selection
  // List<CompDetails> compDetails = [];
  // String days = "0";
  // String activeStatus = "";

  // final name = TextEditingController();
  // final shopName = TextEditingController();
  // final email = TextEditingController();
  // final phone = TextEditingController();
  // final compKey = TextEditingController();
  // final startDate = TextEditingController();
  // final previousServicesDay = TextEditingController();
  // final endDate = TextEditingController();
  // final userCount = TextEditingController();
  // final daysExtend = TextEditingController();
  // final daysCount = TextEditingController();
  // final amount = TextEditingController();
  // final List<String> yrItems=['Default','1 month', '2 months', '3 months', '6 months', '8 months', '1 year'];
  // final List<String> userItems=['1 admin 0 user', '1 admin 1 user', '1 admin 2 user', '1 admin 3 user', '1 admin 4 user'];
  // final List<String> serviceItems=['Free Trial', 'Subscription'];
  // String? _selectedServiceDays;
  // String? _selectedServiceType;
  // String? _selectedAccountsAllowed;

  // String? dropdownValidator(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please select a value';
  //   }
  //   return null;
  // }

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
                    const SizedBox(width: 20),
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
                        const SizedBox(height: 7),
                        Container(
                          alignment: Alignment.center,
                          width: 85,
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: "active" == "active" ? const Color(0xFF00FF94) : Colors.red, // Conditional border color
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: const Text(
                            "active" == "active" ? "Active" : "Paused", // Correct text based on the status
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 210,
                          padding: const EdgeInsets.all(4.0),
                          child:
                          const Text('Name: Sumit Dubey',
                            style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                        // const SizedBox(height: 6),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.all(4.0),
                          child: const Text(
                            'Phone: 9146090984',
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ),
                        // const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.mark_email_read, color: Colors.black, size: 25),
                            const SizedBox(width: 8.0),
                            Container(
                              // width: 186,
                              padding: const EdgeInsets.all(4.0),
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.black, width: 2.0),
                              //   borderRadius: BorderRadius.circular(5.0),
                              // ),
                              child: const Text('sumit@gmail.com',
                                // DateFormat("dd/MM/yyyy").format(
                                //     DateTime.parse(
                                //         widget.usersData!.createdAt.split("/").length > 1 ? widget.usersData!.createdAt.split("/")[0] : widget.usersData!.createdAt
                                //     )
                                // ),
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(height: 30),
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
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconInfo(
                        icon: Icons.call,
                        label: 'Call',
                        onPressed: () {
                          // _launchCaller(phone);
                          // _launchPhoneDialer(phone);
                        },
                      ),
                      IconInfo(
                        icon: Icons.mail,
                        label: 'Email',
                        onPressed: () {
                          // _sendEmail(email);
                        },
                      ),
                      IconInfo(
                        icon: Icons.sms,
                        label: 'SMS',
                        onPressed: ()  {
                          // _launchSMS(phone);
                        },
                      ),
                      IconInfo(
                        icon: Icons.maps_ugc_rounded,
                        label: 'WhatsApp',
                        onPressed: () {
                          // _openWhatsApp(phone);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TitleAndActionButton(
                    title: 'Credit Card',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.login),
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
                              const Text(
                                "Sumit Sunil Dubey",
                                style: TextStyle(
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
                              // Image.network(
                              //   'lib/assets/images/Softrack.png',
                              //   height: 50,
                              //   width: 50,
                              // )
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Card Number
                          const Text(
                            "1234 5678 9876 5432",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Credit Score",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "200 points",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customers",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "4/5 active",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Earned: 5000/-",
                                style: TextStyle(
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
                    title: 'Customer',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                  ),
                  const SizedBox(height: 20),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   padding: const EdgeInsets.only(left:5,bottom: 10, right: 5),
                  //   child:Row(
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(10),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               offset: const Offset(0, 4),
                  //               color: Theme.of(context).primaryColor.withOpacity(.3),
                  //               spreadRadius: 3,
                  //               blurRadius: 5,
                  //             ),
                  //           ],
                  //         ),
                  //         child: Column(
                  //           // mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             const SizedBox(height: 12),
                  //             const Row(
                  //               children: [
                  //                 Icon(Icons.account_circle_rounded,
                  //                     color: Color(0xD0494B49), size: 24),
                  //                 SizedBox(width: 5.0),
                  //                 Text('Customer Details',
                  //                   style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54),
                  //                 ),
                  //               ],
                  //             ),
                  //             Container(
                  //               // width: 210,
                  //               // mainAxisAlignment: MainAxisAlignment.center,
                  //                 margin: const EdgeInsets.all(10),
                  //                 child: const Column(
                  //                   children: [
                  //                     SizedBox(height: 2),
                  //                     Row(
                  //                       children: [
                  //                         // const Icon(Icons.add_chart_rounded, color: Color(0xFF5EC4D7), size: 21),
                  //                         SizedBox(width: 5.0),
                  //                         Text('Name: Shubham Maurya', style: TextStyle(fontSize: 14)),
                  //                         SizedBox(width: 16.0),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 4),
                  //                     Row(
                  //                       children: [
                  //                         // const Icon(Icons.access_time, color: Color(0xFF04CB49), size: 21),
                  //                         // const SizedBox(width: 5.0),
                  //                         Text('Plan: Free trial', style: TextStyle(fontSize: 14)),
                  //                         SizedBox(width: 16.0),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 5),
                  //                     Row(
                  //                       children: [
                  //                         // const Icon(Icons.currency_rupee_outlined, color: Color(0xFF5EC4D7), size: 21),
                  //                         SizedBox(width: 5.0),
                  //                         Text('Period: 306 days', style: TextStyle(fontSize: 14)),
                  //                         SizedBox(width: 16.0),
                  //                       ],
                  //                     ),
                  //                     Row(
                  //                       children: [
                  //                         // const Icon(Icons.currency_rupee_outlined, color: Color(0xFF5EC4D7), size: 21),
                  //                         SizedBox(width: 5.0),
                  //                         Text('Paid Amount: 2000/-', style: TextStyle(fontSize: 14)),
                  //                         SizedBox(width: 16.0),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 )
                  //             ),
                  //             const SizedBox(height: 4),
                  //           ],
                  //         ),
                  //       ),
                  //       const SizedBox(width: 20),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(10),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               offset: const Offset(0, 5),
                  //               color: Theme.of(context).primaryColor.withOpacity(.2),
                  //               spreadRadius: 2,
                  //               blurRadius: 5,
                  //             ),
                  //           ],
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             const SizedBox(height: 3),
                  //             Container(
                  //               padding: const EdgeInsets.all(10),
                  //               width: 90,
                  //               // height: 60,
                  //               margin: const EdgeInsets.all(10),
                  //               decoration: const BoxDecoration(
                  //                 color: Colors.blueGrey,
                  //                 shape: BoxShape.circle,
                  //               ),
                  //               child: const Icon(CupertinoIcons.app_badge_fill, color: Colors.white, size: 40,),
                  //             ),
                  //             Text('Day Count',
                  //                 style: Theme.of(context).textTheme.titleMedium),
                  //             Center(
                  //               child: Text("{_dayCount()} Days",
                  //                   style: Theme.of(context).textTheme.titleMedium),
                  //             ),
                  //             const SizedBox(height: 4),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 25),
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
