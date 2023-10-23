import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_app/res/strings_utils.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:fl_app/utils/navigation_utils/routes.dart';
import 'package:fl_app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';
import '../widget/toast_helper.dart';
import 'analytics_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final box = GetStorage();

  // User data
  var user = UserModel().obs;

  // login var
  TextEditingController loginEmailC = TextEditingController();
  TextEditingController loginPasswordC = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  RxBool submitted = false.obs;

  // registration var
  TextEditingController regEmailC = TextEditingController();
  TextEditingController regDisplayNameC = TextEditingController();
  TextEditingController regPasswordC = TextEditingController();
  final regFormKey = GlobalKey<FormState>();
  RxBool regSubmitted = false.obs;

  // forgot password
  TextEditingController forgotPasswordC = TextEditingController();
  final forgotFormKey = GlobalKey<FormState>();

  // edit profile
  TextEditingController editNameC = TextEditingController();
  final editFormKey = GlobalKey<FormState>();

  clearVariable() {
    submitted = false.obs;
    loginEmailC.clear();
    loginPasswordC.clear();
    regEmailC.clear();
    regDisplayNameC.clear();
    regPasswordC.clear();
    forgotPasswordC.clear();
    editNameC.clear();
    regSubmitted = false.obs;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize user data from GetStorage when the app starts
    user.value = UserModel.fromJson(box.read('userData') ?? {});
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    Loader.sw();
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      user.value = UserModel(
        uid: authResult.user!.uid,
        displayName: authResult.user!.displayName ?? "User",
        email: authResult.user!.email ?? "",
      );
      saveInFireStore();
      box.write('userData', user.value.toJson());
      AppToast.successMessage(Validate.loginSuccessValidator);
      Navigation.replaceAll(Routes.kMainScreen);
      clearVariable();
      Loader.hd();
      return user.value;
    } catch (e) {
      Loader.hd();
      print("Google sign-in error: ${e.toString()}");
      final message = mapFirebaseErrorToMessage(e as FirebaseAuthException);
      AppToast.errorMessage(message);

      return null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    Loader.sw();
    try {
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userDoc = await firestore.collection('users').doc(authResult.user!.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      user.value = UserModel(
        uid: authResult.user!.uid,
        displayName: userData["displayName"] ?? "",
        email: authResult.user!.email ?? "",
      );
      box.write('userData', user.value.toJson());

      AppToast.successMessage(Validate.loginSuccessValidator);

      Navigation.replaceAll(Routes.kMainScreen);
      clearVariable();
      Loader.hd();
      return user.value;
    } catch (e) {
      Loader.hd();

      print("Email sign-in error: ${e.toString()}");
      final message = mapFirebaseErrorToMessage(e as FirebaseAuthException);
      AppToast.errorMessage(message);
      return null;
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword(String email, String password, String displayName) async {
    Loader.sw();
    try {
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user != null) {
        user.value = UserModel(
          uid: authResult.user!.uid,
          displayName: displayName ?? "",
          email: authResult.user!.email ?? "",
        );
        box.write('userData', user.value.toJson());
        await addUserDataToFireStore(authResult.user!.uid, displayName, email);
        AppToast.successMessage(Validate.accCreatedValidator);

        Navigation.replaceAll(Routes.kMainScreen);
        clearVariable();
        Loader.hd();
        return user.value;
      }
      Loader.hd();
      return null;
    } catch (e) {
      Loader.hd();
      print("Email registration error: ${e.toString()}");
      final message = mapFirebaseErrorToMessage(e as FirebaseAuthException);
      AppToast.toastMessage(message);
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    Loader.sw();
    // await FirebaseAuth.instance.setLanguageCode("en");
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      Loader.hd();

      print("Email sent");
      AppToast.successMessage(Validate.sendVeriCodeValidator);

      Navigation.pop();
      clearVariable();
    });
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    try {
      final User? user = _auth.currentUser;
      await user?.updatePassword(newPassword);
    } catch (e) {
      print("Password change error: ${e.toString()}");
      final message = mapFirebaseErrorToMessage(e as FirebaseAuthException);
      AppToast.errorMessage(message);
    }
  }

  // Sign out
  Future<void> signOut() async {
    Loader.sw();
    try {
      await _auth.signOut();
      box.remove('userData');
      user.value = UserModel();
      Loader.hd();
      clearVariable();
      AnalyticsService().logEvent("User Logout", null);

      Navigation.replaceAll(Routes.kLoginScreen);
    } catch (e) {
      Loader.hd();

      print("Sign out error: ${e.toString()}");
      final message = mapFirebaseErrorToMessage(e as FirebaseAuthException);
      AppToast.errorMessage(message);
    }
  }

  // delete account
  Future<void> deleteAccount() async {
    Loader.sw();

    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
        await firestore.collection('users').doc(user.value.uid).delete();
        box.remove('userData');
        user.value = UserModel();
        Loader.hd();
        clearVariable();
        AnalyticsService().logEvent("User DeleteAccount", null);

        Navigation.replaceAll(Routes.kLoginScreen);
      }
    } catch (e) {
      Loader.hd();
      print("Delete account error: ${e.toString()}");
      final message = mapFirebaseErrorToMessage(e as FirebaseAuthException);
      AppToast.errorMessage(message);
    }
  }

  // save in fire store database
  Future<void> saveInFireStore() async {
    final userDoc = await firestore.collection('users').doc(user.value.uid).get();
    if (!userDoc.exists) {
      // New user, save data to Firestore
      await firestore.collection('users').doc(user.value.uid).set({
        'displayName': user.value.displayName,
        'email': user.value.email,
      });
    } else {
      // Existing user, update data in Firestore
      await firestore.collection('users').doc(user.value.uid).update({
        'displayName': user.value.displayName,
        'email': user.value.email,
      });
    }
  }

  Future<void> updateProfile() async {
    Loader.sw();
    user.value = UserModel(
      uid: user.value.uid,
      displayName: editNameC.text,
      email: user.value.email,
    );
    box.write('userData', user.value.toJson());

    await firestore.collection('users').doc(user.value.uid).update({
      'displayName': user.value.displayName,
      'email': user.value.email,
    }).then((value) {
      Loader.hd();

      Get.back();
      AppToast.successMessage(Validate.updateProfile);
    });
  }

  Future<void> addUserDataToFireStore(String uid, String displayName, String email) async {
    try {
      await firestore.collection('users').doc(uid).set({
        'displayName': displayName,
        'email': email,
      });
    } catch (e) {
      print("Error adding user data to Firestore: ${e.toString()}");
      final message = mapFirebaseErrorToMessage(e as FirebaseAuthException);
      AppToast.errorMessage(message);
    }
  }

  String mapFirebaseErrorToMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return 'User not found. Please check your email or register.';
      case 'wrong-password':
        return 'Wrong password. Please try again.';
      case 'email-already-in-use':
        return 'Email is already in use. Please use a different email or sign in.';
      case 'invalid-email':
        return 'Invalid email format. Please check your email address.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'User not found. Please check your email or register.';
      default:
        return 'Authentication failed. Please try again later.';
    }
  }
}
