import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    await authProv.refreshCurrentUser();
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    if (authProv.user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Icon(Icons.flash_on, size: 100, color: Color(0xFF16A085)),
              const SizedBox(height: 20),

              // Nama Aplikasi
              const Text(
                "My Awesome App",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
              ),

              const SizedBox(height: 12),
              const Text("Solusi Cepat & Modern", style: TextStyle(color: Colors.white70, fontSize: 14)),

              const SizedBox(height: 40),

              // Loading indicator
              const CircularProgressIndicator(color: Color(0xFF16A085), strokeWidth: 3),
            ],
          ),
        ),
      ),
    );
  }
}
