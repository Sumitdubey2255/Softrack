import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:softrack/Authtentication/otp_service.dart';
import 'package:softrack/Views/dialogs/utils/validators.dart';
import 'package:softrack/constants/app_colors.dart';
import 'package:softrack/constants/app_defaults.dart';
import 'package:softrack/constants/app_icons.dart';
import 'package:softrack/constants/app_images.dart';
import 'package:softrack/supabase/supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../../JsonModels/create_comp.dart';
import '../../../JsonModels/users.dart';
import '../verifyAndInsert_page.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class ShopCompanyKeyForm extends StatefulWidget {
  final Users? userData;
  const ShopCompanyKeyForm({super.key, this.userData});
  // const ShopCompanyKeyForm({super.key});

  @override
  _ShopCompanyKeyFormState createState() => _ShopCompanyKeyFormState();
}

final db = SupaBaseDatabaseHelper();
const uuid = Uuid();

class _ShopCompanyKeyFormState extends State<ShopCompanyKeyForm> {
  String? _selectedSoftware;
  String? _selectedServiceType;
  String? _selectedServiceDays;
  String? _selectedPaymentType;
  String? _selectedAccountsAllowed;

  final _key = GlobalKey<FormState>();

  final name = TextEditingController();
  final emailC = TextEditingController();
  final phone = TextEditingController();
  final shopName = TextEditingController();
  final compKey = TextEditingController();
  final aadhar = TextEditingController();
  final amount = TextEditingController();
  final daysCount = TextEditingController();
  final otpController = TextEditingController();
  final verified = TextEditingController();

  final OTPService _otpService = OTPService(); // Instantiate the OTP service

  String? generatedOtp; // Store the generated OTP
  bool isOtpVerified = false; // Track OTP verification status
  bool isEmailValid = false; // Track email validity
  bool isOtpValid = false; // Track OTP validity
  bool _isLoading = false;

  final FocusNode _aadharFocusNode = FocusNode(); // FocusNode for Aadhar field

