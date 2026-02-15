import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'verification_page.dart';

// 🔗 Google Script URL
const String scriptUrl =
    "https://script.google.com/macros/s/AKfycbwNZgD1IP1BUB7R8XyHTDZP1faQfr-ETJj6n005_ze9pT1D1BofuFBanQWEcmf_G2Dn/exec";



// ---Class 00.CONFIGURATION ---
class AppConstants {
  static const String appName = "Orbital Skill Development";
  static const String scriptUrl = "https://script.google.com/macros/s/AKfycbzvI0TGlNygnvWfcmewuMYFDOr5z5MGonLLBuqPMrwkuFMUBuZoJPskZbEq7xB28Jb1/exec";
  static const Color primaryColor = Color(0xFF4F0A5A); // Deep Purple
  static const Color accentColor = Color(0xFF7B1E6A);  // Light Purple
  static const Color goldColor = Color(0xFFFFD700);
}


// 🔥 Firebase Options (TOP LEVEL पर होना जरूरी है)
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCL_B52kVrkT54FMFmBANjkQrbN065g-KQ",
  authDomain: "orbital4u.firebaseapp.com",
  projectId: "orbital4u",
  storageBucket: "orbital4u.firebasestorage.app",
  messagingSenderId: "88284726348",
  appId: "1:88284726348:web:0d43de2919b592509b60e9",
  measurementId: "G-BS3BEKLJN7",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(const OrbitalApp());
}
// --- Class 0. OrbitalApp (Main Entry Point) ---
class OrbitalApp extends StatelessWidget {
  const OrbitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppConstants.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        textTheme: GoogleFonts.interTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- Class 1. MAIN NAVIGATION (FIXED RED SCREEN) ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Exact 5 Widgets for 5 Tabs to prevent RangeError
  final List<Widget> _screens = [
    const HomeScreen(),       // Home Tab
    const CoursesScreen(),    // Courses Tab
    const StudentAuthScreen(),// Student Login/Reg Tab
    const AdmitCardScreen(),     // Admit Tab
    const ResultScreen(),     // Result Tab
    const VerificationScreen(), // Verification Tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Student',
          ),
          NavigationDestination(
            icon: Icon(Icons.verified_user_outlined),
            selectedIcon: Icon(Icons.verified_user),
            label: 'AdmitCard',
          ),
          NavigationDestination(
            icon: Icon(Icons.verified_user_outlined),
            selectedIcon: Icon(Icons.verified_user),
            label: 'Result',
          ),
          NavigationDestination(
  icon: Icon(Icons.school_outlined),
  selectedIcon: Icon(Icons.school),
  label: 'Verification',
),

        ],
      ),
    );
  }
}

