import 'package:flutter/material.dart';

import '../../../constants/app_defaults.dart';
import '../../../core/components/app_back_button.dart';
import '../../../routes/app_routes.dart';
import 'components/coupon_code_field.dart';
import 'components/items_totals_price.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    this.isHomePage = false,
  });

  final bool isHomePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isHomePage
          ? null
          : AppBar(
              leading: const AppBackButton(),
              title: const Text('Cart Page'),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SingleCartItemTile(),
              // const SingleCartItemTile(),
              // const SingleCartItemTile(),
              const CouponCodeField(),
              const ItemTotalsAndPrice(),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.checkoutPage);
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
