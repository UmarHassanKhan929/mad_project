import 'package:firebase_chat/common/entities/user.dart';
import 'package:firebase_chat/common/routes/names.dart';
import 'package:firebase_chat/pages/signin/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/store/user.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'openid',
  ],
);

class SignInController extends GetxController {
  final state = SignInState();
  SignInController();

  final db = FirebaseFirestore.instance;

  Future<void> handleSignIn() async {
    try {
      var user = await _googleSignIn.signIn();
      if (user != null) {
        String displayName = user.displayName ?? user.email;
        String email = user.email;
        String id = user.id;
        String photoUrl = user.photoUrl ?? '';
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();

        userProfile.email = email;
        userProfile.displayName = displayName;
        userProfile.accessToken = id;
        userProfile.photoUrl = photoUrl;

        UserStore.to.saveProfile(userProfile);
      }
    } catch (e) {}
  }
}
