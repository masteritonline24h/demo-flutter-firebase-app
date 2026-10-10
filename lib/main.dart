import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ឯកសារទទួលបានពី FlutterFire CLI
import 'views/screens/login_screen.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/about_screen.dart';
import 'views/screens/contact_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirebaseReady = false;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseReady = true;
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  runApp(MyApp(isFirebaseReady: isFirebaseReady));
}

class MyApp extends StatefulWidget {
  final bool isFirebaseReady;
  const MyApp({super.key, this.isFirebaseReady = true});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ✅ ប្រកាស AuthController ត្រង់នេះ ដើម្បីកុំឱ្យវា Re-instantiate រាល់ពេល build()
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isFirebaseReady) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              ' Firebase Initialization Error!\nសូមពិនិត្យមើល lib/firebase_options.dart',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _authController.checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return const MainPage();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();

  final List<Widget> _pages = const [
    HomeScreen(),
    AboutScreen(),
    ContactScreen(),
  ];

  void _onLogout() async {
    await _authController.handleLogout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Application'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _onLogout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: 'Contact'),
        ],
      ),
    );
  }
}