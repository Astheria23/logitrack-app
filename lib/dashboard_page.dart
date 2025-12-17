import 'package:flutter/material.dart';
import 'package:logitrack_app/api_service.dart';
import 'package:logitrack_app/delivery_task_model.dart';
import 'auth_service.dart';
import 'package:logitrack_app/login_page.dart';
import 'package:logitrack_app/delivery_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final ApiService apiService = ApiService();

  late Future<List<DeliveryTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();

    _tasksFuture = apiService.fetchDeliveryTasks();
  }
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Dashboard Pengiriman'),
      backgroundColor: Colors.blueAccent,
      actions: [
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await AuthService().signOut();
          if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false, 
                );
              }
        },
      ),
      ],
    ),

    body: FutureBuilder<List<DeliveryTask>>(
      future: _tasksFuture, 
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (snapshot.hasData) {
          final tasks = snapshot.data!;
          
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  title: Text(task.title),
                  subtitle: Text('ID Tugas: ${task.id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryDetailPage(task: task),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        else {
          return const Center(child: Text('Tidak ada data pengiriman.'));
        }
      },
    ),
  );
}}
