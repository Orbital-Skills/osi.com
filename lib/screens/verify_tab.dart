import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VerifyTab extends StatefulWidget {
  const VerifyTab({super.key});

  @override
  State<VerifyTab> createState() => _VerifyTabState();
}

class _VerifyTabState extends State<VerifyTab> {
  final _rollCtrl = TextEditingController();
  Map<String, dynamic>? _result;
  bool _isLoading = false;

  Future<void> _verify() async {
    setState(() => _isLoading = true);
    final api = ApiService();
    // Using verify.html logic
    final data = await api.verifyByRoll(_rollCtrl.text);
    setState(() {
      _isLoading = false;
      _result = data.containsKey('Success') && data['Success'] ? data['Data'] : null;
    });
    
    if (_result == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Record Not Found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Certificate Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             TextField(
              controller: _rollCtrl,
              decoration: const InputDecoration(
                labelText: "Enter Roll No / Registration ID",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _isLoading ? null : _verify, child: const Text("VERIFY RECORD")),
            
            if (_result != null) ...[
              const SizedBox(height: 20),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 50),
                      const Text("VERIFIED", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      const Divider(),
                      _row("Name", _result!['Name']),
                      _row("Father", _result!['Father']),
                      _row("Course", _result!['Course']),
                      _row("Grade", _result!['Grade']),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
  
  Widget _row(String k, String? v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(k, style: const TextStyle(fontWeight: FontWeight.bold)), Text(v ?? "-")],
      ),
    );
  }
}