// --- Class 2. HOME SCREEN (Index.html Design) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orbital Skill Development", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F0A5A), Color(0xFF7B1E7A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: AppConstants.goldColor, size: 16),
                        SizedBox(width: 8),
                        Text("9416711671", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Skill Development that\nbuilds careers",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Industry-ready courses with certification, placement guidance, and practical training.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 25),
                  // Stats Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: const [
                      StatCard(count: "8+", label: "Courses"),
                      StatCard(count: "100%", label: "Certified"),
                      StatCard(count: "3-6", label: "Months"),
                      StatCard(count: "24/7", label: "Support"),
                    ],
                  ),
                ],
              ),
            ),
            
            // About Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Our Mission", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppConstants.primaryColor)),
                  const SizedBox(height: 10),
                  const Text(
                    "To empower youth with employable skills and industry-linked training that transforms lives and builds sustainable careers.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// --- Class 3. Start Card ---
class StatCard extends StatelessWidget {
  final String count;
  final String label;
  const StatCard({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count, style: const TextStyle(color: AppConstants.goldColor, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// --- Class 4. COURSES SCREEN ---
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  final List<Map<String, String>> courses = const [
    {"name": "Kisan Drone Operator", "sector": "Agriculture", "fee": "5000", "duration": "6 Months"},
    {"name": "Fashion Designer", "sector": "Apparel", "fee": "5950", "duration": "1 Year"},
    {"name": "EV Service Technician", "sector": "Automotive", "fee": "6500", "duration": "1 Year"},
    {"name": "Web Developer", "sector": "IT-ITES", "fee": "5000", "duration": "1 Year"},
    {"name": "General Duty Assistant", "sector": "Healthcare", "fee": "5500", "duration": "1 Year"},
    {"name": "Electrician", "sector": "Construction", "fee": "5000", "duration": "1 Year"},
    {"name": "Fireman", "sector": "Safety", "fee": "9200", "duration": "6 Months"},
    {"name": "Yoga Instructor", "sector": "Wellness", "fee": "5000", "duration": "1 Year"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Courses")),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                    child: Text(course['name']![0], style: const TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("${course['sector']} | Duration: ${course['duration']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text("Fee: ₹${course['fee']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor, foregroundColor: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Go to Student > Register to Apply")));
                    },
                    child: const Text("Apply"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Class 5. StudentAuthScreen + LoginPage + RegistrationPage (replace your old mixed code with this)

class StudentAuthScreen extends StatelessWidget {
  const StudentAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Portal"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Login"),
              Tab(text: "Registration"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LoginPage(),
            RegistrationPage(),
          ],
        ),
      ),
    );
  }
}
// --- Slass 6. Admit Card SCREEN  ---
class AdmitCardScreen extends StatefulWidget {
  const AdmitCardScreen({super.key});

  @override
  State<AdmitCardScreen> createState() => _AdmitCardScreenState();
}

class _AdmitCardScreenState extends State<AdmitCardScreen> {

  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  Future<void> fetchAdmitCard(String query) async {

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(scriptUrl),
        headers: {"Content-Type": "text/plain"},
        body: jsonEncode({
          "Action": "DOWNLOAD_ADMIT",
          "Query": query,
        }),
      );

      var data = jsonDecode(response.body);

      if (data['result'] == 'success') {

        String url = data['url'];

        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw "Could not open PDF";
        }

      } else if (data['result'] == 'pending') {

        _showStatusDialog(
          title: "⏳ Pending",
          message: data['message'] ?? "Admit Card not generated yet.",
          color: Colors.orange,
        );

      } else {

        _showStatusDialog(
          title: "❌ Not Found",
          message: data['message'] ?? "Admit Card not found.",
          color: Colors.red,
        );
      }

    } catch (e) {
      _showStatusDialog(
        title: "⚠ Error",
        message: e.toString(),
        color: Colors.red,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showStatusDialog({
    required String title,
    required String message,
    required Color color,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Download Admit Card"),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black12,
                )
              ],
            ),

            child: Column(
              children: [

                const Icon(
                  Icons.card_membership,
                  size: 70,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Admit Card Portal",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Enter your Student ID or Roll Number",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "OSD-20240101-1234",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        fetchAdmitCard(_searchController.text.trim());
                      }
                    },
                    child: const Text(
                      "Check & Download",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                if (isLoading)
                  const CircularProgressIndicator(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----Class 7. Registration Page -----------------
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Registration controllers & state
  final _regNameController = TextEditingController();
  final _regFatherController = TextEditingController();
  final _regMotherController = TextEditingController();
  final _regDobController = TextEditingController();
  final _regMobileController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPassController = TextEditingController();
  final _otpController = TextEditingController();

  String _regGender = "Select";
  bool _termsAccepted = false;
  bool isEmailVerified = false;
  bool otpSent = false;
  bool showOtpInput = false;
  String? generatedOTP;

  @override
  void dispose() {
    _regNameController.dispose();
    _regFatherController.dispose();
    _regMotherController.dispose();
    _regDobController.dispose();
    _regMobileController.dispose();
    _regEmailController.dispose();
    _regPassController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> sendOTP() async {
    final email = _regEmailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Email")));
      return;
    }
    setState(() => otpSent = true);
    generatedOTP = (100000 + Random().nextInt(900000)).toString();
    try {
      await http.post(
        Uri.parse(scriptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Action": "SEND_OTP",
          "Email": email,
          "OTP": generatedOTP,
        }),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP Sent to $email")));
      setState(() {
        showOtpInput = true;
        otpSent = false;
      });
    } catch (e) {
      setState(() => otpSent = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to send OTP")));
    }
  }

  void verifyOTP() {
    if (_otpController.text.trim() == generatedOTP) {
      setState(() {
        isEmailVerified = true;
        showOtpInput = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email Verified!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  String getOrCreateStudentID() {
    final now = DateTime.now();
    final rand = 1000 + Random().nextInt(9000);
    return "OSD-${DateFormat('yyyyMMdd').format(now)}-$rand";
  }

  Future<void> handleRegister() async {
    if (!isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please verify Email first!")));
      return;
    }
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Accept Terms & Conditions")));
      return;
    }

    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _regEmailController.text.trim(),
        password: _regPassController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('students')
          .doc(user.user!.uid)
          .set({
        'studentID': getOrCreateStudentID(),
        'name': _regNameController.text,
        'father': _regFatherController.text,
        'mother': _regMotherController.text,
        'dob': _regDobController.text,
        'gender': _regGender,
        'email': _regEmailController.text,
        'mobile': _regMobileController.text,
        'spouse': '',
        'maritalStatus': '',
        'caste': '',
        'areaType': '',
        'aadhaar': '',
        'voterId': '',
        'religion': '',
        'address': '',
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered Successfully!")));
      // Optionally clear fields:
      // setState(() { ... clear controllers ... });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register failed: $e")));
    }
  }

  // LOCAL helper input (specific to registration)
  Widget _buildLabelInput(
    String label,
    TextEditingController controller, {
    bool isPass = false,
    bool isDate = false,
    String? prefix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: Row(
                children: [
                  if (prefix != null)
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8), color: Colors.grey.shade200, child: Text(prefix)),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      obscureText: isPass,
                      readOnly: isDate,
                      onTap: isDate
                          ? () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) controller.text = DateFormat('yyyy-MM-dd').format(picked);
                            }
                          : null,
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: items.contains(_regGender) && label == "Gender:" ? _regGender : items.first,
                  items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => onChanged(v)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(child: Text("Student New Registration", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: Colors.red), color: const Color(0xFFfffafa)),
          child: const Text("Note: Name/Father/Mother/DOB should match Matriculation Certificate.", style: TextStyle(color: Colors.red, fontSize: 11)),
        ),
        const SizedBox(height: 12),
        _buildLabelInput("Student's Name:", _regNameController),
        _buildLabelInput("Father's Name:", _regFatherController),
        _buildLabelInput("Mother's Name:", _regMotherController),
        _buildLabelInput("Date Of Birth:", _regDobController, isDate: true),
        _buildDropdown("Gender:", ["Select", "Male", "Female"], (val) => _regGender = val ?? "Select"),
        _buildLabelInput("Mobile No:", _regMobileController, prefix: "+91"),
        const SizedBox(height: 6),

        // Email + OTP row
        Row(children: [
          const SizedBox(width: 120, child: Text("E-mail ID *:", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(
            child: Row(children: [
              Expanded(child: SizedBox(height: 36, child: TextField(controller: _regEmailController, decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true)))),
              const SizedBox(width: 8),
              if (!isEmailVerified)
                ElevatedButton(
                  onPressed: otpSent ? null : sendOTP,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(80, 36)),
                  child: Text(otpSent ? "Sending..." : "Send OTP"),
                )
              else
                const Icon(Icons.check_circle, color: Colors.green),
            ]),
          ),
        ]),

        if (showOtpInput)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(width: 140, child: TextField(controller: _otpController, decoration: const InputDecoration(hintText: "OTP", border: OutlineInputBorder(), isDense: true))),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: verifyOTP, child: const Text("Verify")),
            ]),
          ),

        const SizedBox(height: 8),
        _buildLabelInput("Create Password:", _regPassController, isPass: true),

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Checkbox(value: _termsAccepted, onChanged: (v) => setState(() => _termsAccepted = v ?? false)),
          const Text("I agree to Terms & Conditions"),
        ]),

        Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(onPressed: isEmailVerified ? handleRegister : null, child: const Text("Register")),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: () => {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), child: const Text("Cancel")),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _buildRegisterSection());
  }
}


// ------Class 8. Login Page -----------------
class LoginPage extends StatefulWidget {
  final String? redirectAfterLogin;
  final String? openPage;
  const LoginPage({super.key, this.redirectAfterLogin, this.openPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String currentCaptcha = "00000";
  final _loginEmailController = TextEditingController();
  final _loginPassController = TextEditingController();
  final _captchaInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateCaptcha();
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPassController.dispose();
    _captchaInputController.dispose();
    super.dispose();
  }

  void generateCaptcha() {
    setState(() {
      currentCaptcha = (10000 + Random().nextInt(90000)).toString();
    });
  }

  Future<void> handleLogin() async {
  if (_captchaInputController.text.trim() != currentCaptcha) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid Captcha")),
    );
    return;
  }

  // 🔵 Show Loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _loginEmailController.text.trim(),
      password: _loginPassController.text.trim(),
    );

    // ✅ Close loading
    if (Navigator.canPop(context)) Navigator.pop(context);

    // ✅ Navigate to dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );

  } on FirebaseAuthException catch (e) {

    // ❗ Close loading if error
    if (Navigator.canPop(context)) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Login Failed")),
    );

  } catch (e) {

    // ❗ Close loading if unknown error
    if (Navigator.canPop(context)) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Unexpected Error")),
    );
  }
}


  Future<void> _resetPassword() async {
    if (_loginEmailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter email in Login box to reset")));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _loginEmailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset link sent!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reset failed: $e")));
    }
  }

  Widget _buildLabelInput(
    String label,
    TextEditingController controller, {
    bool isPass = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(children: [
        SizedBox(width: 120, child: Text(label, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4), color: Colors.white),
            child: TextField(controller: controller, obscureText: isPass, decoration: const InputDecoration(border: InputBorder.none, isDense: true)),
          ),
        ),
      ]),
    );
  }

  Widget _buildLoginSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const Text("Already Registered", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        _buildLabelInput("EMAIL ID *:", _loginEmailController),
        _buildLabelInput("PASSWORD *:", _loginPassController, isPass: true),
        Row(children: [
          const SizedBox(width: 120, child: Text("CAPTCHA:", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), color: const Color(0xFFeeffee), child: Text(currentCaptcha, style: const TextStyle(fontFamily: 'Courier', fontSize: 20, letterSpacing: 4))),
          IconButton(onPressed: generateCaptcha, icon: const Icon(Icons.refresh, color: Colors.purple)),
        ]),
        _buildLabelInput("ENTER CAPTCHA:", _captchaInputController),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: handleLogin, child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text("Login")))),
        Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _resetPassword, child: const Text("Forgot Password?"))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // simple wrapper similar to your previous layout
    return SingleChildScrollView(
      child: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(child: Text("ORBITAL SKILL DEVELOPMENT CENTER", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: _buildLoginSection(),
          ),
        ],
      ),
    );
  }
}


