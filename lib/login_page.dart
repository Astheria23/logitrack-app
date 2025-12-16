import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan import ini untuk tipe data User
import 'package:flutter/material.dart';
import 'package:logitrack_app/dashboard_page.dart';
// import 'package:logitrack_app/api_service.dart'; // Ini boleh dihapus/comment kalau sudah tidak dipakai tes di sini
import 'package:logitrack_app/auth_service.dart';
import 'package:logitrack_app/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  // 1. Controller dipindah ke sini (state level) agar tidak reset saat rebuild
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 2. Instance AuthService
  final AuthService _authService = AuthService();

  // Bersihkan controller saat widget dimatikan (Good Practice)
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogiTrack - Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_shipping,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 48),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Masukkan format email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal harus 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24), // Sedikit perbaikan jarak

              // TOMBOL LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // Cek Validasi Form
                    if (formKey.currentState!.validate()) {
                      
                      // 3. Panggil Service Login
                      User? user = await _authService.signInWithEmailPassword(
                        emailController.text,
                        passwordController.text,
                      );

                      // 4. Cek Hasil Login
                      if (user != null) {
                        // Jika Login BERHASIL
                        if (context.mounted) { // Cek apakah widget masih aktif sebelum navigasi
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                        }
                      } else {
                        // Jika Login GAGAL
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login gagal. Periksa email dan password Anda.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } else {
                      print('Form tidak valid!');
                    }
                  },
                  child: const Text('LOGIN', style: TextStyle(fontSize: 18)),
                ),
              ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman Register
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Daftar di sini",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}