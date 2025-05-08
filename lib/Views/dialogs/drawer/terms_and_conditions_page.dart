import 'package:flutter/material.dart';
import '../../../core/components/app_back_button.dart';
import 'components/faq_item.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Terms And Conditions'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            TitleAndParagraph(
                isTitleHeadline: false,
                title: 'General Site Usage Last Revised\nDecember 21-08-2024.',
                paragraph:
                '''Welcome to www.typicaldesktop.com. By accessing or using our website, you agree to comply with and be bound by these Terms and Conditions. Please read them carefully. If you do not agree to these terms, you should not use our website.'''),
            TitleAndParagraph(
                isTitleHeadline: false,
                title: '1. Agreement',
                paragraph:
                '''By using this website, you agree to these Terms and Conditions and our Privacy Policy. This agreement constitutes the entire agreement between you and us regarding the use of the website and supersedes all prior agreements or understandings.'''),
            TitleAndParagraph(
                isTitleHeadline: false,
                title: '2. Account',
                paragraph:
                '''To access certain features of our software/app, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.'''),
            TitleAndParagraph(
                isTitleHeadline: false,
                title: '3. Relationship with Software',
                paragraph:
                '''Your use of any software or services provided by our Typical Desktop is governed by these terms and any additional agreements that may accompany the software or services. You agree not to modify, reverse engineer, or attempt to derive the source code of any software provided by us, except as permitted by law.'''),
            TitleAndParagraph(
                isTitleHeadline: false,
                title: '4. Limitation of Liability',
                paragraph:
                '''In no event shall we be liable for any damages arising from the use of this website or the inability to use this website. This includes, but is not limited to, direct, indirect, incidental, punitive, and consequential damages.'''),
            TitleAndParagraph(
                isTitleHeadline: false,
                title: '5. Modifications',
                paragraph:
                '''We reserve the right to modify these Terms and Conditions at any time. Any changes will be effective immediately upon posting on this website. Your continued use of the website after any such changes constitutes your acceptance of the new terms.'''),
          ],
        ),
      ),
    );
  }
}