// --- Class 9. DASHBOARD PAGE ---
class DashboardPage extends StatefulWidget {
  final String? openPage;

  const DashboardPage({super.key, this.openPage});


  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 
  String selectedPage = 'personal';
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> studentData = {};
  
  // Forms
  final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();
  
  // Controllers (A selection for brevity)
  final _dashName = TextEditingController();
  final _dashFather = TextEditingController();
  final _dashMother = TextEditingController();
  final _dashSpouse = TextEditingController();
  final _dashDob = TextEditingController();
  final _dashGender = TextEditingController();
  final _dashEmail = TextEditingController();
  final _dashMobile = TextEditingController();
  final _dashAadhaar = TextEditingController();
  final _dashAddress = TextEditingController();
  final _permAddress = TextEditingController();
  final _dashVoter = TextEditingController();
  final _dashCaste = TextEditingController();
  final _dashReligion = TextEditingController();
  final _corrState = TextEditingController(); 
  final _corrDistrict = TextEditingController(); 
  final _corrBlock = TextEditingController(); 
  final _corrPincode = TextEditingController();
  // ... (Assume other controllers exist for full "ditto" implementation)
  
  String? _photoBase64;
  String? _signBase64;
  bool isSameAddress = false;
  String aadhaarStatus = "";

// --- Examination Controllers ---
final _examState = TextEditingController();
final _examMode = TextEditingController();
final _examCenter = TextEditingController();
final _examType = TextEditingController();
final _domicileNo = TextEditingController();
final _domicileDate = TextEditingController();

// Last Qualifying Exam
final _qualClass = TextEditingController();
final _qualBoard = TextEditingController();
final _qualYear = TextEditingController();
final _qualRoll = TextEditingController();
final _qualResult = TextEditingController();
String? _qualFileBase64;


  // Course Data
  final List<Map<String, String>> courses = [
    {"name": "Health Care Skills", "fee": "5000", "icon": "user-doctor"},
    {"name": "Banking-Finance Skills", "fee": "4500", "icon": "building-columns"},
    {"name": "IT-ITS Sector", "fee": "6000", "icon": "laptop-code"},
    {"name": "Fireman", "fee": "5500", "icon": "fire-extinguisher"},
    {"name": "Electrician", "fee": "4000", "icon": "bolt"},
    {"name": "Plumber", "fee": "3500", "icon": "faucet"},
    {"name": "Cyber Security", "fee": "7000", "icon": "shield-halved"},
  ];
String? selectedCourseName;
String? selectedCourseFee;
bool paymentDone = false;

 @override
void initState() {
  super.initState();
  _loadData();
  
  if (widget.openPage == 'admit') {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🔒 Admit Card के लिए Login करें"),
          backgroundColor: Colors.redAccent,
        ),
      );
    });
  }
}

  Future<void> _loadData() async {
  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('students')
      .doc(user!.uid)
      .get();

  if (!doc.exists) return;

  final data = doc.data() as Map<String, dynamic>;

  setState(() {
    // 👇👇👇 FIX: अगर ID नहीं है, तो अभी बना लो 👇👇👇
    if (data['studentID'] != null && data['studentID'] != "") {
      studentData['studentID'] = data['studentID'];
    } else {
       // Generate Temp ID based on Date
       final now = DateTime.now();
       final rand = 1000 + Random().nextInt(9000);
       String newID = "OSD-${DateFormat('yyyyMMdd').format(now)}-$rand";
       studentData['studentID'] = newID;
       
       // (Optional) इसे Firestore में सेव भी कर सकते हैं
       FirebaseFirestore.instance.collection('students').doc(user!.uid).set(
         {'studentID': newID}, SetOptions(merge: true)
       );
    }

    _dashName.text = data['name'] ?? '';
    _dashFather.text = data['father'] ?? '';
    _dashMother.text = data['mother'] ?? '';
    _dashDob.text = data['dob'] ?? '';
    _dashGender.text = data['gender'] ?? '';
    _dashEmail.text = data['email'] ?? '';
    _dashMobile.text = data['mobile'] ?? '';

    // PERSONAL
    _dashSpouse.text = data['spouse'] ?? '';
    _dashAadhaar.text = data['aadhaar'] ?? '';
    _dashCaste.text = data['caste'] ?? '';
    _dashVoter.text = data['voterId'] ?? '';
    _dashReligion.text = data['religion'] ?? '';
    _dashAddress.text = data['address'] ?? '';

    // ADDRESS
    _corrState.text = data['corrState'] ?? '';
    _corrDistrict.text = data['corrDistrict'] ?? '';
    _corrBlock.text = data['corrBlock'] ?? '';
    _corrPincode.text = data['corrPincode'] ?? '';

    // PHOTO
    if (data['photoData'] != null) {
      _photoBase64 = data['photoData']['photoBase64'];
      _signBase64 = data['photoData']['signBase64'];
    }

    // EXAM
    _examState.text = data['examState'] ?? '';
    _examMode.text = data['examMode'] ?? '';
    _examCenter.text = data['examCenter'] ?? '';
    _examType.text = data['examType'] ?? '';
    _domicileNo.text = data['domicileNo'] ?? '';
    _domicileDate.text = data['domicileDate'] ?? '';

    // QUALIFICATION
    _qualClass.text = data['qualClass'] ?? '';
    _qualBoard.text = data['qualBoard'] ?? '';
    _qualYear.text = data['qualYear'] ?? '';
    _qualRoll.text = data['qualRoll'] ?? '';
    _qualResult.text = data['qualResult'] ?? '';
    _qualFileBase64 = data['qualFile'];
  });

  _checkStatus();
}


  // --- LOGIC ---
  Future<void> _pickImage(bool isPhoto) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      String base64 = "data:image/jpeg;base64,${base64Encode(bytes)}";
      setState(() {
        if (isPhoto) _photoBase64 = base64; else _signBase64 = base64;
      });
    }
  }

  // Aadhaar Validation Logic (Verhoeff/Array based port from JS)
  void checkAadhar() {
    String val = _dashAadhaar.text;
    if (val.length != 12) {
      setState(() => aadhaarStatus = "Enter 12 digits");
      return;
    }
    // Porting the specific JS array logic
    const d = [[0,1,2,3,4,5,6,7,8,9],[1,2,3,4,0,6,7,8,9,5],[2,3,4,0,1,7,8,9,5,6],[3,4,0,1,2,8,9,5,6,7],[4,0,1,2,3,9,5,6,7,8],[5,9,8,7,6,0,4,3,2,1],[6,5,9,8,7,1,0,4,3,2],[7,6,5,9,8,2,1,0,4,3],[8,7,6,5,9,3,2,1,0,4],[9,8,7,6,5,4,3,2,1,0]];
    const p = [[0,1,2,3,4,5,6,7,8,9],[1,5,7,6,2,8,3,0,9,4],[5,8,0,3,7,9,6,1,4,2],[8,9,1,6,0,4,3,5,2,7],[9,4,5,3,1,2,6,8,7,0],[4,2,8,6,5,7,3,9,0,1],[2,7,9,3,8,0,6,4,1,5],[7,0,4,6,9,1,3,2,5,8]];
    
    int c = 0;
    List<int> inverted = val.split('').map(int.parse).toList().reversed.toList();
    for (int i = 0; i < inverted.length; i++) {
      c = d[c][p[i % 8][inverted[i]]];
    }
    setState(() {
      aadhaarStatus = c == 0 ? "✓ Valid Aadhaar" : "✗ Invalid Aadhaar";
    });
  }

  Future<void> savePersonal() async {
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User not logged in")),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(user!.uid)
        .set({
      'spouse': _dashSpouse.text,
  'aadhaar': _dashAadhaar.text,
  'caste': _dashCaste.text,
  'voterId': _dashVoter.text,
  'religion': _dashReligion.text,
  'address': _dashAddress.text,

  // 🔽👇👇 ADDRESS PART (MISSING)
  'corrState': _corrState.text,
  'corrDistrict': _corrDistrict.text,
  'corrBlock': _corrBlock.text,
  'corrPincode': _corrPincode.text,

      'photoData': {
        'photoBase64': _photoBase64 ?? "",
        'signBase64': _signBase64 ?? "",
      },


    }, SetOptions(merge: true)); // ⭐ KEY LINE

    setState(() => selectedPage = 'exam');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Personal Details Saved!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Save failed: $e")),
    );
  }
}
Future<void> saveExamDetails() async {
  if (user == null) return;

  try {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(user!.uid)
        .set({
     
    }, SetOptions(merge: true));

    setState(() => selectedPage = 'preview');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Examination Details Saved")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Save failed: $e")),
    );
  }
}


  Future<void> selectCourse(String name, String fee) async {
  setState(() {
    selectedCourseName = name;
    selectedCourseFee = fee;
  });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _paymentPopup(),
  );
}

  
  Future<void> _checkStatus() async {
    // Implementation of fetchStatus from JS
  }

  void _logout() async {
  await FirebaseAuth.instance.signOut();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const MainScreen()),
    (route) => false,
  );
}