  String? aadharValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhar card number is required';
    }
    String cleanedValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanedValue.length != 14) {
      return 'Aadhar card number must be 12 digits';
    }
    return null;
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
          'to_email':email,
          'subject': subject,
          'message': message,
          'sender_email': "typicaldesktop@gmail.com",
        },
      }),
    );

    if (response.statusCode == 200) {
      // print('Email sent successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );

      String formattedDaysCount = daysCount.text.replaceAll(' Days', '/active/0');
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyAndInsertPage(
                otpService: _otpService,
                userData: widget.userData,
                isEmailValid: isEmailValid,
                compData: CreateComp(
                    usrUserName: widget.userData!.usrUserName,
                    usrName: name.text,
                    usrShopName: shopName.text,
                    usrPhone: phone.text,
                    usrEmail: emailC.text,
                    usrCompKey: compKey.text,
                    usrAppName: _selectedSoftware.toString(),
                    usrServiceType: _selectedServiceType.toString(),
                    usrUsersCount: _selectedAccountsAllowed.toString(),
                    usrPayType: _selectedPaymentType.toString(),
                    usrAadharNo: aadhar.text,
                    usrPaidAmt: amount.text,
                    usrNoOfDays: formattedDaysCount, // daysCount.text,
                    usrDeploymentType: "Offline",
                )
              ),
            ),
          );
        }
      });
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

  String? dropdownValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a value';
    }
    return null;
  }

  String _generateCompanyKey(String shopName) {
    const length = 10;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final buffer = StringBuffer();
    final shopNameChars = shopName.codeUnits.map((e) => chars[e % chars.length]).take(5).toList();
    buffer.writeAll(shopNameChars);

    while (buffer.length < length) {
      buffer.write(chars[random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  void _handleServiceTypeChange(String? value) {
    setState(() {
      _selectedServiceType = value;
      if (value == 'Free Trial') {
        _selectedPaymentType = 'None';
        _selectedAccountsAllowed = '1 admin 0 user';
        amount.text = "₹0.0";
        _selectedServiceDays = '1 month';
        daysCount.text = "30 Days";
        // Use WidgetsBinding to ensure the focus is set after the build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_aadharFocusNode);
        });
      }
    });
  }

  void _handleServiceDaysChange(String? value) {
    setState(() {
      _selectedServiceDays = value;
      switch(value){
        case '1 month':
          daysCount.text = "30 Days";
          break;
        case '2 months':
          daysCount.text = "60 Days";
          break;
        case '3 months':
          daysCount.text = "90 Days";
          break;
        case '6 months':
          daysCount.text = "180 Days";
          break;
        case '8 months':
          daysCount.text = "240 Days";
          break;
        case '1 year':
          daysCount.text = "360 Days";
          break;
        default:
          daysCount.text = "30 Days";
      }
    });
  }

  void _handleButtonPress() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _isLoading = true;  // Show loading
      });
      await Future.delayed(const Duration(seconds: 2));
      compKey.text = _generateCompanyKey(shopName.text);
      _sendOtp();
      setState(() {
        _isLoading = false;  // Hide loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      appBar: AppBar(
        title: const Text('Create Company Key'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppDefaults.boxShadow,
                borderRadius: AppDefaults.borderRadius,
              ),
              child: Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 5.4,
                                    child: Image.asset(
                                      AppImages.roundedLogo,
                                      width: 180,
                                      height: 180,
                                    ),
                                  ),
                                  _buildTextField(
                                    controller: name,
                                    validator: Validators.requiredWithFieldName('Name').call,
                                    label: "Name",
                                    hintText: "Enter Name",
                                  ),
                                  _buildTextField(
                                    controller: shopName,
                                    label: "Shop",
                                    validator: Validators.requiredWithFieldName('Shop Name').call,
                                    hintText: "Enter Shop Name",
                                  ),
                                  _buildTextField(
                                    controller: phone,
                                    label: "Phone",
                                    validator: Validators.phone.call,
                                    hintText: "Enter Phone no.",
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: emailC,
                                          validator: Validators.email.call,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (value) => _validateEmail(),
                                          decoration: const InputDecoration(
                                            labelText: "Email",
                                            hintText: "Enter Email",
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.check),
                                        onPressed: _sendOtp,
                                        color: isEmailValid ? Colors.green : Colors.red,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppDefaults.padding),
                                  _buildDropdown(
                                    label: "Select Software",
                                    value: _selectedSoftware,
                                    items: ['KeepVeda', 'DayBook'],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSoftware = value;
                                      });
                                    },
                                    validator: dropdownValidator,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child:
                                        _buildDropdown(
                                          label: "Service Type",
                                          value: _selectedServiceType,
                                          items: ['Free Trial', 'Subscription'],
                                          onChanged: _handleServiceTypeChange,
                                          validator: dropdownValidator,
                                        ),
                                      // ),
                                      // const SizedBox(width: AppDefaults.padding),
                                      // Expanded(
                                      //   child:
                                        _buildDropdown(
                                          label: "Plan Period",
                                          value: _selectedServiceDays,
                                          items: ['Default','1 month', '2 months', '3 months', '6 months', '8 months', '1 year'],
                                          onChanged: _handleServiceDaysChange,
                                          validator: dropdownValidator,
                                        ),
                                    //   ),
                                    // ],
                                  // ),
                                  _buildDropdown(
                                    label: "Accounts Allowed",
                                    value: _selectedAccountsAllowed,
                                    items: ['1 admin 0 user', '1 admin 1 user', '1 admin 2 user'],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAccountsAllowed = value;
                                      });
                                    },
                                    validator: dropdownValidator,
                                  ),
                                  _buildDropdown(
                                    label: "Payment",
                                    value: _selectedPaymentType,
                                    items: ['None', 'Cash', 'Net-Banking', 'Credit'],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPaymentType = value;
                                      });
                                    },
                                    validator: dropdownValidator,
                                  ),
                                  _buildAadhaarTextField(
                                      controller: aadhar,
                                      label: "Aadhar card number",
                                      validator: aadharValidator,
                                      hintText: "Enter Aadhar card number",
                                      focusNode: _aadharFocusNode,
                                      inputFormatters: [AadharInputFormatter()],
                                      keyboardType: TextInputType.number,
                                      maxLength: 14,
                                    ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          controller: amount,
                                          label: "Amount",
                                          validator: Validators.requiredWithFieldName('Amount').call,
                                          hintText: "₹0.0",
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      const SizedBox(width: AppDefaults.padding),
                                      Expanded(
                                        child: _buildTextField(
                                          controller: daysCount,
                                          label: "No.of Days",
                                          validator: Validators.requiredWithFieldName('Days').call,
                                          hintText: "0 Days",
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppDefaults.padding),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: AppDefaults.padding * 2),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Proceed',
                                          style: textStyle,
                                        ),
                                        const Spacer(),
                                        _isLoading
                                            ? const CircularProgressIndicator()  // Show loading indicator when _isLoading is true
                                            : ElevatedButton(
                                          onPressed: _handleButtonPress,  // Handle button press
                                          style: ElevatedButton.styleFrom(elevation: 1),
                                          child: SvgPicture.asset(
                                            AppIcons.arrowForward,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required String? Function(String?)? validator,
    TextEditingController? controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          // border: OutlineInputBorder(),
          labelText: label,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildAadhaarTextField({
    required String label,
    required String hintText,
    required String? Function(String?)? validator,
    TextEditingController? controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, int? maxLength}) {
          final int actualLength = controller?.text.replaceAll(' ', '').length ?? 0; // Calculate length without spaces
          return Text('$actualLength/12'); // Display counter as 0/16 to 16/16
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          // border: OutlineInputBorder(),
          labelText: label,
        ),
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class AadharInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters

    if (text.length > 12) {
      text = text.substring(0, 12); // Limit to 16 digits
    }

    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
