import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        elevation: 4.00,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthenticationRepository>().logOut();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTrialsButton(context),
            _customDivider(thickness: 2.0),
            _buildCreateTrialsButton(context),
            _customDivider(thickness: 2.0),
            const Text("Help", textAlign: TextAlign.center),
            _customDivider(thickness: 2.0),
            _buildSettingsButton(context),
            _customDivider(thickness: 2.0),
            const Text("Info", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildTrialsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.trials);
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

  Widget _buildSettingsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.appSettings);
      },
      child: Text(
        'Settings',
        style: TextStyle(
          fontSize: 20,
          inherit: true,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade900,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCreateTrialsButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.createTrials);
      },
      child: Text(
        'Create Trials',
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