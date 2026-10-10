import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  GoogleSignIn get _googleSignIn => GoogleSignIn();
  // ==========================================
  // 1. SIGN IN (EMAIL & PASSWORD)
  // ==========================================
  Future<AuthResult> login(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        return AuthResult(
          success: true,
          message: 'ចូលប្រព័ន្ធជោគជ័យ!',
          user: UserModel.fromFirebaseUser(credential.user!),
        );
      }

      return AuthResult(
        success: false,
        message: 'មិនអាចទាញយកទិន្នន័យអ្នកប្រើប្រាស់បានទេ!',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        message: _handleAuthException(e.code),
      );
    } on FirebaseException catch (e) {
      return AuthResult(
        success: false,
        message: _handleAuthException(e.code),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'មានបញ្ហាកើតឡើង: ${e.toString()}',
      );
    }
  }

  // ==========================================
  // 2. SIGN UP (EMAIL & PASSWORD)
  // ==========================================
  Future<AuthResult> register(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        return AuthResult(
          success: true,
          message: 'ចុះឈ្មោះជោគជ័យ!',
          user: UserModel.fromFirebaseUser(credential.user!),
        );
      }

      return AuthResult(
        success: false,
        message: 'ការចុះឈ្មោះបរាជ័យ!',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        message: _handleAuthException(e.code),
      );
    } on FirebaseException catch (e) {
      return AuthResult(
        success: false,
        message: _handleAuthException(e.code),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'មានបញ្ហាកើតឡើង: ${e.toString()}',
      );
    }
  }

  // ==========================================
  // 3. GOOGLE SIGN-IN
  // ==========================================
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Step A: បើក Popup ជ្រើសរើស Google Account
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult(
          success: false,
          message: 'ការចូលប្រព័ន្ធត្រូវបានបោះបង់!',
        );
      }

      // Step B: ទាញយក Authentication details ពី Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Step C: បង្កើត Credential សម្រាប់ Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step D: Sign in ទៅកាន់ Firebase
      final UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return AuthResult(
          success: true,
          message: 'ចូលប្រព័ន្ធជាមួយ Google ជោគជ័យ!',
          user: UserModel.fromFirebaseUser(userCredential.user!),
        );
      }

      return AuthResult(
        success: false,
        message: 'មិនអាចទាញយកទិន្នន័យពី Google បានទេ!',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        message: _handleAuthException(e.code),
      );
    } on FirebaseException catch (e) {
      return AuthResult(
        success: false,
        message: _handleAuthException(e.code),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'មានបញ្ហាក្នុងការ Sign in ជាមួយ Google: ${e.toString()}',
      );
    }
  }

  // ==========================================
  // 4. LOGOUT
  // ==========================================
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _firebaseAuth.signOut();
  }

  // ==========================================
  // 5. FIREBASE EXCEPTION TRANSLATOR
  // ==========================================
  String _handleAuthException(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'អ៊ីមែល ឬពាក្យសម្ងាត់មិនត្រឹមត្រូវទេ!';
      case 'email-already-in-use':
        return 'អ៊ីមែលនេះមានក្នុងប្រព័ន្ធរួចហើយ!';
      case 'invalid-email':
        return 'ទម្រង់អ៊ីមែលមិនត្រឹមត្រូវទេ!';
      case 'weak-password':
        return 'ពាក្យសម្ងាត់ខ្សោយពេក (យ៉ាងហោចណាស់ ៦ តួ)!';
      case 'network-request-failed':
        return 'គ្មានការភ្ជាប់អ៊ីនធឺណិតទេ!';
      case 'account-exists-with-different-credential':
        return 'គណនីនេះត្រូវបានចុះឈ្មោះជាមួយ Provider ផ្សេងរួចហើយ!';
      case 'popup-closed-by-user':
        return 'ការចូលប្រព័ន្ធត្រូវបានបិទដោយអ្នកប្រើប្រាស់!';
      default:
        return 'កំហុស Firebase: $code';
    }
  }
}