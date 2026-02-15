import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiService {
  
  // Login / Fetch Status (Matches login.html fetchStatus logic)
  Future<Map<String, dynamic>> fetchStudentStatus(String studentId) async {
    try {
      // Script expects POST with Action: FETCH_STATUS
      final response = await http.post(
        Uri.parse(AppConstants.scriptUrl),
        body: jsonEncode({
          "Action": "FETCH_STATUS",
          "StudentID": studentId
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 302) {
         // Handle redirects if script returns HTML redirect
         if(response.body.contains("Found")) {
            return jsonDecode(response.body);
         }
         // Fallback decoding
         try {
           return jsonDecode(response.body);
         } catch(e) {
           return {"Found": false, "Error": "Invalid JSON"};
         }
      }
      return {"Found": false, "Error": "Server Error"};
    } catch (e) {
      return {"Found": false, "Error": e.toString()};
    }
  }

  // Registration (Matches index.html logic)
  Future<bool> registerStudent(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.registerWebhook),
        // Apps Script expects text/plain for CORS sometimes, but json is standard
        headers: {'Content-Type': 'text/plain;charset=utf-8'}, 
        body: jsonEncode(data),
      );
      
      // Google Script returns 302 Found often on success, or 200 with text
      return response.statusCode == 200 || response.statusCode == 302;
    } catch (e) {
      print("Reg Error: $e");
      return false;
    }
  }

  // Verification by Roll No (Matches verify.html)
  Future<Map<String, dynamic>> verifyByRoll(String roll) async {
    final uri = Uri.parse("${AppConstants.scriptUrl}?Action=VERIFY&RollNo=$roll");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Verify Error: $e");
    }
    return {"Success": false};
  }
}