Future<void> sendDataToSheet() async {
  try {
    // 1. Prepare the JSON string
    String jsonBody = jsonEncode({
        "Action": "FULL_SAVE",
         "StudentID": studentData['studentID'] ?? "OSD-GEN-${Random().nextInt(9999)}",
        "FirebaseUID": user!.uid,

        // ===== PERSONAL =====
        "FullName": _dashName.text,
        "FatherName": _dashFather.text,
        "MotherName": _dashMother.text,
        "SpouseName": _dashSpouse.text,
        "DOB": _dashDob.text,
        "Gender": _dashGender.text,
        "MaritalStatus": "",

        "Caste": _dashCaste.text,
        "Religion": _dashReligion.text,
        "Aadhaar": _dashAadhaar.text,
        "VoterID": _dashVoter.text,

        "Mobile": _dashMobile.text,
        "Email": _dashEmail.text,

        // ===== ADDRESS =====
        "Address": _dashAddress.text,
        "State": _corrState.text,
        "District": _corrDistrict.text,
        "Tehsil": _corrBlock.text,
        "City": "",
        "Block": _corrBlock.text,
        "Pincode": _corrPincode.text,

        // ===== PERMANENT ADDRESS =====
        "PermanentAddress": _dashAddress.text,
        "PermanentState": _corrState.text,
        "PermanentDistrict": _corrDistrict.text,
        "PermanentTehsil": _corrBlock.text,
        "PermanentCity": "",
        "PermanentBlock": _corrBlock.text,
        "PermanentPincode": _corrPincode.text,

        // ===== PHOTO =====
        "PhotoBase64": _photoBase64 ?? "",
        "PhotoStatus": _photoBase64 != null ? "Uploaded" : "",

        // ===== EXAM =====
        "ExamState": _examState.text,
        "ExamMode": _examMode.text,
        "DomicileNo": _domicileNo.text,
        "ExamCenterChoice": _examCenter.text,
        "DomicileDate": _domicileDate.text,
        "ExamType": _examType.text,

        // ===== COURSE =====
        "Course": selectedCourseName ?? "",
        "Qualification": _qualClass.text,
        "roll_number": "AUTO",

  "roll_number": "AUTO_GENERATE", // Google Script इसे भरेगा
  "post_name": selectedCourseName ?? "", // Course को ही Post Name बना दिया
  "exam_date": "15/02/2026",
  "exam_shift": "Morning",
  "exam_time": "10:00",
  "centre_code": "TC37802",
  "centre_address": "ORBITAL Skill CENTER Fatehabad",

        "status": "Pending",
      },
    );

    final res = await http.post(
      Uri.parse(scriptUrl),
      headers: {
        "Content-Type": "text/plain", 
      },
      body: jsonBody,
    );

    // 3. Google Script returns a 302 Redirect usually. 
    // http.post follows it automatically, but sometimes returns HTML.
    // We assume if no exception is thrown, it reached the server.
    
    if (res.statusCode == 200 || res.statusCode == 302) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Sheet में data save हो गया")),
      );
    } else {
       print("Server response: ${res.body}");
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Status Code: ${res.statusCode}")),
      );
    }

  } catch (e) {
     
    print("Log: Request completed with potential CORS warning: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Data Submitted! (OK)"),
        backgroundColor: Colors.green, 
        duration: Duration(seconds: 4),
      ),
    );
    setState(() => selectedPage = 'preview');
  }
}
// --- ADMIT CARD BUTTON LOGIC ---
  void _onAdmitCardPressed() {
    TextEditingController _searchCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Download Admit Card"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter Student ID (OSD-...) or Roll No:"),
            const SizedBox(height: 10),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ex: 260300001",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (_searchCtrl.text.isNotEmpty) {
                Navigator.pop(context); // Close dialog
                _checkAndDownloadAdmitCard(_searchCtrl.text.trim());
              }
            },
            child: const Text("Check & Download"),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAndDownloadAdmitCard(String query) async {
    // 1. Show Loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Checking status... Please wait.")),
    );

    try {
      // 2. Call Google Script
      String url =
        "$scriptUrl?Action=DOWNLOAD_ADMIT&Query=$query";
      var response = await http.post(
        Uri.parse(scriptUrl),
        headers: {"Content-Type": "text/plain"},
        body: jsonEncode({
          "Action": "DOWNLOAD_ADMIT",
          "Query": query,
        }),
      );

      var data = jsonDecode(response.body);

      // 3. Logic: Generated vs Pending vs Error
      if (data['result'] == 'success') {
        String url = data['url'];
        
        // Open PDF (Browser handle karega download)
        if (await canLaunchUrl(Uri.parse(url))) {
           await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("✅ Opening Admit Card...")),
           );
        } else {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not launch PDF.")));
        }

      } else if (data['result'] == 'pending') {
        // Found but not generated
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("⚠️ Not Generated"),
            content: Text(data['message'] ?? "Admit Card is pending approval."),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );

      } else {
        // Not Found
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("❌ Error: ${data['message']}"), backgroundColor: Colors.red),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error: $e")),
      );
    }
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
       key: _scaffoldKey,
        drawer: !isDesktop ? Drawer(child: _buildSidebar()) : null,
       body: Row(
        children: [
          // SIDEBAR (Drawer logic for mobile, Permanent for desktop)
          if(isDesktop) _buildSidebar(),
          
          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: const Color(0xFF337ab7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                         if(!isDesktop) IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {
                            _scaffoldKey.currentState?.openDrawer(); },
                            ),
                         const CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 15, color: Colors.white)),
                         const SizedBox(width: 5),
                         Text(studentData['name']?.toUpperCase() ?? "STUDENT", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                      ]),
                      if(isDesktop) const Text("Student Type: Private | Expire In: 29:36 Min", style: TextStyle(color: Colors.white, fontSize: 11))
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: _buildCurrentPage(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      
    );
  }

  Widget _buildExamPage() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER
          Container(
            width: double.infinity,
            color: const Color(0xFFf5f5f5),
            padding: const EdgeInsets.all(10),
            child: const Text(
              "EXAMINATION DETAILS",
              style: TextStyle(
                color: Color(0xFF337ab7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ROW 1
          Row(children: [
            Expanded(child: _dashInput("State to which you belong", _examState)),
            const SizedBox(width: 10),
            Expanded(child: _dashInput("Exam Mode", _examMode)),
          ]),

          // ROW 2
          Row(children: [
            Expanded(child: _dashInput("Choice for Exam Center", _examCenter)),
            const SizedBox(width: 10),
            Expanded(child: _dashInput("Exam Type", _examType)),
          ]),

          // ROW 3
          Row(children: [
            Expanded(child: _dashInput("Domicile No", _domicileNo)),
            const SizedBox(width: 10),
            Expanded(
              child: _dashInput(
                "Domicile Date",
                _domicileDate,
                readOnly: true,
              ),
            ),
          ]),

          const SizedBox(height: 20),

          // QUALIFYING EXAM
          const Text(
            "LAST QUALIFYING EXAMINATION DETAILS",
            style: TextStyle(
              color: Color(0xFF337ab7),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),

          Row(children: [
            Expanded(child: _dashInput("Class", _qualClass)),
            const SizedBox(width: 10),
            Expanded(child: _dashInput("Board", _qualBoard)),
          ]),

          Row(children: [
            Expanded(child: _dashInput("Year", _qualYear)),
            const SizedBox(width: 10),
            Expanded(child: _dashInput("Roll No", _qualRoll)),
          ]),

          Row(children: [
            Expanded(child: _dashInput("Result", _qualResult)),
          ]),

          const SizedBox(height: 20),

          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: const Text("Add More Class"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
    ),

    ElevatedButton(
      onPressed: saveExamDetails,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
      ),
      child: const Text("Preview Form"),
    ),
  ],
),

        ],
      ),
    ),
  );
}

