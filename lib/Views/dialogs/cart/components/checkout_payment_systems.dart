import 'package:flutter/material.dart';

import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_icons.dart';
import 'checkout_payment_card_tile.dart';

class PaymentSystem extends StatelessWidget {
  const PaymentSystem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: AppDefaults.padding / 2,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Payment System',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black),
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              PaymentCardTile(
                label: 'Master Card',
                icon: AppIcons.masterCard,
                onTap: () {},
                isActive: true,
              ),
              PaymentCardTile(
                label: 'Paypal',
                icon: AppIcons.paypal,
                onTap: () {},
                isActive: false,
              ),
              PaymentCardTile(
                label: 'Cash On Delivery',
                icon: AppIcons.cashOnDelivery,
                onTap: () {},
                isActive: false,
              ),
            ],
          ),
        )
      ],
    );
  }
}
