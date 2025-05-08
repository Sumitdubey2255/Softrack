import 'package:flutter/material.dart';
import 'package:softrack/JsonModels/users.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_images.dart';

class ProfileHeader extends StatelessWidget {
  final Users? usrData;
  const ProfileHeader({
    super.key,
    required this.usrData,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // NetworkImageWithLoader(AppImages.profilePageBg),
        Image.asset(AppImages.profilePageBg),
        // Image.asset('assets/images/profile_page_background.png'),
        Column(
          children: [
            AppBar(
              title: const Text(''),
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false, // Remove the back button
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            _UserData(usrData: usrData),
            // const ProfileHeaderOptions(),
          ],
        ),
      ],
    );
  }
}

class _UserData extends StatelessWidget {
  final Users? usrData;
  const _UserData({
    required this.usrData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          const SizedBox(width: AppDefaults.padding),
          SizedBox(
            width: 100,
            height: 100,
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(
                  AppImages.noUserLogo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDefaults.padding),
          Expanded( // This ensures the text won't overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    usrData?.usrName ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    usrData?.usrEmail ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
