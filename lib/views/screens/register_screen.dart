import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool _isObscure = true;
  bool _isConfirmObscure = true;

  void _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {});

    await _authController.handleRegister(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      onError: (errorMsg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      },
      onSuccess: (successMsg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMsg), backgroundColor: Colors.green),
        );
        // ចូលទៅកាន់ MainPage ភ្លាមៗក្រោយចុះឈ្មោះជោគជ័យ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      },
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('បង្កើតគណនីថ្មី'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  const Text(
                    'ចុះឈ្មោះ (Sign Up)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    label: 'អ៊ីមែល',
                    hint: 'example@gmail.com',
                    prefixIcon: Icons.email_outlined,
                    validator: (val) {
                      final email = val?.trim() ?? '';
                      if (email.isEmpty) {
                        return 'សូមបញ្ចូលអ៊ីមែលរបស់អ្នក';
                      }

                      // ប្រើ Regex ទូលំទូលាយនេះ
                      final bool isValidEmail = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      ).hasMatch(email);

                      if (!isValidEmail) {
                        return 'ទម្រង់អ៊ីមែលមិនត្រឹមត្រូវទេ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    controller: _passwordController,
                    label: 'ពាក្យសម្ងាត់',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isObscure: _isObscure,
                    onToggleVisibility: () => setState(() => _isObscure = !_isObscure),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'សូមបញ្ចូលពាក្យសម្ងាត់';
                      if (val.length < 6) return 'ពាក្យសម្ងាត់ត្រូវមានយ៉ាងតិច ៦ តួ';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'បញ្ជាក់ពាក្យសម្ងាត់ម្តងទៀត',
                    prefixIcon: Icons.lock_clock_outlined,
                    isPassword: true,
                    isObscure: _isConfirmObscure,
                    onToggleVisibility: () => setState(() => _isConfirmObscure = !_isConfirmObscure),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'សូមបញ្ជាក់ពាក្យសម្ងាត់';
                      if (val != _passwordController.text) return 'ពាក្យសម្ងាត់ទាំងពីរមិនត្រូវគ្នាទេ!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  ElevatedButton(
                    onPressed: _authController.isLoading ? null : _submitRegister,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _authController.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('ចុះឈ្មោះ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),

                  // Link back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('មានគណនីរួចហើយមែនទេ? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'ចូលប្រព័ន្ធ (Login)',
                          style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}