// otp_service.dart
import 'dart:math';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class OTPService {
  int? _otp;

  int generateOTP() {
    final random = Random();
    _otp = 1000 + random.nextInt(9000);
    return _otp!;
  }

  bool verifyOTP(String userOtp) {
    return _otp == int.tryParse(userOtp);
  }
}
