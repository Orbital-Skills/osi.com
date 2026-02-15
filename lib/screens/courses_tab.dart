import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Courses"), backgroundColor: const Color(0xFF4F0A5A), foregroundColor: Colors.white,),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: allCourses.length,
        itemBuilder: (context, index) {
          final c = allCourses[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFF2CFEE),
                child: Text(c.sector[0], style: const TextStyle(color: Color(0xFF4F0A5A))),
              ),
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${c.sector} | Level ${c.level}"),
                  Text("Fee: ₹${c.fee} | Duration: ${c.duration}", style: const TextStyle(color: Colors.green)),
                ],
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F0A5A)),
                onPressed: () {
                  // Show details dialog (logic similar to HTML modal)
                  showDialog(context: context, builder: (_) => AlertDialog(
                    title: Text(c.name),
                    content: Text("Eligibility: ${c.eligibility}\n\nPay Fee via UPI to enroll."),
                    actions: [
                      TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("Close")),
                      FilledButton(onPressed: (){}, child: const Text("Pay Now")),
                    ],
                  ));
                },
                child: const Text("Apply", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}