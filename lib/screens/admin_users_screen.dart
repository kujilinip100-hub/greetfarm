import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../widgets/empty_state.dart';
import '../services/language_service.dart';

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
      appBar: AppBar(title: Text(LanguageService.t("manage_users"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? EmptyState(icon: Icons.people_outline, message: LanguageService.t("no_users_found"))
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
                        subtitle: Text("${u["role"] == "Farmer" ? LanguageService.t("farmer") : LanguageService.t("customer")} • ${u["email"] ?? ""}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(LanguageService.t("remove_user_title")),
                                content: Text(LanguageService.t("remove_confirm_msg").replaceAll("{name}", u["full_name"] ?? "")),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text(LanguageService.t("cancel"))),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text(LanguageService.t("delete"), style: const TextStyle(color: Colors.red))),
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