import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import 'registration_screen.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _idCtrl = TextEditingController(); // StudentID or Roll
  bool _isLoading = false;
  Map<String, dynamic>? _studentData;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final sid = prefs.getString('studentID');
    if (sid != null) {
      _idCtrl.text = sid;
      _login();
    }
  }

  Future<void> _login() async {
    if (_idCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    
    final api = ApiService();
    // Using fetchStatus logic from login.html
    final res = await api.fetchStudentStatus(_idCtrl.text);
    
    setState(() => _isLoading = false);
    
    if (res['Found'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('studentID', _idCtrl.text);
      setState(() {
        _studentData = res;
        _isLoggedIn = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Student ID not found / Invalid")));
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('studentID');
    setState(() {
      _isLoggedIn = false;
      _studentData = null;
      _idCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn && _studentData != null) {
      return _buildDashboard();
    }
    return _buildLoginForm();
  }

  Widget _buildLoginForm() {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network("https://raw.githubusercontent.com/Orbital-Skills/osi.com/main/LOGO.png", height: 100),
            const SizedBox(height: 20),
            TextField(
              controller: _idCtrl,
              decoration: const InputDecoration(
                labelText: "Enter Student ID / Roll No",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F0A5A)),
                onPressed: _isLoading ? null : _login,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN DASHBOARD", style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
              },
              child: const Text("New Student? Register Here"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    // Data from API (login.html logic)
    final d = _studentData!;
    final admitLink = d['AdmitLink'];
    final resultLink = d['ResultLink']; // Assumed field based on HTML logic
    final marks = d['Marks'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 10),
            Text("Welcome, Student", style: Theme.of(context).textTheme.headlineSmall),
            Text("ID: ${_idCtrl.text}", style: const TextStyle(color: Colors.grey)),
            const Divider(height: 30),
            
            // Grid Menu
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _dashCard(Icons.file_copy, "Admit Card", () {
                  if (admitLink != null && admitLink.toString().isNotEmpty) {
                    launchUrl(Uri.parse(admitLink), mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Admit Card not generated yet")));
                  }
                }, Colors.blue),
                
                _dashCard(Icons.pie_chart, "Results", () {
                  if (marks != null) {
                    showDialog(context: context, builder: (_) => AlertDialog(
                      title: const Text("Result Status"),
                      content: Text("Total Marks: $marks\nStatus: PASS"),
                      actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("OK"))],
                    ));
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Result not declared")));
                  }
                }, Colors.green),

                _dashCard(Icons.person, "Profile", () {}, Colors.orange),
                _dashCard(Icons.book, "My Course", () {}, Colors.purple),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _dashCard(IconData icon, String title, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}