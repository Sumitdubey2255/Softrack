import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:softrack/JsonModels/size_options_model.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class SizeOptionItem extends StatelessWidget {
  final int index;
  final SizeOption sizeOption;
  final bool selected;
  final String contactDetail; // New parameter

  const SizeOptionItem({
    super.key,
    required this.index,
    required this.sizeOption,
    required this.selected,
    required this.contactDetail, // New parameter
  });

  static const List<IconData> icons = [
    FontAwesomeIcons.phone,
    FontAwesomeIcons.sms,
    FontAwesomeIcons.mailBulk,
    FontAwesomeIcons.whatsapp,
  ];

  void _launchURL(int index) async {
    String url;
    switch (index) {
      case 0:
        url = 'tel:$contactDetail'; // Use contactDetail for phone number
        break;
      case 1:
        url = 'sms:$contactDetail'; // Use contactDetail for SMS
        break;
      case 2:
        url = 'mailto:$contactDetail'; // Use contactDetail for email
        break;
      case 3:
        url = 'https://wa.me/$contactDetail'; // Use contactDetail for WhatsApp
        break;
      default:
        url = '';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0078A6) : const Color(0xFF3A825F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icons[index % icons.length], // Use module to prevent out of bounds
                color: selected ? Colors.white : const Color(0xFF0078A6),
                size: 25 + (index * 1),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            sizeOption.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.9,
            ),
          ),
        ],
      ),
    );
  }
}
