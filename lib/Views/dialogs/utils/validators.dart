import 'package:form_field_validator/form_field_validator.dart';

class Validators {
  /// Email Validator
  static final email = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  /// Phone Validator
  static final phone = MultiValidator([
    RequiredValidator(errorText: 'Phone number is required'),
    PatternValidator(r'^[0-9]{10}$', errorText: 'Phone number must be 10 digits long'),
  ]);

  /// Password Validator
  static final password = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    PatternValidator(r'(?=.*?[A-Z])', errorText: 'Passwords must have at least one uppercase letter'),
    PatternValidator(r'(?=.*?[0-9])', errorText: 'Passwords must have at least one number'),
  ]);

  /// Aadhaar Validator
  static final aadhaarNo = MultiValidator([
    RequiredValidator(errorText: 'Aadhaar number is required'),
    PatternValidator(r'^[2-9]{1}[0-9]{11}$', errorText: 'Aadhaar number must be 12 digits and start with a number between 2-9'),
  ]);

  static String? aadhaarValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhar card number is required';
    }
    String cleanedValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanedValue.length != 14) {
      return 'Aadhar card number must be 12 digits';
    }
    return null;
  }
  /// Required Validator with Optional Field Name
  static RequiredValidator requiredWithFieldName(String? fieldName) =>
      RequiredValidator(errorText: '${fieldName ?? 'Field'} is required');

  /// Plain Required Validator
  static final required = RequiredValidator(errorText: 'Field is required');
}
