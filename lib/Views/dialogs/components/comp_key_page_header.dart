import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../core/components/network_image.dart';

class compKeyPageHeader extends StatelessWidget {
  const compKeyPageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: const AspectRatio(
                aspectRatio: 1 / 1,
                child: NetworkImageWithLoader(AppImages.roundedLogo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
