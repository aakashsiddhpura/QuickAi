import 'package:flutter/material.dart';

class AppString {
  AppString._();

  static const String appName = "ChatPix Ai";
}

class Validate {
  static const String emailFormat = "email";
  static const String passFormat = "password";
  static const String nameFormat = "nameFormat";

  ///validation text
  static String nameEmptyValidator = "Please enter your name";
  static String nameLengthValidator = "Name must be 3 character long";
  static String emailEmptyValidator = "Please enter your email";
  static String emailValidValidator = "Please enter valid email";
  static String passwordEmptyValidator = "Please enter your password";
  static String cuPasswordEmptyValidator = "Please enter current password";
  static String newPasswordEmptyValidator = "Please enter new password";
  static String cuPasswordEmptyValidator1 = "Please enter confirm password";
  static String passwordValidValidator = "Entered password should be minimum 6 character long";
  static String passValidValidator = "Please enter valid password";
  static String passValidValidator2 = "password must have at least one lowercase, uppercase, digit, and special characters (!\$@%#) and at least 8 characters";
  static String passwordMatchValidator = "Password and confirm password not match";

  ///toast message
  static String loginSuccessValidator = "You have successfully login";
  static String emailNotValidValidator = "Your email is not valid please enter the Correct email";
  static String cPassNotMatchValidator = "The confirm password does not match";
  static String accCreatedValidator = "Your account has been successfully created";
  static String sendVeriCodeValidator = "Successfully ! send verification code to your email";
}
