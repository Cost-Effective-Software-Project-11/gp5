import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gp5/screens/doctor_trials/doctor_trials_button.dart';
import 'package:flutter_gp5/screens/patient_trials/patient_trials_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  static const double _dividerThickness = 2.0;
  static FirebaseAuth user = FirebaseAuth.instance;

  static Future<DocumentSnapshot<Map<String, dynamic>>> userDoc = FirebaseFirestore.instance
          .collection('doctors')
          .doc(user.currentUser?.uid)
          .get();

  Future<Map<String, dynamic>> processData() async {
    DocumentSnapshot snapshot = await userDoc;
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    return userData;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        elevation: 4.00,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrialsButton(context),
              _customDivider(
                thickness: _dividerThickness,
              ),
              // Add validation if the user is a doctor to see this button:
              FutureBuilder<Map<String, dynamic>>(
                future: processData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!['Doctor']) {
                    return _buildCreateTrialsButton(context);
                  } else {
                    return Container();
                  }
                },
              ),
              _customDivider(
                thickness: _dividerThickness,
              ),
              // Add Help Button here:
              const Text("Help"),
              _customDivider(
                thickness: _dividerThickness,
              ),
              // Add Setting Button here:
              const Text("Setting"),
              _customDivider(
                thickness: _dividerThickness,
              ),
              // Add Info Button here:
              const Text("Info"),
            ],
          ),
        ),
      ),
    );
  }

  //Patient Trials button
  Widget _buildTrialsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PatientTrialsScreen()),
        );
      },
      child: Text(
        'Trials',
        style: TextStyle(
          fontSize: 20,
          inherit: true,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

//Doctor Trials button
  Widget _buildCreateTrialsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorTrialsScreen()),
        );
      },
      child: Text(
        'Create Trial',
        style: TextStyle(
          fontSize: 20,
          inherit: true,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

//Custom divider
  Divider _customDivider({
    double thickness = 0.0,
    Color color = Colors.black,
    double indent = 0.0,
    double endIndent = 0.0,
    double height = 0.0,
  }) {
    return Divider(
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
      height: height,
    );
  }
}