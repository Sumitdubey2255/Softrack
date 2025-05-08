import 'package:flutter/material.dart';

import 'empty_save_page.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class SavePage extends StatelessWidget {
  const SavePage({
    super.key,
    this.isHomePage = false,
  });

  final bool isHomePage;

  @override
  Widget build(BuildContext context) {
    return const EmptySavePage();
  }
}
