import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
// API URL
const String scriptUrl =
    "https://script.google.com/macros/s/AKfycbwNZgD1IP1BUB7R8XyHTDZP1faQfr-ETJj6n005_ze9pT1D1BofuFBanQWEcmf_G2Dn/exec";

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _rollController = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? studentData;
  String? errorMessage;

  // --- API CALL FUNCTION ---
  Future<void> verifyStudent() async {
    final roll = _rollController.text.trim();
    if (roll.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Roll Number")),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      errorMessage = null;
      studentData = null;
    });

    try {
      final response = await http.get(
        Uri.parse("$scriptUrl?Action=VERIFY&RollNo=$roll"),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        final json = jsonDecode(response.body);

        if (json['Success'] == true) {
          setState(() {
            studentData = Map<String, dynamic>.from(json['Data']);
          });
        } else {
          setState(() {
            errorMessage = "❌ Record Not Found. Please check Roll No.";
          });
        }
      } else {
        setState(() {
          errorMessage = "Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network Error: Check Internet Connection";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // --- UPDATED & POWERFUL URL FIXER ---
  String _getCorrectPhotoUrl(String url) {
  if (url.isEmpty || url == "null") return "";

  final regExp = RegExp(r'[-\w]{25,}');
  final match = regExp.firstMatch(url);

  if (match != null) {
    final id = match.group(0)!;
    return "https://drive.google.com/thumbnail?id=$id&sz=w1000";
  }

  return url;
}

  // --- QR SCANNER OPEN FUNCTION ---
  void _openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    ).then((scannedValue) {
      if (scannedValue != null) {
        _processQRData(scannedValue);
      }
    });
  }

  // --- PROCESS SCANNED DATA ---
  void _processQRData(String data) {
    String finalRoll = data;
    if (data.contains("http") || data.contains("?")) {
      try {
        Uri uri = Uri.parse(data);
        if (uri.queryParameters.containsKey('RollNo')) {
          finalRoll = uri.queryParameters['RollNo']!;
        } else if (uri.queryParameters.containsKey('StudentID')) {
          finalRoll = uri.queryParameters['StudentID']!;
        } else if (uri.queryParameters.containsKey('roll')) {
          finalRoll = uri.queryParameters['roll']!;
        }
      } catch (e) {
        finalRoll = data;
      }
    }
    _rollController.text = finalRoll;
    verifyStudent();
  }

  @override
  Widget build(BuildContext context) {
    final Color themePurple = const Color(0xFF6a1b9a);
    final Color themeBg = const Color(0xFFf4f4f4);

    return Scaffold(
      backgroundColor: themeBg,
      appBar: AppBar(
        title: const Text("Verification Portal"),
        backgroundColor: themePurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- QR SCAN BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openQRScanner,
                icon: const Icon(Icons.qr_code_scanner, size: 28),
                label: const Text("SCAN QR CODE", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),

            const SizedBox(height: 15),

            // --- MANUAL SEARCH SECTION ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.network(
                      "https://raw.githubusercontent.com/Orbital-Skills/osi.com/main/LOGO.png",
                      height: 80,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Certificate Verification",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _rollController,
                      decoration: InputDecoration(
                        labelText: "Enter Roll / Registration No",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : verifyStudent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themePurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text("VERIFY RECORD", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),

            // --- RESULT SECTION ---
            if (studentData != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "VERIFIED STUDENT RECORD",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      // --- PHOTO SECTION START (Always Visible) ---
Center(
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400, width: 2),
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(4),

    child: (studentData!['Photo'] != null &&
            studentData!['Photo'].toString().length > 10)
        ? Builder(
            builder: (context) {
              // -------- DEBUG --------
              final raw = studentData!['Photo'].toString();
              final finalUrl = _getCorrectPhotoUrl(raw);
              print("PHOTO RAW => $raw");
              print("PHOTO FINAL => $finalUrl");
              // -----------------------

              // 🌐 Flutter WEB (CORS safe)
              if (kIsWeb) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // 📸 IMAGE PLACEHOLDER BOX
      Container(
        height: 140,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // 🔁 Emoji (works everywhere)
            Text(
              "🖼️",
              style: TextStyle(fontSize: 42),
            ),
            SizedBox(height: 6),
            Text(
              "Photo Preview\n(Press Open)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 8),

      // 🔗 OPEN IMAGE BUTTON
      ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(finalUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          }
        },
        icon: const Icon(Icons.open_in_new, size: 14),
        label: const Text(
          "Open Image",
          style: TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          minimumSize: const Size(110, 32),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    ],
  );
}


              // 📱 Mobile / Desktop
              return Image.network(
                finalUrl,
                height: 140,
                width: 120,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 140,
                    width: 120,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 140,
                    width: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image,
                            size: 40, color: Colors.red),
                        Text("Error",
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
                },
              );
            },
          )
        : const SizedBox(
            height: 140,
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_box,
                    size: 50, color: Colors.grey),
                Text(
                  "No Photo",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
  ),
),


// --- PHOTO SECTION END ---


                      _buildInfoRow("Roll No:", studentData!['Roll']),
                      _buildInfoRow("Name:", studentData!['Name']),
                      _buildInfoRow("Father Name:", studentData!['Father']),
                      _buildInfoRow("Mother Name:", studentData!['Mother']),
                      _buildInfoRow("Course:", studentData!['Course']),

                      const SizedBox(height: 20),

                      Text("Academic Record",
                          style: TextStyle(
                              color: themePurple, fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      const SizedBox(height: 10),

                      Table(
                        border: TableBorder.all(color: themePurple),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(decoration: const BoxDecoration(color: Colors.white), children: [
                            _tableCell("Subject", isHeader: true, color: themePurple),
                            _tableCell("Max", isHeader: true, color: themePurple),
                            _tableCell("Obt", isHeader: true, color: themePurple),
                            _tableCell("Grd", isHeader: true, color: themePurple),
                          ]),
                          ..._buildSubjectRows(themePurple),
                          TableRow(
                              decoration: BoxDecoration(color: Colors.grey.shade100),
                              children: [
                                _tableCell("Grand Total", isBold: true, color: Colors.green),
                                _tableCell("800", isBold: true, color: Colors.red),
                                _tableCell(studentData!['Total'].toString(), isBold: true, color: themePurple),
                                _tableCell(studentData!['Grade'].toString(), isBold: true, color: themePurple),
                              ])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value?.toString() ?? "-", style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {bool isHeader = false, bool isBold = false, required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 14 : 13,
        ),
      ),
    );
  }

  List<TableRow> _buildSubjectRows(Color color) {
    List<TableRow> rows = [];
    for (int i = 1; i <= 8; i++) {
      String subKey = "Sub$i";
      String markKey = "Mark$i";

      if (studentData![subKey] != null && studentData![subKey].toString().isNotEmpty) {
        rows.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(studentData![subKey].toString(), style: TextStyle(color: color), textAlign: TextAlign.left),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("100", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(studentData![markKey]?.toString() ?? "0", style: TextStyle(color: color), textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(studentData!['Grade']?.toString() ?? "-", style: TextStyle(color: color), textAlign: TextAlign.center),
          ),
        ]));
      }
    }
    return rows;
  }
}

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Certificate QR"), backgroundColor: Colors.black),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              controller.stop();
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
