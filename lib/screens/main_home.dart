import 'package:flutter/material.dart';
import 'courses_tab.dart';
import 'login_tab.dart';
import 'verify_tab.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _index = 0;
  final List<Widget> _tabs = [
    const CoursesTab(),   // Course List
    const LoginTab(),     // Student Dashboard Login
    const VerifyTab(),    // QR Scanner / Result
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.book), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Student'),
          NavigationDestination(icon: Icon(Icons.qr_code), label: 'Verify'),
        ],
      ),
    );
  }
}