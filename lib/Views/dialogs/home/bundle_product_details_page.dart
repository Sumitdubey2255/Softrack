import 'package:flutter/material.dart';
import '../../../constants/app_defaults.dart';
import '../../../core/components/app_back_button.dart';
import '../../../core/components/buy_now_row_button.dart';
import '../../../core/components/price_and_quantity.dart';
import '../../../core/components/review_row_button.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class BundleProductDetailsPage extends StatelessWidget {
  const BundleProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* <---- Product Data -----> */
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bundle Pack',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const PriceAndQuantityRow(
                    currentPrice: 20,
                    orginalPrice: 30,
                    quantity: 2,
                  ),
                  const SizedBox(height: AppDefaults.padding / 2),
                  const ReviewRowButton(totalStars: 5),
                  const Divider(thickness: 0.1),
                  BuyNowRow(
                    onBuyButtonTap: () {},
                    onCartButtonTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
