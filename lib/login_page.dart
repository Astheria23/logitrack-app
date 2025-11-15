import 'package:flutter/material.dart';
import 'package:logitrack_app/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  bool isPasswordVisible = false;
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogiTrack - Login'), 
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping,
              size: 80,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 48),

            TextField(
              controller: emailController, // Hubungkan controller email
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              // 1. Gunakan variabel state untuk properti obscureText
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                // 2. Tambahkan ikon di akhir field
                suffixIcon: IconButton(
                  icon: Icon(
                    // Ganti ikon berdasarkan state
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // Panggil setState untuk mengubah state dan memicu rebuild UI
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print('Email: ${emailController.text}');
                  print('Password: ${passwordController.text}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
                child: const Text('LOGIN', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