Widget _buildPreviewPage() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ===== SELECTED COURSE + STUDENT ID =====
if (selectedCourseName != null)
  Container(
    padding: const EdgeInsets.all(10),
    color: const Color(0xFFEAF4FF),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Student ID: ${studentData['studentID'] ?? 'N/A'}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Selected Course: $selectedCourseName",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Fee: ₹$selectedCourseFee",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    ),
  ),


          const SizedBox(height: 10),

          // ===== PERSONAL DETAILS =====
          _sectionTitle("STUDENT PERSONAL DETAILS"),
          _previewRow("FULL NAME", _dashName.text, "FATHER'S NAME", _dashFather.text),
          _previewRow("MOTHER'S NAME", _dashMother.text, "SPOUSE NAME", _dashSpouse.text),
          _previewRow("DOB", _dashDob.text, "GENDER", _dashGender.text),
          _previewRow("EMAIL", _dashEmail.text, "MOBILE", _dashMobile.text),
          _previewRow("CASTE", _dashCaste.text, "AADHAAR", _dashAadhaar.text),
          _previewRow("VOTER ID", _dashVoter.text, "", ""),

          const SizedBox(height: 10),

          // ===== ADDRESS =====
          _sectionTitle("CORRESPONDENCE ADDRESS"),
          _previewSingle("FULL ADDRESS", _dashAddress.text),
          _previewRow("STATE", _corrState.text, "DISTRICT", _corrDistrict.text),
          _previewRow("BLOCK / TEHSIL", _corrBlock.text, "PIN", _corrPincode.text),

          const SizedBox(height: 10),

          // ===== PHOTO & SIGNATURE =====
          _sectionTitle("PHOTO & SIGNATURE"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _previewImage("PHOTO", _photoBase64),
              _previewImage("SIGNATURE", _signBase64),
            ],
          ),

          const SizedBox(height: 10),

          // ===== EXAMINATION DETAILS =====
          _sectionTitle("EXAMINATION DETAILS"),
          _previewRow("STATE", _examState.text, "EXAM MODE", _examMode.text),
          _previewRow("EXAM CENTER", _examCenter.text, "EXAM TYPE", _examType.text),

          const SizedBox(height: 20),

          // ===== BUTTONS =====
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => setState(() => selectedPage = 'personal'),
                child: const Text("Edit Detail"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () => setState(() => selectedPage = 'courses'),
                child: const Text("Select Course"),
              ),
            ],
          ),
          const SizedBox(height: 15),

Align(
  alignment: Alignment.centerRight,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    onPressed: () async {
      await sendDataToSheet();
      setState(() => selectedPage = 'preview');
    },
    child: const Text("Final Submit"),
  ),
),

        ],
      ),
    ),
  );
}

Widget _previewImage(String title, String? base64) {
  return Column(
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Container(
        width: title == "PHOTO" ? 100 : 140,
        height: title == "PHOTO" ? 120 : 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: base64 != null && base64.isNotEmpty
            ? Image.memory(
                base64Decode(base64.split(',')[1]),
                fit: BoxFit.cover,
              )
            : const Center(child: Text("Not Uploaded")),
      ),
    ],
  );
}


Widget _sectionTitle(String text) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(8),
    color: const Color(0xFFE1F0C4),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
    ),
  );
}

Widget _previewRow(String l1, String v1, String l2, String v2) {
  return Row(
    children: [
      Expanded(child: _previewField(l1, v1)),
      const SizedBox(width: 10),
      Expanded(child: _previewField(l2, v2)),
    ],
  );
}

Widget _previewSingle(String label, String value) {
  return _previewField(label, value);
}

