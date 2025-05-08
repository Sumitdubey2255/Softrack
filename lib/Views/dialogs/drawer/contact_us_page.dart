
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_icons.dart';
import '../../../core/components/app_back_button.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Contact Us'),
      ),
      backgroundColor: AppColors.cardColor,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDefaults.padding),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDefaults.padding * 2),

              /// Number
              Row(
                children: [
                  SvgPicture.asset(AppIcons.contactPhone),
                  const SizedBox(width: AppDefaults.padding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+91 7718039194',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: AppDefaults.padding / 2),
                      Text(
                        '+91 8108505205',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppDefaults.padding),
              Row(
                children: [
                  SvgPicture.asset(AppIcons.contactEmail),
                  const SizedBox(width: AppDefaults.padding),
                  Text(
                    'typicaldesktop@gmail.com',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDefaults.padding),
              Row(
                children: [
                  SvgPicture.asset(AppIcons.contactMap),
                  const SizedBox(width: AppDefaults.padding),
                  Expanded(
                    child: Text(
                      'Shop No. 1, Typical Desktop,\nDiva-Agasan Rd, opp.\nSadhguru Shopping Centre, near\nSiddhivinayak Gate, Sidhivinyak\nNagar, Diva, Thane, Maharashtra\n400612',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDefaults.padding),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const AspectRatio(
                  aspectRatio: 3 / 2,
                  child: HtmlWidget('''<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1816.8209505313343!2d73.04286532773449!3d19.184290481756562!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3be7bfb1beaa8489%3A0xdf5eff331d9d65ae!2sTypical%20Desktop!5e0!3m2!1sen!2sin!4v1722681062309!5m2!1sen!2sin" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>'''),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
