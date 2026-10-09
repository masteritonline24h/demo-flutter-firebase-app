import 'package:flutter/material.dart';
import '../main.dart'; // Import MainPage ដើម្បីរុញទៅទំព័រដើមពេល Login ត្រូវ

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  // កំណត់ Email និង Password ត្រឹមត្រូវសម្រាប់ផ្ទៀងផ្ទាត់
  final String _validEmail = 'demo@gmail.com';
  final String _validPassword = '123456789';

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      String inputEmail = _emailController.text.trim();
      String inputPassword = _passwordController.text;

      // ផ្ទៀងផ្ទាត់ Email និង Password ជាមួយលក្ខខណ្ឌដែលបានកំណត់
      if (inputEmail == _validEmail && inputPassword == _validPassword) {
        // បើត្រូវ៖ បង្ហាញ Message ជោគជ័យ និងចូលទៅ MainPage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ចូលប្រព័ន្ធជោគជ័យ!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // ប្លាស់ប្ដូរទៅ MainPage (និងលុប Login Page ចោលពី Navigation Stack)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        // បើខុស៖ បង្ហាញ Message ប្រាប់អ្នកប្រើប្រាស់
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('អ៊ីមែល ឬពាក្យសម្ងាត់មិនត្រឹមត្រូវទេ!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_person_outlined,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ចូលប្រព័ន្ធ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'សូមបញ្ចូល Email និង Password របស់អ្នក',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  // Email Input
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'អ៊ីមែល (Email)',
                      hintText: 'demo@gmail.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'សូមបញ្ចូលអ៊ីមែលរបស់អ្នក';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'ពាក្យសម្ងាត់ (Password)',
                      hintText: '123456789',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'សូមបញ្ចូលពាក្យសម្ងាត់';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ចូលប្រព័ន្ធ (Login)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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