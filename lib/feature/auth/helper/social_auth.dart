import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

mixin SocialAuth {
  late final GoogleSignIn _googleSignIn;

  void iniSocialAuth() {
    _googleSignIn = GoogleSignIn.standard();
  }



  Future<GoogleSignInAccount?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      return googleUser;
    } catch (e) {
      return null;
    }
  }

  Future<AuthorizationCredentialAppleID?> loginWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      return credential;
    } catch (e) {
      return null;
    }
  }
}
