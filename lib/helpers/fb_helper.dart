import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/prefs/user_preferences.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FbHelper {
  FbHelper._();
  static final FbHelper fbHelper = FbHelper._();
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  RxString verificationId = ''.obs;
  // Sign Up User
  Future<Map<String, dynamic>> signUpUser(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      res['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          res['error'] = "this service is disabled by admin right now.";
        case "email-already-in-use":
          res['error'] = "this email is already in use.";
        case "weak-password":
          res['error'] = "Password must be greater than 6 letters.";
        default:
          res['error'] = e.code;
      }
    }
    return res;
  }

  // Sign In User
  Future<Map<String, dynamic>> signInUser(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      res['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          res['error'] = "this service is disabled by admin right now.";
        case "email-already-in-use":
          res['error'] = "this email is already in use.";
        case "weak-password":
          res['error'] = "Password must be greater than 6 letters.";
        default:
          res['error'] = e.code;
      }
    }
    return res;
  }

  // // Sign in with No.
  //
  // Future<void> singInWithNumber({required String phoneNumber}) async {
  //   Map<String, dynamic> res = {};
  //   await firebaseAuth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await firebaseAuth.signInWithCredential(credential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       if (e.code == 'invalid-phone-number') {
  //         res['error'] = 'The provided phone number is not valid.';
  //       } else {
  //         res['error'] = '$e';
  //       }
  //       print('verification failed');
  //     },
  //     codeSent: (String verificationId, int? resendToken) async {
  //       this.verificationId.value = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       this.verificationId.value = verificationId;
  //     },
  //   );
  // }
  //
  // Future<bool> verifyOtp({required String otp}) async {
  //   var credentials = await firebaseAuth.signInWithCredential(
  //     PhoneAuthProvider.credential(
  //         verificationId: verificationId.value, smsCode: otp),
  //   );
  //
  //   return credentials.user != null ? true : false;
  // }

  // Sign Out User
  Future<void> signOutUser() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    await UserPreferences.setUserLoggedIn(false);
  }

  // Google Login
  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> res = {};

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      res['user'] = user;
    } catch (e) {
      res['error'] = '$e';
    }
    return res;
  }
}
