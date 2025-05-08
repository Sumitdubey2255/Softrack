import 'package:flutter/cupertino.dart';
import 'package:softrack/Views/dialogs/components/comp_KeyPage.dart';
import 'package:softrack/Views/dialogs/home/components/all_apps.dart';
import 'package:softrack/Views/dialogs/home/components/all_distributors.dart';
import 'package:softrack/Views/dialogs/home/components/all_pack.dart';
import 'package:softrack/Views/dialogs/profile/profile_page.dart';
import 'package:softrack/Views/dialogs/search/search_CompKey.dart';
import '../JsonModels/create_comp.dart';
import '../JsonModels/users.dart';
import '../Views/dialogs/cart/checkout_page.dart';
import '../Views/dialogs/drawer/about_us_page.dart';
import '../Views/dialogs/drawer/contact_us_page.dart';
import '../Views/dialogs/drawer/drawer_page.dart';
import '../Views/dialogs/drawer/faq_page.dart';
import '../Views/dialogs/drawer/help_page.dart';
import '../Views/dialogs/drawer/terms_and_conditions_page.dart';
import '../Views/dialogs/entrypoint/entrypoint_ui.dart';
import '../Views/dialogs/forget_password_page.dart';
import '../Views/dialogs/home/bundle_product_details_page.dart';
import '../Views/dialogs/home/comp_cardDetails.dart';
import '../Views/dialogs/home/components/all_recent_packs.dart';
import '../Views/dialogs/home/distributor_details.dart';
import '../Views/dialogs/home/order_successfull_page.dart';
import '../Views/dialogs/intro_login_page.dart';
import '../Views/dialogs/login_or_signup_page.dart';
import '../Views/dialogs/login_page.dart';
import '../Views/dialogs/onboarding/onboarding_page.dart';
import '../Views/dialogs/profile/notification_page.dart';
import '../Views/dialogs/profile/payment_method/add_new_card_page.dart';
import '../Views/dialogs/profile/payment_method/payment_method_page.dart';
import '../Views/dialogs/profile/profile_edit_page.dart';
import '../Views/dialogs/profile/settings/change_password_page.dart';
import '../Views/dialogs/profile/settings/change_phone_number_page.dart';
import '../Views/dialogs/profile/settings/language_settings_page.dart';
import '../Views/dialogs/profile/settings/notifications_settings_page.dart';
import '../Views/dialogs/profile/settings/settings_page.dart';
import '../Views/dialogs/review/review_page.dart';
import '../Views/dialogs/review/submit_review_page.dart';
import '../Views/dialogs/sign_up_page.dart';
import '../Views/splash_screen.dart';
import 'app_routes.dart';
import 'unknown_page.dart';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;
    final args = settings.arguments;

    switch (route) {
      case AppRoutes.introLogin:
        return CupertinoPageRoute(builder: (_) => const IntroLoginPage());

      case AppRoutes.onboarding:
        return CupertinoPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.entryPoint:
        return CupertinoPageRoute(builder: (_) => const EntryPointUI());

      case AppRoutes.login:
        return CupertinoPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return CupertinoPageRoute(builder: (_) => const SignUpPage());

      case AppRoutes.loginOrSignup:
        return CupertinoPageRoute(builder: (_) => const LoginOrSignUpPage());

      case AppRoutes.forgotPassword:
        return CupertinoPageRoute(builder: (_) => const ForgetPasswordPage());

      case AppRoutes.profile:
        return CupertinoPageRoute(builder: (_) => ProfilePage(usrData: args as Users));

      case AppRoutes.profileEdit:
        return CupertinoPageRoute(builder: (_) => ProfileEditPage(usrData: args as Users));

      case AppRoutes.orderSuccessfull:
        return CupertinoPageRoute(builder: (_) => const OrderSuccessfullPage());

      case AppRoutes.changePassword:
        return CupertinoPageRoute(builder: (_) => ChangePasswordPage(usersData: args as Users));

      case AppRoutes.changePhoneNumber:
        return CupertinoPageRoute(builder: (_) => ChangePhoneNumberPage(usersData: args as Users));

      case AppRoutes.drawerPage:
        return CupertinoPageRoute(builder: (_) => DrawerPage());

      case AppRoutes.search:
        return CupertinoPageRoute(builder: (_) => SearchCompkeyPage(userData: args as Users));

      case AppRoutes.searchResult:
        return CupertinoPageRoute(builder: (_) => CompKeypage(userData: args as Users));

      case AppRoutes.review:
        return CupertinoPageRoute(builder: (_) => const ReviewPage());

      case AppRoutes.comp_detailsPage:
        return CupertinoPageRoute(builder: (_) => CompCardDetailsPage(usersData: args as CreateComp));

      case AppRoutes.distributorDetails:
        return CupertinoPageRoute(builder: (_) => distributorDetailsPage(usersData: args as Users));

      case AppRoutes.allApps:
        return CupertinoPageRoute(builder: (_) => AllAppsPage(userData: args as Users));

      case AppRoutes.submitReview:
        return CupertinoPageRoute(builder: (_) => const SubmitReviewPage());

      case AppRoutes.aboutUs:
        return CupertinoPageRoute(builder: (_) => const AboutUsPage());

      case AppRoutes.termsAndConditions:
        return CupertinoPageRoute(
            builder: (_) => const TermsAndConditionsPage());

      case AppRoutes.faq:
        return CupertinoPageRoute(builder: (_) => const FAQPage());

      case AppRoutes.help:
        return CupertinoPageRoute(builder: (_) => const HelpPage());

      case AppRoutes.contactUs:
        return CupertinoPageRoute(builder: (_) => const ContactUsPage());

      case AppRoutes.paymentMethod:
        return CupertinoPageRoute(builder: (_) => const PaymentMethodPage());

      case AppRoutes.paymentCardAdd:
        return CupertinoPageRoute(builder: (_) => const AddNewCardPage());

      case AppRoutes.allPackets:
        return CupertinoPageRoute(builder: (_) => AllPackPage(userData: args as Users));

      case AppRoutes.allDistributor:
        return CupertinoPageRoute(builder: (_) => AllDistributors(userData: args as Users));

      case AppRoutes.allRecentPackets:
        return CupertinoPageRoute(builder: (_) => AllRecentPackPage(userData: args as Users));

      case AppRoutes.checkoutPage:
        return CupertinoPageRoute(builder: (_) => const CheckoutPage());

      // case AppRoutes.cartPage:
      //   return CupertinoPageRoute(builder: (_) => const CartPage());

      case AppRoutes.bundleProduct:
        return CupertinoPageRoute(
            builder: (_) => const BundleProductDetailsPage());

      // case AppRoutes.newAddress:
      //   return CupertinoPageRoute(builder: (_) => const NewAddressPage());
      //
      // case AppRoutes.deliveryAddress:
      //   return CupertinoPageRoute(builder: (_) => const AddressPage());

      case AppRoutes.notifications:
        return CupertinoPageRoute(builder: (_) => NotificationPage(userData: args as Users));

      case AppRoutes.settingsNotifications:
        return CupertinoPageRoute(
            builder: (_) => NotificationSettingsPage(userData: args as Users));

      case AppRoutes.settings:
        return CupertinoPageRoute(builder: (_) => SettingsPage(userData: args as Users));

      case AppRoutes.settingsLanguage:
        return CupertinoPageRoute(builder: (_) => const LanguageSettingsPage());

      case AppRoutes.changePassword:
        return CupertinoPageRoute(builder: (_) => ChangePasswordPage(usersData: args as Users));

      case AppRoutes.changePhoneNumber:
        return CupertinoPageRoute(
            builder: (_) => ChangePhoneNumberPage(usersData: args as Users));

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
