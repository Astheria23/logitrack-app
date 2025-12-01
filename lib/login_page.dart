import 'package:flutter/material.dart';
import 'package:logitrack_app/dashboard_page.dart';
import 'package:logitrack_app/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  @override
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogiTrack - Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
    key: formKey, // Kunci yang tadi dibuat
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
              controller: emailController, // Hubungkan controller email
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
              return null;},
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
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                  return null; // Return null artinya valid
              },
                        ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                  print('Form valid!');
 
                  final apiService = ApiService();
                  try {
                    final tasks = await apiService.fetchDeliveryTasks();
                    print('Berhasil mengambil data: ${tasks.length} item.');
                    if (tasks.isNotEmpty) {
                      print('Judul data pertama: ${tasks.first.title}');
                    }
                  } catch (e) {
                    print(e);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                } else {
                  print('Form tidak valid!');
                }},
                child: const Text('LOGIN', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