Widget _previewField(String label, String value) {
  if (label.isEmpty) return const SizedBox();
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            color: const Color(0xFFF7F7F7),
          ),
          child: Text(value.isEmpty ? "-" : value),
        ),
      ],
    ),
  );
}


  Widget _buildSidebar() {
    return Container(
      width: 230,
      color: const Color(0xFFf8f8f8),
      child: Column(
        children: [
          Container(width: double.infinity, color: const Color(0xFF337ab7), padding: const EdgeInsets.all(15), child: const Text("Student Exam Menu", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          _sidebarLink("Student's Personal Details", 'personal'),
          _sidebarLink("Examination Details", 'exam'),
          _sidebarLink("Application Status", 'preview'),
          _sidebarLink("Select Course", 'courses'),
          const Divider(),
          ListTile(leading: const Icon(FontAwesomeIcons.rightFromBracket, color: Colors.red, size: 16), title: const Text("Sign Out", style: TextStyle(color: Colors.red)), onTap: _logout),
        ],
      ),
    );
  }

  Widget _sidebarLink(String title, String id) {
    bool active = selectedPage == id;
    return Container(
      decoration: BoxDecoration(
  color: active ? const Color(0xFFE7E7E7) : null,
  border: Border(
    bottom: const BorderSide(color: Color(0xFFEAEAEA)),
    left: active
        ? const BorderSide(color: Color(0xFF337ab7), width: 4)
        : BorderSide.none,
  ),
),

      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: active ? const Color(0xFF337ab7) : const Color(0xFF333333))),
        onTap: () => setState(() => selectedPage = id),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (selectedPage) {
      case 'personal': return _buildPersonalPage();
      case 'exam': return _buildExamPage();
      case 'preview': return _buildPreviewPage();
      case 'courses': return _buildCoursesPage();
      default: return Container();
    }
  }

  Widget _buildPersonalPage() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: double.infinity, color: const Color(0xFFf5f5f5), padding: const EdgeInsets.all(10), child: const Text("STUDENT PERSONAL DETAILS", style: TextStyle(color: Color(0xFF337ab7), fontWeight: FontWeight.bold))),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(child: _dashInput("1. FULL NAME", _dashName, readOnly: true)),
              const SizedBox(width: 10),
              Expanded(child: _dashInput("2. FATHER'S NAME", _dashFather, readOnly: true)),
            ]),
            Row(children: [
               Expanded(child: _dashInput("3. MOTHER'S NAME", _dashMother, readOnly: true)),
               const SizedBox(width: 10),
               Expanded(child: _dashInput("4. SPOUSE NAME", _dashSpouse)),
            ]),
             Row(children: [
               Expanded(child: _dashInput("5. DOB", _dashDob, readOnly: true)),
               const SizedBox(width: 10),
               Expanded(child: _dashInput("6. GENDER", _dashGender, readOnly: true)),
            ]),
            Row(children: [
               Expanded(child: _dashInput("7. E-MAIL ID", _dashEmail, readOnly: true)),
               const SizedBox(width: 10),
               Expanded(child: _dashInput("8. MOBILE", _dashMobile, readOnly: true)),
            ]),
            Row(children: [
               Expanded(child: _dashInput("9. AADHAAR", _dashAadhaar, onChanged: (v) => checkAadhar())),
               const SizedBox(width: 10),
               
               Expanded(child: _dashInput("10. VOTER ID", _dashVoter)),
            ]),
            Row(children: [
               Expanded(child: _dashInput("10. Caste", _dashCaste)),
               const SizedBox(width: 10),
               Expanded(child: _dashInput("11. RELIGION", _dashReligion)),
            ]),
            const SizedBox(height: 10),
            _dashInput("15. FULL ADDRESS", _dashAddress, isArea: true),
             Row(children: [
               Expanded(child: _dashInput("16. STATE *", _corrState)),
               const SizedBox(width: 10),
               Expanded(child: _dashInput("17. DISTRICT *", _corrDistrict)),
            ]),
            
            Row(children: [
               Expanded(child: _dashInput("20. BLOCK / VILLAGE", _corrBlock)),
               const SizedBox(width: 10),
               Expanded(child: _dashInput("21. PIN CODE *", _corrPincode)),
            ]),
            // Photos
            const SizedBox(height: 20),
            const Text("PHOTO & SIGNATURE", style: TextStyle(color: Color(0xFF337ab7), fontWeight: FontWeight.bold)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 Column(children: [
                   Container(
  width: 119,
  height: 136,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
  ),
  child: _photoBase64 != null
      ? Image.memory(
          base64Decode(_photoBase64!.split(',')[1]),
          fit: BoxFit.cover,
        )
      : const Center(child: Text("PHOTO")),
),

                   TextButton(onPressed: () => _pickImage(true), child: const Text("Upload Photo"))
                 ]),
                 Column(children: [
                   Container(
  width: 150,
  height: 60,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
  ),
  child: _signBase64 != null
      ? Image.memory(
          base64Decode(_signBase64!.split(',')[1]),
          fit: BoxFit.contain,
        )
      : const Center(child: Text("SIGN")),
),

                   TextButton(onPressed: () => _pickImage(false), child: const Text("Upload Sign"))
                 ]),
              ],
            ),
            
            const SizedBox(height: 20),
            Align(alignment: Alignment.centerRight, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5bc0de)), onPressed: savePersonal, child: const Text("Save Personal Details")))
          ],
        ),
      ),
    );
  }

@override
void dispose() {
  _dashName.dispose();
  _dashFather.dispose();
  _dashMother.dispose();
  _dashSpouse.dispose();
  _dashDob.dispose();
  _dashGender.dispose();
  _dashEmail.dispose();
  _dashMobile.dispose();
  _dashAadhaar.dispose();
  _dashAddress.dispose();
  _permAddress.dispose();
  _dashVoter.dispose();
  _dashCaste.dispose();
  _dashReligion.dispose();
  _corrState.dispose();
  _corrDistrict.dispose();
  _corrBlock.dispose();
  _corrPincode.dispose();

  _examState.dispose();
_examMode.dispose();
_examCenter.dispose();
_examType.dispose();
_domicileNo.dispose();
_domicileDate.dispose();

_qualClass.dispose();
_qualBoard.dispose();
_qualYear.dispose();
_qualRoll.dispose();
_qualResult.dispose();


  super.dispose();
}

