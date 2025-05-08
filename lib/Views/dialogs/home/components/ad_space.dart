import 'package:flutter/material.dart';
import 'package:softrack/constants/app_images.dart';

import '../../../../constants/app_defaults.dart';

class AdSpace extends StatelessWidget {
  const AdSpace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
      child: Card(
        elevation: 10.0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ClipOval(
            child: Transform.scale(
              scale: 0.9,
              child: Image.asset(
                // 'images/softrack_banner.png',
                AppImages.softrackLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
