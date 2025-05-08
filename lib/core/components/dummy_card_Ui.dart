// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import '../../../Authtentication/otp_service.dart';
// import '../../../JsonModels/create_comp.dart';
// import '../../../JsonModels/users.dart';
// import '../../../constants/app_colors.dart';
// import '../../../constants/app_defaults.dart';
// import '../../../constants/app_icons.dart';
// import '../../../supabase/supabase.dart';
// import 'package:http/http.dart' as http;
//
// import '../../Views/dialogs/utils/validators.dart';
// import '../../Views/dialogs/verified_comp.dart';
//
// class DummyCardUiPage extends StatefulWidget {
//   final Users? userData;
//   const DummyCardUiPage({super.key, this.userData});
//
//   @override
//   State<DummyCardUiPage> createState() => _DummyCardUiPageState();
// }
//
// class _DummyCardUiPageState extends State<DummyCardUiPage> {
//   late SupaBaseDatabaseHelper handler;
//   Future<List<CreateComp>>? notes;
//   final db = SupaBaseDatabaseHelper();
//
//   final title = TextEditingController();
//   final content = TextEditingController();
//   final keyword = TextEditingController();
//   final _key = GlobalKey<FormState>();
//   final OTPService _otpService = OTPService(); // Instantiate the OTP service
//
//   final name = TextEditingController();
//   final emailC = TextEditingController();
//   final phone = TextEditingController();
//   final shopName = TextEditingController();
//   final compKey = TextEditingController();
//   final otpController = TextEditingController();
//   final verified = TextEditingController();
//
//   String? generatedOtp; // Store the generated OTP
//   bool isOtpVerified = false; // Track OTP verification status
//   bool isEmailValid = false; // Track email validity
//   bool isOtpValid = false; // Track OTP validity
//
//   void sendEmail(String email, String subject, String message, String toName) async {
//     var serviceId = 'service_bfwqbno',
//         templateId = 'template_6spyyhv',
//         userId = 'HTqVXzJ3HxAhX5v10';
//
//     var response = await http.post(
//       Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
//       headers: {
//         'origin': 'http://localhost',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'service_id': serviceId,
//         'user_id': userId,
//         'template_id': templateId,
//         'template_params': {
//           'name': toName,
//           'subject': subject,
//           'message': message,
//           'sender_email': email,
//         },
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('OTP sent successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to send OTP. Check your email again')),
//       );
//     }
//   }
//
//   void _sendOtp() {
//     if (isEmailValid) {
//       generatedOtp = _otpService.generateOTP().toString(); // Convert OTP to String
//       sendEmail(
//         emailC.text.toString(),
//         "Verify Your Email",
//         "Your OTP for verifying email on Softrack for KeepVeda is $generatedOtp. The code will be valid until the next Resend of new OTP.",
//         "Dear Customer",
//       );
//     } else {
//       print('Email is not valid');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Email is not valid')),
//       );
//     }
//   }
//
//   void _validateEmail() {
//     setState(() {
//       isEmailValid = Validators.email(emailC.text) == null;
//     });
//   }
//
//   @override
//   void initState() {
//     handler = SupaBaseDatabaseHelper();
//     notes = handler.getCompKeyByUsername(widget.userData!.usrUserName);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("All Data"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<List<CreateComp>>(
//               future: notes,
//               builder: (BuildContext context, AsyncSnapshot<List<CreateComp>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No data"));
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text(snapshot.error.toString()));
//                 } else {
//                   final items = snapshot.data ?? <CreateComp>[];
//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       String formattedDate;
//                       try {
//                         formattedDate = DateFormat("dd/MM/yyyy")
//                             .format(DateTime.parse(item.createdAt));
//                       } catch (e) {
//                         formattedDate = "Invalid date";
//                       }
//                       return CompKeyCard(
//                         customerName: item.usrName,
//                         shopName: item.usrShopName,
//                         formattedDate: formattedDate,
//                         onEdit: () {
//                           setState(() {
//                             name.text = item.usrName;
//                             shopName.text = item.usrShopName;
//                             emailC.text = item.usrEmail;
//                             phone.text = item.usrPhone;
//                           });
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 actions: [
//                                   Row(
//                                     children: [
//                                       TextButton(
//                                         onPressed: () {
//                                           if (generatedOtp != null && generatedOtp!.trim() == otpController.text.trim()) {
//                                             db.updateCompKey(
//                                               name.text,
//                                               shopName.text,
//                                               emailC.text,
//                                               phone.text,
//                                               item.usrId,
//                                               widget.userData!.usrUserName,
//                                             ).whenComplete(() {
//                                               setState(() {
//                                                 notes = handler.getCompKeyByUsername(widget.userData!.usrUserName);
//                                               });
//                                               Navigator.pop(context);
//                                             }).whenComplete(() {
//                                               showGeneralDialog(
//                                                 barrierLabel: 'Dialog',
//                                                 barrierDismissible: true,
//                                                 context: context,
//                                                 pageBuilder: (ctx, anim1, anim2) => VerifiedComp(username: widget.userData),
//                                                 transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
//                                                   scale: anim1,
//                                                   child: child,
//                                                 ),
//                                               );
//                                               setState(() {
//                                                 notes = handler.getCompKeyByUsername(widget.userData!.usrUserName);
//                                               });
//                                               Navigator.pop(context);
//                                             });
//                                           } else {
//                                             ScaffoldMessenger.of(context).showSnackBar(
//                                               const SnackBar(content: Text('Invalid OTP')),
//                                             );
//                                           }
//                                         },
//                                         child: const Text("Update"),
//                                       ),
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: const Text("Cancel"),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                                 title: const Text("Update data"),
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: name,
//                                       validator: Validators.requiredWithFieldName('Name').call,
//                                       textInputAction: TextInputAction.next,
//                                       decoration: const InputDecoration(
//                                         label: Text("Name"),
//                                       ),
//                                     ),
//                                     const SizedBox(height: AppDefaults.padding),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: phone,
//                                       textInputAction: TextInputAction.next,
//                                       keyboardType: TextInputType.number,
//                                       validator: Validators.phone.call,
//                                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                                       decoration: const InputDecoration(
//                                         label: Text("Phone"),
//                                       ),
//                                     ),
//                                     const SizedBox(height: AppDefaults.padding),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: shopName,
//                                       validator: Validators.requiredWithFieldName('Shop Name').call,
//                                       textInputAction: TextInputAction.next,
//                                       decoration: const InputDecoration(
//                                         label: Text("Shop Name"),
//                                       ),
//                                     ),
//                                     const SizedBox(height: AppDefaults.padding),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: TextFormField(
//                                             controller: emailC,
//                                             validator: Validators.email.call,
//                                             textInputAction: TextInputAction.next,
//                                             onChanged: (value) => _validateEmail(),
//                                             decoration: const InputDecoration(
//                                               label: Text("Email"),
//                                             ),
//                                           ),
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.send),
//                                           tooltip: "Send OTP",
//                                           onPressed: _sendOtp,
//                                           color: isEmailValid ? Colors.green : Colors.red,
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: AppDefaults.padding),
//                                     const SizedBox(height: 8),
//                                     TextFormField(
//                                       controller: otpController,
//                                       textInputAction: TextInputAction.next,
//                                       keyboardType: TextInputType.number,
//                                       validator: Validators.requiredWithFieldName("OTP"),
//                                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                                       decoration: const InputDecoration(
//                                         label: Text("OTP"),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         onDelete: () {
//                           // db.deleteNote(item.usrId).whenComplete(() {
//                           //   setState(() {
//                           //     notes = handler.getCompKeyByUsername(widget.userData!.usrUserName);
//                           //   });
//                           // });
//                         },
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CompKeyCard extends StatelessWidget {
//   final String customerName;
//   final String shopName;
//   final String formattedDate;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   const CompKeyCard({
//     Key? key,
//     required this.customerName,
//     required this.shopName,
//     required this.formattedDate,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Customer Name: $customerName", style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text("Shop Name: $shopName"),
//             const SizedBox(height: 8),
//             Text("Created Date: $formattedDate"),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue),
//                   onPressed: onEdit,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: onDelete,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
