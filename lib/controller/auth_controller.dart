import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_app/utils/navigation_utils/navigation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final box = GetStorage();

  // User data
  var user = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize user data from GetStorage when the app starts
    user.value = UserModel.fromJson(box.read('userData') ?? {});
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
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
      box.write('userData', user.value.toJson());
      return user.value;
    } catch (e) {
      print("Google sign-in error: ${e.toString()}");
      return null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = UserModel(
        uid: authResult.user!.uid,
        displayName: authResult.user!.displayName ?? "",
        email: authResult.user!.email ?? "User",
      );
      box.write('userData', user.value.toJson());
      return user.value;
    } catch (e) {
      print("Email sign-in error: ${e.toString()}");
      return null;
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = UserModel(
        uid: authResult.user!.uid,
        displayName: authResult.user!.displayName ?? "User",
        email: authResult.user!.email ?? "",
      );
      box.write('userData', user.value.toJson());
      return user.value;
    } catch (e) {
      print("Email registration error: ${e.toString()}");
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Password reset email error: ${e.toString()}");
    }
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    try {
      final User? user = _auth.currentUser;
      await user?.updatePassword(newPassword);
    } catch (e) {
      print("Password change error: ${e.toString()}");
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      box.remove('userData');
      user.value = UserModel();
    } catch (e) {
      print("Sign out error: ${e.toString()}");
    }
  }

  // delete account
  Future<void> deleteAccount() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
        box.remove('userData');
        user.value = UserModel();
      }
    } catch (e) {
      print("Delete account error: ${e.toString()}");
    }
  }
}
