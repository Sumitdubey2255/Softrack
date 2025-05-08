import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class DontHaveAccountRow extends StatelessWidget {
  const DontHaveAccountRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t Have Account?'),
        TextButton(
          // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpPage())),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
