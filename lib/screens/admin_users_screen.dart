import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../widgets/empty_state.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    users = await AdminService.getAllUsers();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const EmptyState(icon: Icons.people_outline, message: "No users found")
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: u["role"] == "Farmer" ? Colors.green.shade100 : Colors.orange.shade100,
                          child: Icon(
                            u["role"] == "Farmer" ? Icons.agriculture : Icons.person,
                            color: u["role"] == "Farmer" ? Colors.green : Colors.orange,
                          ),
                        ),
                        title: Text(u["full_name"] ?? ""),
                        subtitle: Text("${u["role"]} • ${u["email"] ?? ""}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Remove User"),
                                content: Text("Remove ${u["full_name"]} permanently?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await AdminService.deleteUser(int.parse(u["user_id"].toString()));
                              loadUsers();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}