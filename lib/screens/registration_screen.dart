import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../services/api_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _fatherCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _selectedCourse = "Electrician";
  File? _imageFile;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<String?> _compressAndBase64(File file) async {
    // Basic compression logic
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload photo")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final String? photoBase64 = await _compressAndBase64(_imageFile!);
      
      // JSON Construction matched to index.html logic
      final data = {
        "Action": "FULL_SAVE", // Important for Script
        "FullName": _nameCtrl.text,
        "FatherMotherName": _fatherCtrl.text,
        "Mobile": _mobileCtrl.text,
        "Email": _emailCtrl.text,
        "Address": _addressCtrl.text,
        "CourseSelected": _selectedCourse,
        "PhotoBase64": photoBase64,
        "PhotoMime": "image/jpeg",
        "PhotoFilename": "mobile_upload.jpg",
        "StudentID": "OSD-${DateTime.now().millisecondsSinceEpoch}" // Temp ID generation
      };

      final api = ApiService();
      final success = await api.registerStudent(data);

      if (mounted) {
        if (success) {
          showDialog(context: context, builder: (_) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Registration Successful!"),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back
              }, child: const Text("OK"))
            ],
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to submit. Try again.")));
        }
      }
    } catch (e) {
       print(e);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fatherCtrl,
                decoration: const InputDecoration(labelText: "Father's Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mobileCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Mobile", border: OutlineInputBorder()),
              ),
               const SizedBox(height: 10),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedCourse,
                items: ["Electrician", "Fitter", "Plumber", "Health Care", "IT-ITES"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _selectedCourse = v!),
                decoration: const InputDecoration(labelText: "Select Course", border: OutlineInputBorder()),
              ),
               const SizedBox(height: 20),
               
               // Image Picker
               InkWell(
                 onTap: _pickImage,
                 child: Container(
                   height: 150,
                   width: double.infinity,
                   decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                   child: _imageFile == null 
                     ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, size: 50), Text("Tap to upload photo")])
                     : Image.file(_imageFile!, fit: BoxFit.contain),
                 ),
               ),

               const SizedBox(height: 20),
               SizedBox(
                 width: double.infinity,
                 height: 50,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F0A5A)),
                   onPressed: _isSubmitting ? null : _submit,
                   child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text("SUBMIT FORM", style: TextStyle(color: Colors.white)),
                 ),
               )
            ],
          ),
        ),
      ),
    );
  }
}