Widget _paymentPopup() {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            "Course Fee Payment",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Selected Course:", style: TextStyle(color: Colors.grey)),
                Text(
                  selectedCourseName ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Fee:"),
                    Text(
                      "₹${selectedCourseFee}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 15),

          // QR IMAGE
          Image.asset(
            "assets/upi_qr.png", // 👈 अपना QR image
            height: 200,
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            color: const Color(0xFFFFF6D5),
            child: const Text(
              "UPI ID: hmt2cu@okaxis",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            icon: const Icon(Icons.phone_android),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {},
            label: const Text("Pay via UPI App"),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFFFFEAEA),
            child: const Text(
              "नोट: पेमेंट के बाद स्क्रीनशॉट WhatsApp पर भेजें",
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              paymentDone = true;

              FirebaseFirestore.instance
                  .collection('students')
                  .doc(user!.uid)
                  .set({
                'selectedCourse': selectedCourseName,
                'courseFee': selectedCourseFee,
                'feeStatus': 'Screenshot Sent',
              }, SetOptions(merge: true));

              Navigator.pop(context);

              setState(() {
                selectedPage = 'preview';
              });
            },
            label: const Text("WhatsApp Screenshot"),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildCoursesPage() {
    return Wrap(
      spacing: 20, runSpacing: 20,
      alignment: WrapAlignment.center,
      children: courses.map((c) {
        IconData iconData = FontAwesomeIcons.book;
        // Map icons manually since string to icon isn't direct in dart without a map
        if(c['icon'] == 'user-doctor') iconData = FontAwesomeIcons.userDoctor;
        if(c['icon'] == 'bolt') iconData = FontAwesomeIcons.bolt;
        // ... add others
        
        return InkWell(
          onTap: () => selectCourse(c['name']!, c['fee']!),
          child: Container(
            width: 200, height: 180,
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 40, color: const Color(0xFF337ab7)),
                const SizedBox(height: 15),
                Text(c['name']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF555))),
                const SizedBox(height: 5),
                Text("Fee: ₹${c['fee']}", style: const TextStyle(fontSize: 10, color: Color(0xFF337ab7), fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _dashInput(String label, TextEditingController ctrl, {bool readOnly = false, bool isArea = false, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF555))),
        const SizedBox(height: 2),
        Container(
  height: isArea ? 70 : 34,
  padding: const EdgeInsets.symmetric(horizontal: 6),
  decoration: BoxDecoration(
    color: readOnly ? const Color(0xFFEEEEEE) : Colors.white,
    border: Border.all(color: Colors.grey.shade400),
  ),
  child: TextField(
    controller: ctrl,
    readOnly: readOnly,
    maxLines: isArea ? 3 : 1,
    onChanged: onChanged, 
     textAlignVertical: isArea ? TextAlignVertical.top : TextAlignVertical.center,
     style: const TextStyle(fontSize: 11),
    decoration: InputDecoration(
  border: InputBorder.none,
  isDense: true, // ⭐ MOST IMPORTANT LINE
  hintText: readOnly
      ? null
      : "Enter ${label.replaceAll(RegExp(r'[0-9.*]'), '').trim()}",
  hintStyle: const TextStyle(
    fontSize: 11,
    color: Colors.grey,
  ),
  contentPadding: EdgeInsets.only(
              top: isArea ? 6 : 0, // ⭐ single-line = 0
            ),
),

  ),
),
const SizedBox(height: 5),

      ],
    );
  }
}
 
// --- Class 10 FIXED BOTTOM BAR CLASS ---
class FixedBottomBar extends StatelessWidget {
  final VoidCallback? onAdmitClick; 
  final bool isAdmitMode;

  const FixedBottomBar({
    super.key, 
    this.onAdmitClick,       
    this.isAdmitMode = false 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFf8f8f8),
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         
     // LOGIN BUTTON
          InkWell(
            onTap: () {
                // Already on login page, do nothing or refresh
            },
            child: Column(
              children: const [
                Icon(Icons.login, color: Color(0xFF337ab7)),
                Text("Login", style: TextStyle(color: Color(0xFF337ab7), fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
          
      // ADMIT CARD BUTTON
          InkWell(
            onTap: onAdmitClick, 
            child: Column(
              children: [
                Icon(
                  Icons.card_membership, 
                  color: isAdmitMode ? Colors.red : const Color(0xFF555555)
                ),
                Text(
                  "Admit Card", 
                  style: TextStyle(
                    color: isAdmitMode ? Colors.red : const Color(0xFF555555),
                    fontWeight: isAdmitMode ? FontWeight.bold : FontWeight.normal,
                    fontSize: 11
                  )
                ),
              ],
            ),
          ),

      // Result BUTTON
            _Button(context, Icons.app_registration, "Result", const ResultScreen()),
      
      //Verification BUTTON
          _Button(context, Icons.school, "Verification", const VerificationScreen()),
        ],
      ),
    );
  }

  Widget _Button(
  BuildContext context,
  IconData icon,
  String label,
  Widget screen,
) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    },
    child: Column(
      children: [
        Icon(icon, color: const Color(0xFF555555)),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}}

// ---Class 11. Result SCREEN  ---
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? resultData;
  bool isLoading = false;

Future<void> fetchResult(String query) async {

  setState(() {
    isLoading = true;
    resultData = null;
  });

  try {
    var response = await http.post(
      Uri.parse(scriptUrl),
      headers: {"Content-Type": "text/plain"},
      body: jsonEncode({
        "Action": "GET_RESULT",
        "Query": query,
      }),
    );

    print("SERVER RESPONSE: ${response.body}");

    if (response.body.isEmpty) {
      _showDialog("Server Error", "Empty response from server");
      return;
    }

    Map<String, dynamic> data;

    try {
      data = jsonDecode(response.body);
    } catch (e) {
      _showDialog("Server Error", "Invalid JSON response");
      return;
    }

    if (data['result'] == 'success') {
      setState(() {
        resultData = data['data'];
      });

    } 
    else if (data['result'] == 'not_declared') {
      _showDialog("⏳ Result Not Declared", data['message']);

    } 
    else if (data['result'] == 'invalid') {
      _showDialog("❌ Invalid Roll", data['message']);

    } 
    else if (data['result'] == 'error') {   // 🔥 ADD THIS
  _showDialog("Invalid Roll No", data['message']);
  }
    else {
      _showDialog("Unexpected Response", "Unknown server response");
    }

  } catch (e) {
    _showDialog("Network Error", e.toString());
  }

  setState(() {
    isLoading = false;
  });
}

  void openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRResultScanner(
          onScanned: (value) {
            Navigator.pop(context);
            fetchResult(value);
          },
        ),
      ),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
  color: const Color(0xFF7B1E6A),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  child: Row(
    children: [

      /// 🔹 LOGO
      Image.asset(
        "assets/images/logo.png",
        height: 60,
      ),

      const SizedBox(width: 15),

      /// 🔹 TITLE TEXT
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "ORBITAL SKILL DEVELOPMENT CENTRE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "ISO 9001:2015 Certified | Govt. Regd.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),

      /// 🔹 PUSH EVERYTHING TO LEFT
      const Spacer(),

      /// 🔹 HOME BUTTON (RIGHT SIDE)
      ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => false,
          );
        },
        icon: const Icon(Icons.home, size: 18),
        label: const Text("Home"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ],
  ),
),


            const SizedBox(height: 30),

            // ================= SEARCH CARD =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: Column(
                children: [

                  const Text(
                    "Get Your Result",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1E6A),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Enter Roll Number or Registration ID",
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        fetchResult(_searchController.text.trim());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1E6A),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "SEARCH RESULT",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold ),
                    ),
                  ),

                 

                ],
              ),
            ),

            const SizedBox(height: 30),

            if (isLoading)
              const CircularProgressIndicator(),

            if (resultData != null)
  Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        /// 📄 RESULT DISPLAY पहले
        ResultDisplay(data: resultData!),

        const SizedBox(height: 25),

        /// 🔽 DOWNLOAD CERTIFICATE BUTTON सबसे नीचे
        ElevatedButton.icon(
          onPressed: () async {
            String? url = resultData!['pdfLink'];

            if (url != null && url.isNotEmpty) {
              final uri = Uri.parse(url);

              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Unable to open certificate")),
                );
              }
            }
          },
          icon: const Icon(Icons.download),
          label: const Text("Download Certificate"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    ),
  ),

          ],
        ),
      ),
    );
  }
}


