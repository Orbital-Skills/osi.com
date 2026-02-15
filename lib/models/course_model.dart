class Course {
  final String sector;
  final String name;
  final String level;
  final String duration;
  final String fee;
  final String eligibility;

  Course({
    required this.sector,
    required this.name,
    required this.level,
    required this.duration,
    required this.fee,
    required this.eligibility,
  });
}

// Data from your HTML
final List<Course> allCourses = [
  Course(sector: "Agriculture", name: "Kisan Drone Operator", level: "4", duration: "6 Months", fee: "5000", eligibility: "10th + Exp"),
  Course(sector: "Apparel", name: "Fashion Designer", level: "5", duration: "1 Year", fee: "5950", eligibility: "12th + Exp"),
  Course(sector: "Automotive", name: "EV Service Technician", level: "4", duration: "1 Year", fee: "6500", eligibility: "ITI/Diploma"),
  Course(sector: "IT-ITES", name: "Web Developer", level: "4", duration: "1 Year", fee: "5000", eligibility: "Graduate/12th"),
  Course(sector: "Healthcare", name: "General Duty Assistant", level: "4", duration: "1 Year", fee: "5500", eligibility: "10th Pass"),
  // ... Baaki courses list view mein dynamically dikhayenge
];