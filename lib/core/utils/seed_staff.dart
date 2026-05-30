import 'package:cloud_firestore/cloud_firestore.dart';

/// Run this ONCE to seed the staff collection in Firestore.
/// Call seedStaff() from a temporary button or from main() during dev.
Future<void> seedStaff() async {
  final firestore = FirebaseFirestore.instance;
  final collection = firestore.collection('staff');

  final staffList = [
    // ── Principal ──────────────────────────────────────────────────────────
    {
      'staffId': 'staff_001',
      'name': 'Bill Gates',
      'department': '',
      'role': 'Principal',
      'phone': '+91 9876543200',
      'email': 'bill.gates@college.edu',
      'imageUrl': null,
    },
    // ── HODs ───────────────────────────────────────────────────────────────
    {
      'staffId': 'staff_002',
      'name': 'Sundar Pichai',
      'department': 'Computer Science',
      'role': 'HOD',
      'phone': '+91 9876543201',
      'email': 'sundar.pichai@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_003',
      'name': 'Satya Nadella',
      'department': 'Information Technology',
      'role': 'HOD',
      'phone': '+91 9876543202',
      'email': 'satya.nadella@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_004',
      'name': 'Jensen Huang',
      'department': 'ENTC',
      'role': 'HOD',
      'phone': '+91 9876543203',
      'email': 'jensen.huang@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_005',
      'name': 'Tim Cook',
      'department': 'Instrumentation',
      'role': 'HOD',
      'phone': '+91 9876543204',
      'email': 'tim.cook@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_006',
      'name': 'Mark Zuckerberg',
      'department': 'Electrical',
      'role': 'HOD',
      'phone': '+91 9876543205',
      'email': 'mark.zuckerberg@college.edu',
      'imageUrl': null,
    },
    // ── Faculty ────────────────────────────────────────────────────────────
    {
      'staffId': 'staff_007',
      'name': 'Elon Musk',
      'department': 'Computer Science',
      'role': 'Faculty',
      'phone': '+91 9876543206',
      'email': 'elon.musk@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_008',
      'name': 'Larry Page',
      'department': 'Computer Science',
      'role': 'Faculty',
      'phone': '+91 9876543207',
      'email': 'larry.page@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_009',
      'name': 'Sergey Brin',
      'department': 'Information Technology',
      'role': 'Faculty',
      'phone': '+91 9876543208',
      'email': 'sergey.brin@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_010',
      'name': 'Steve Wozniak',
      'department': 'Information Technology',
      'role': 'Faculty',
      'phone': '+91 9876543209',
      'email': 'steve.wozniak@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_011',
      'name': 'Jeff Bezos',
      'department': 'ENTC',
      'role': 'Faculty',
      'phone': '+91 9876543210',
      'email': 'jeff.bezos@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_012',
      'name': 'Sam Altman',
      'department': 'ENTC',
      'role': 'Faculty',
      'phone': '+91 9876543211',
      'email': 'sam.altman@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_013',
      'name': 'Linus Torvalds',
      'department': 'Instrumentation',
      'role': 'Faculty',
      'phone': '+91 9876543212',
      'email': 'linus.torvalds@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_014',
      'name': 'Guido van Rossum',
      'department': 'Instrumentation',
      'role': 'Faculty',
      'phone': '+91 9876543213',
      'email': 'guido.vanrossum@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_015',
      'name': 'Susan Wojcicki',
      'department': 'Electrical',
      'role': 'Faculty',
      'phone': '+91 9876543214',
      'email': 'susan.wojcicki@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_016',
      'name': 'Shantanu Narayen',
      'department': 'Electrical',
      'role': 'Faculty',
      'phone': '+91 9876543215',
      'email': 'shantanu.narayen@college.edu',
      'imageUrl': null,
    },
    // ── Staff ──────────────────────────────────────────────────────────────
    {
      'staffId': 'staff_017',
      'name': 'Steve Jobs',
      'department': 'Computer Science',
      'role': 'Staff',
      'phone': '+91 9876543216',
      'email': 'steve.jobs@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_018',
      'name': 'Jack Dorsey',
      'department': 'Information Technology',
      'role': 'Staff',
      'phone': '+91 9876543217',
      'email': 'jack.dorsey@college.edu',
      'imageUrl': null,
    },
    // ── Security ───────────────────────────────────────────────────────────
    {
      'staffId': 'staff_019',
      'name': 'Ada Lovelace',
      'department': '',
      'role': 'Security',
      'phone': '+91 9876543218',
      'email': 'security1@college.edu',
      'imageUrl': null,
    },
    {
      'staffId': 'staff_020',
      'name': 'Alan Turing',
      'department': '',
      'role': 'Security',
      'phone': '+91 9876543219',
      'email': 'security2@college.edu',
      'imageUrl': null,
    },
  ];

  final batch = firestore.batch();
  for (final staff in staffList) {
    final docRef = collection.doc(staff['staffId'] as String);
    batch.set(docRef, staff);
  }
  await batch.commit();
}
