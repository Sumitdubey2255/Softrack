import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already Have Account?'),
        TextButton(
          // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage())),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
          child: const Text('Log In'),
        ),
      ],
    );
  }
}
