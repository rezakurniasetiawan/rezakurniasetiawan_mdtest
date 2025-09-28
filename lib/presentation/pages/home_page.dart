import 'package:fanit_mdtest/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/users_provider.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UsersProvider>(context, listen: false).loadUsers();
      Provider.of<AuthProvider>(context, listen: false).refreshCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProv = Provider.of<UsersProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final list = usersProv.users;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // background utama
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF16A085), // hijau toska gelap
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              usersProv.loadUsers();
              authProv.refreshCurrentUser();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProv.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== Header Profil =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF16A085), Color(0xFF1ABC9C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Text(
                    (authProv.user?.name.isNotEmpty == true ? authProv.user!.name[0].toUpperCase() : "?"),
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProv.user?.name ?? "Guest User",
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(authProv.user?.email ?? "—", style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                Icon(
                  authProv.user?.emailVerified == true ? Icons.verified : Icons.error,
                  color: authProv.user?.emailVerified == true ? Colors.lightGreenAccent : Colors.redAccent,
                ),
              ],
            ),
          ),

          // ===== Filter & Search =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: DropdownButton<String>(
                    value: usersProv.filter,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: "all", child: Text("All Users")),
                      DropdownMenuItem(value: "verified", child: Text("Verified")),
                      DropdownMenuItem(value: "not_verified", child: Text("Not Verified")),
                    ],
                    onChanged: (val) {
                      if (val != null) usersProv.setFilter(val);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search users...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (v) => usersProv.setSearch(v),
                  ),
                ),
              ],
            ),
          ),

          // ===== List User =====
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Text('No users found', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final u = list[i];
                      return Card(
                        color: const Color(0xFF1B263B),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: u.emailVerified ? const Color(0xFF16A085) : Colors.redAccent,
                            child: Text(u.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(
                            u.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(u.email, style: const TextStyle(color: Colors.white70)),
                          trailing: Icon(
                            u.emailVerified ? Icons.check_circle : Icons.cancel,
                            color: u.emailVerified ? Colors.lightGreenAccent : Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
