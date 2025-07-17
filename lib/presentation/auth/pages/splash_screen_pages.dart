import 'package:flutter/material.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/presentation/auth/pages/login_page.dart';
import 'package:flutter_pos/presentation/home/pages/dashboard_page.dart';

class SplashScreenPages extends StatefulWidget {
  const SplashScreenPages({super.key});

  @override
  State<SplashScreenPages> createState() => _SplashScreenPagesState();
}

class _SplashScreenPagesState extends State<SplashScreenPages>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulating loading time
    if (!mounted) return;

    final isAuth = await AuthLocalDatasource().isAuth();
    if (isAuth) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/logor.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                // const SizedBox(height: 30),
                // const Text(
                //   "POS App",
                //   style: TextStyle(
                //     fontSize: 36,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black87,
                //   ),
                // ),
                // const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Colors.blueAccent,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