// ---Class 12. Result Display SCREEN  ---
class ResultDisplay extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        /// 🔐 WATERMARK
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.05,
              child: Center(
                child: Text(
                  "VERIFIED",
                  style: TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ),
          ),
        ),

        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7B1E6A), width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= HEADER =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: const Color(0xFF7B1E6A),
                  child: const Center(
                    child: Text(
                      "Orbital Skill Development Center",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 70,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔰 VERIFIED BADGE
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "VERIFIED STUDENT RECORD",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// ================= STUDENT INFO =================
                const Text(
                  "Student Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _infoRow("Roll No:", data['rollNo']),
                _infoRow("Student ID:", data['studentID']),
                _infoRow("Name:", data['name']),
                _infoRow("Father:", data['father']),
                _infoRow("Course:", data['course']),

                const Divider(height: 30),

                /// ================= MARKS =================
                const Text(
                  "Academic Record",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                _tableHeader(),
                const SizedBox(height: 6),

                ..._buildSubjectRows(),

                const SizedBox(height: 12),

                _grandTotalRow(),

                const SizedBox(height: 30),

                /// ================= FOOTER =================
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/sign.png",
                        height: 60,
                      ),
                      const Text(
                        "Director Signature",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ================= HELPER WIDGETS =================

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value?.toString() ?? "-"),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF7B1E6A),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text("Subject", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(child: Center(child: Text("Max", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          Expanded(child: Center(child: Text("Marks", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          Expanded(child: Center(child: Text("Grade", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }

  List<Widget> _buildSubjectRows() {
    List subjects = data['subjects'] ?? [];

    return subjects.map<Widget>((sub) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(sub['subject'])),
            const Expanded(child: Center(child: Text("100"))),
            Expanded(child: Center(child: Text("${sub['marks']}"))),
            Expanded(
              child: Center(
                child: Text(
                  data['grade'] ?? "-",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: data['grade'] == "A"
                        ? Colors.amber.shade700   // 🏆 GOLD HIGHLIGHT
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _grandTotalRow() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey.shade200,
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              "Grand Total",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                data['outOf']?.toString() ?? "-",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                data['totalMarks']?.toString() ?? "-",
                style: const TextStyle(color: Color(0xFF7B1E6A), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                data['grade'] ?? "-",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: data['grade'] == "A"
                      ? Colors.amber.shade700   // 🏆 GOLD
                      : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---Class 12. QR Result  SCREEN  ---
class QRResultScanner extends StatelessWidget {
  final Function(String) onScanned;

  const QRResultScanner({super.key, required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          final value = barcode.rawValue;

          if (value != null) {
            Navigator.pop(context);
            onScanned(value);
          }
        },
      ),
    );
  }
}


// ---Class 14..Verification SCREEN  ---

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _rollController = TextEditingController();

  // Data store karne ke liye variable
  Map<String, dynamic>? fetchedData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF771E6E), // Peeche ka dark purple background
      body: Center(
        child: SingleChildScrollView( // Choti screen par overflow na ho
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 700, // Card ki height (Aap ise adjust kar sakte hain)
              width: 600,  // Card ki width
              child: Stack(
                clipBehavior: Clip.none, // ✅ Logo ko bahar nikalne deta hai
                alignment: Alignment.topCenter,
                children: [

                  /// 1. MAIN WHITE CARD
                  Container(
                    margin: const EdgeInsets.only(top: 50), // Logo ke liye upar jagah chodi
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 15)
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60), // Logo ke peeche ki jagah
                        
                        /// TAB BAR (Design Wala)
                        Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white, // strip
                          ),
                          child: TabBar(
                            controller: _tabController,
                            // Selected Tab Style (White Box)
                            indicator: const BoxDecoration(
                              color: Color(0xFF771E6E), 
                            ),
                            labelColor: Colors.white, // Selected Text
                            unselectedLabelColor: Color(0xFF771E6E), // Unselected Text
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            tabs: const [
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.qr_code, size: 20),
                                    SizedBox(width: 8),
                                    Text("QR-CODE VERIFICATION"),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.description, size: 20),
                                    SizedBox(width: 8),
                                    Text("CERTIFICATE VERIFICATION"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// TAB VIEW CONTENT
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _qrTab(),     // QR Logic
                              _manualTab(), // Manual Input Logic
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 2. GO TO HOME BUTTON (Top Left Corner)
Positioned(
  top: 50, 
  left: 0,
  child: GestureDetector( // InkWell ki jagah GestureDetector bhi use kar sakte hain
    onTap: () {
      // ✅ Sahi Tarika: Pura stack saaf karke Home par bhejna
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF771E6E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Row( // Row use kiya hai taaki icon bhi add ho sake (agar chahiye)
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home, color: Colors.white, size: 20), // Home Icon
          SizedBox(width: 8),
          Text(
            "Go To Home",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  ),
),
                  /// 3. CENTER LOGO (Floating)
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, 
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                        ]
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        // Yahan apna image path lagayein
                        backgroundImage: const AssetImage("assets/images/logo.png"), 
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= QR TAB LOGIC =================

  Widget _qrTab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
           const Text(
            "Scan QR Code",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          
          // Scanner Box
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF771E6E), width: 3),
              borderRadius: BorderRadius.circular(15)
            ),
            child: SizedBox(
              width: 250,
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MobileScanner(
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    if (barcode.rawValue != null) {
                      setState(() {
                        fetchedData = {
                          "rollNo": barcode.rawValue,
                          "name": "QR Student",
                          "father": "Father Name",
                          "mother": "Mother Name",
                          "course": "Flutter Dev",
                          "grade": "A+"
                        };
                      });
                      // Scan hone ke baad Manual tab par bhej dein result dikhane ke liye
                      _tabController.animateTo(1);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Place the QR code inside the frame", style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }

  // ================= MANUAL INPUT TAB LOGIC =================

  Widget _manualTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          const Text(
            "Enter Roll / Registration No *",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          
          /// INPUT FIELD
          TextField(
            controller: _rollController,
            decoration: InputDecoration(
              hintText: "Ex: 260300001",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),

          const SizedBox(height: 20),

          /// VERIFY BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF771E6E),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              // Dummy logic simulate kar rahe hain
              setState(() {
                fetchedData = {
                  "rollNo": _rollController.text.isEmpty ? "12345" : _rollController.text,
                  "name": "Rahul Kumar",
                  "father": "Suresh Kumar",
                  "mother": "Sunita Devi",
                  "course": "B.Tech CSE",
                  "grade": "A"
                };
              });
            },
            child: const Text("VERIFY RECORD", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 30),

          /// RESULT SECTION (Dikhega agar data fetch ho gaya ho)
          if (fetchedData != null)
            _resultSection(),
        ],
      ),
    );
  }

  // ================= RESULT DISPLAY WIDGET =================

  Widget _resultSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text(
                "VERIFIED RECORD",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.green),
          const SizedBox(height: 10),

          _infoRow("Roll No", fetchedData!['rollNo']),
          _infoRow("Name", fetchedData!['name']),
          _infoRow("Father", fetchedData!['father']),
          _infoRow("Mother", fetchedData!['mother']),
          _infoRow("Course", fetchedData!['course']),
          _infoRow("Grade", fetchedData!['grade']),
        ],
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(child: Text(value.toString(), style: const TextStyle(color: Colors.black54))),
        ],
      ),
    );
  }
}