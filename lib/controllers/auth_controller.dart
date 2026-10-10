import '../services/firebase_auth_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthController {
  // ✅ ត្រូវប្រកាស Variable នេះនៅដើម Class
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final StorageService _storageService = StorageService();

  bool isLoading = false;
  UserModel? currentUser;

  // 1. Handle Login
  Future<bool> handleLogin({
    required String email,
    required String password,
    required Function(String errorMsg) onError,
    required Function(String successMsg) onSuccess,
  }) async {
    isLoading = true;

    final AuthResult result = await _firebaseAuthService.login(email, password);

    isLoading = false;

    if (result.success && result.user != null) {
      currentUser = result.user;

      await _storageService.saveUserSession(
        token: currentUser!.id,
        userId: currentUser!.id,
        email: currentUser!.email,
      );

      onSuccess(result.message);
      return true;
    } else {
      onError(result.message);
      return false;
    }
  }

  // 2. Handle Register
  Future<bool> handleRegister({
    required String email,
    required String password,
    required Function(String errorMsg) onError,
    required Function(String successMsg) onSuccess,
  }) async {
    isLoading = true;

    final AuthResult result = await _firebaseAuthService.register(email, password);

    isLoading = false;

    if (result.success && result.user != null) {
      currentUser = result.user;

      await _storageService.saveUserSession(
        token: currentUser!.id,
        userId: currentUser!.id,
        email: currentUser!.email,
      );

      onSuccess(result.message);
      return true;
    } else {
      onError(result.message);
      return false;
    }
  }

  // 3. Handle Google Sign-In
  Future<bool> handleGoogleSignIn({
    required Function(String errorMsg) onError,
    required Function(String successMsg) onSuccess,
  }) async {
    isLoading = true;

    final AuthResult result = await _firebaseAuthService.signInWithGoogle();

    isLoading = false;

    if (result.success && result.user != null) {
      currentUser = result.user;

      await _storageService.saveUserSession(
        token: currentUser!.id,
        userId: currentUser!.id,
        email: currentUser!.email,
      );

      onSuccess(result.message);
      return true;
    } else {
      onError(result.message);
      return false;
    }
  }

  // ✅ បន្ថែម Method នេះដើម្បីពិនិត្យមើលថាតើ User ធ្លាប់បាន Login រួចឬនៅ
  Future<bool> checkAuthStatus() async {
    // ១. ពិនិត្យមើល Firebase Current User ដំបូង
    final fb.User? firebaseUser = fb.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      currentUser = UserModel.fromFirebaseUser(firebaseUser);
      return true;
    }

    // ២. ប្រសិនបើបាត់ Firebase Session ពិនិត្យមើល Storage ក្នុងម៉ាស៊ីន
    final String? token = await _storageService.getToken();
    final String? email = await _storageService.getUserEmail();
    final String? userId = await _storageService.getUserId();

    if (token != null && userId != null) {
      currentUser = UserModel(
        id: userId,
        email: email ?? '',
      );
      return true;
    }

    return false;
  }

  // 4. Logout
  Future<void> handleLogout() async {
    await _firebaseAuthService.logout();
    await _storageService.clearSession();
    currentUser = null;
  }
}