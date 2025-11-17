import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    name.text = snap['name'];
    phone.text = snap['phone'];
    bio.text = snap['bio'];
  }

  void save() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      "name": name.text.trim(),
      "phone": phone.text.trim(),
      "bio": bio.text.trim(),
    });

    Navigator.pop(context); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: "Name"),
            ),

            SizedBox(height: 15),

            TextField(
              controller: phone,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: "Phone"),
            ),

            SizedBox(height: 15),

            TextField(
              controller: bio,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(labelText: "Bio"),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: save, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}
