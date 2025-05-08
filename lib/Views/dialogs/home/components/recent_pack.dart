import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:softrack/constants/app_images.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class RecentPackCard extends StatelessWidget {
  final String customerName;
  final String shopName;
  final String email;
  final String phone;
  final String username;
  final String distributor;
  final String formattedDate;
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecentPackCard({super.key, 
    required this.customerName,
    required this.shopName,
    required this.email,
    required this.phone,
    required this.username,
    required this.distributor,
    required this.formattedDate,
    required this.status,
    required this.onEdit,
    required this.onDelete,
  });

  Future<void> _launchCaller(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print("Could not launch ${launchUri.toString()}");
    }
  }

  Future<void> _launchSMS(String number) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: number,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print("Could not launch ${launchUri.toString()}");
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print('Could not launch $launchUri');
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print('Could not launch $launchUri');
    }
  }

  Future<void> _launchPhoneDialer(String number) async {
    try {
      const platform = MethodChannel('samples.flutter.dev/phoneDialer');
      await platform.invokeMethod('dialPhoneNumber', number);
      print("2nd");
    } on PlatformException catch (e) {
      print("Failed to launch phone dialer: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: const Color(0xFFE8FFE0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status == "active"? Colors.green: Colors.red, // Set the border color to red
                      width: 2.0,       // Set the border width
                    ),
                  ),
                  child: ClipOval(
                    child: Transform.scale(
                      scale: 0.8,
                      child: Image.asset(
                        AppImages.typicalDesktopLogo,
                        fit: BoxFit.cover,
                        width: 65,
                        height: 65,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),
                      Text(
                        'Shop: $shopName',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Icon(Icons.date_range_sharp, color: Colors.teal, size: 14),
                          const SizedBox(width: 5.0),
                          Flexible(
                            child: Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis, // Handle overflow
                            ),
                          ),
                        ],
                      ),
                      // if (username == "typicalDeskAdmin")
                      if (username.split("/")[1] == "administrator")
                        Row(
                          children: [
                            const Tooltip(
                              message: 'Distributor',
                              child: Icon(Icons.person, color: Colors.teal, size: 16),
                            ),
                            const SizedBox(width: 5.0),
                            Text(distributor, style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    BoxIcon(
                      icons: Icons.edit,
                      onPressed: onEdit,
                    ),
                    const SizedBox(height: 4.0),
                    BoxIcon(
                      icons: Icons.delete,
                      onPressed: onDelete,
                    ),
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
                    _launchCaller(phone);
                    _launchPhoneDialer(phone);
                  },
                ),
                IconInfo(
                  icon: Icons.mail,
                  label: 'Email',
                  onPressed: () {
                    _sendEmail(email);
                  },
                ),
                IconInfo(
                  icon: Icons.sms,
                  label: 'SMS',
                  onPressed: ()  {
                    _launchSMS(phone);
                  },
                ),
                IconInfo(
                  icon: Icons.maps_ugc_rounded,
                  label: 'WhatsApp',
                  onPressed: () {
                    _openWhatsApp(phone);
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

class SoftwareCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String url;

  const SoftwareCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  void sharePressed() {
    String message = "Hey, I am using $title app to manage my data from Typical Desktop team. You can find the $title app on our website. Reach out to us on - \"https://typicaldesktop.com/\".";
    Share.share(message);
    // subject used in mail
    // Share.share(message, subject: "Typical Desktop Team");
    // share a file
    // Share.shareFiles(['${directory.path}/image.png'], text: 'logo');
    // multiple files
    // Share.shareFiles(['${directory.path}/image.png', '${directory.path}/image.png']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
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
                      child:
                      Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 65,
                        height: 65,
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[600],
                        ),
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
                                child:
                                Image.asset(
                                  AppImages.typicalDesktopLogo,
                                  fit: BoxFit.cover,
                                  width: 20,
                                  height: 20,
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
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.link),
                      // onPressed: () => launch('https://typicaldesktop.com/'),
                      onPressed: () => launch(url),
                    ),
                    const SizedBox(height: 10.0),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: sharePressed,
                    ),
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

class BoxIcon extends StatelessWidget {
  final IconData icons;
  final VoidCallback onPressed;

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

class IconInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

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

class DistributorCard extends StatelessWidget {
  final String status;
  final String name;
  final String email;
  final int users;
  final int amt;
  final String phone;
  final VoidCallback onDelete;

  const DistributorCard({
    super.key,
    required this.status,
    required this.name,
    required this.email,
    required this.users,
    required this.amt,
    required this.phone,
    required this.onDelete,
  });

  Future<void> _launchCaller(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print("Could not launch ${launchUri.toString()}");
    }
  }

  Future<void> _launchSMS(String number) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: number,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print("Could not launch ${launchUri.toString()}");
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print('Could not launch $launchUri');
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      print('Could not launch $launchUri');
    }
  }

  Future<void> _launchPhoneDialer(String number) async {
    try {
      const platform = MethodChannel('samples.flutter.dev/phoneDialer');
      await platform.invokeMethod('dialPhoneNumber', number);
      print("2nd");
    } on PlatformException catch (e) {
      print("Failed to launch phone dialer: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      color: const Color(0xFFFFFCEC),
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
                      color: status.split("/")[0] == "0" ? Colors.red: Colors.green, // Set the border color to red
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
                          Text('$amt', style: const TextStyle(fontSize: 12,)),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    BoxIcon(icons: Icons.delete, onPressed: onDelete),
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
                    _launchCaller(phone);
                    _launchPhoneDialer(phone);
                  },
                ),
                IconInfo(
                  icon: Icons.mail,
                  label: 'Email',
                  onPressed: () {
                    _sendEmail(email);
                  },
                ),
                IconInfo(
                  icon: Icons.sms,
                  label: 'SMS',
                  onPressed: ()  {
                    _launchSMS(phone);
                  },
                ),
                IconInfo(
                  icon: Icons.maps_ugc_rounded,
                  label: 'WhatsApp',
                  onPressed: () {
                    _openWhatsApp(phone);
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

