import 'package:flutter/material.dart';

import '../../../constants/app_defaults.dart';
import '../../../core/components/app_back_button.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text('''At Typical Desktop, we specialize in creating a wide range of software solutions, apps, websites, and web applications tailored to meet the unique needs of our clients. '''),
            const Text('''\nOur goal is to enhance business operations, ensuring smooth functionality and seamless data management, both online and offline. One of our flagship products, Softrack, is designed to efficiently manage and monitor onboard software systems, offering users unparalleled control and oversight.'''),
            const Text('''\nWe've also integrated a push notification feature, enabling targeted communication with users about their services and other crucial information.'''),
            const Text.rich(
              TextSpan(
                text: '\nAs a dedicated team, we at ',
                children: <TextSpan>[
                  TextSpan(
                    text: 'Typical Desktop',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' are committed to providing comprehensive solutions that empower businesses to thrive in today\'s digital landscape.',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
