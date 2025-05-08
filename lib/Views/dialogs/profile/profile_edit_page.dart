import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:softrack/JsonModels/users.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_icons.dart';
import '../../../core/components/app_back_button.dart';
import '../../../supabase/supabase.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class ProfileEditPage extends StatefulWidget {
  final Users? usrData;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _userNameController;
  TextEditingController _passwordController;

  ProfileEditPage({super.key, required this.usrData})
      : _nameController = TextEditingController(text: usrData!.usrName),
        _emailController = TextEditingController(text: usrData.usrEmail),
        _phoneController = TextEditingController(text: usrData.usrPhone),
        _userNameController = TextEditingController(text: usrData.usrUserName),
        _passwordController = TextEditingController(text: usrData.usrPassword);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  bool isPasswordShown = false;
  final db = SupaBaseDatabaseHelper();
  final _key = GlobalKey<FormState>();
  // final uuid = const Uuid();

  void onPassShowClicked() {
    setState(() {
      isPasswordShown = !isPasswordShown;
    });
  }

  Future<void> _refreshData() async {
    // Reload data here if needed
    widget._nameController = TextEditingController(text: widget.usrData!.usrName);
    widget._emailController = TextEditingController(text: widget.usrData!.usrEmail);
    widget._phoneController = TextEditingController(text: widget.usrData!.usrPhone);
    widget._userNameController = TextEditingController(text: widget.usrData!.usrUserName);
    widget._passwordController = TextEditingController(text: widget.usrData!.usrPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(AppDefaults.padding),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding * 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Name"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: widget._nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDefaults.padding),
                const Text("Email"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: widget._emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDefaults.padding),
                const Text("Phone"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: widget._phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDefaults.padding),
                const Text("Username"),
                const SizedBox(height: 8),
                TextFormField(
                  enabled: false,
                  controller: widget._userNameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDefaults.padding),
                const Text("Password"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: widget._passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        int result = await db.updateUser(
                          widget._nameController.text,
                          widget._emailController.text,
                          widget._passwordController.text,
                          widget._phoneController.text,
                          widget._userNameController.text,
                        );
                        if (result == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data updated. You need to login again.')),
                          );
                          _refreshData(); // Call your refresh method if needed
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Update Failed')),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}