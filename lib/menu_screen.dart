import 'package:myapp/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/profile_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Standard AppBar height
        child: CustomAppBar(title: 'Menu',),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Language'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language tapped')),
              );
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },

          ),
          ListTile(
            title: const Text('Exit'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exit tapped')),
              );
            },
          ),
        ],
      ),
    );
  }
}