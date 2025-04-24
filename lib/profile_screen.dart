import 'package:flutter/material.dart';
import 'package:recipeShare/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  
  // Simulate user registration status
  final bool isRegistered = false; // Replace with actual logic later

  const ProfileScreen({super.key});

  Future<void> _loginWithGmail(BuildContext context) async {
    // TODO: Implement Gmail login functionality
    print('Logging in with Gmail...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gmail login initiated (not implemented).')),
    );
    // After successful login, you would typically update the UI to show profile info
  }

  Future<void> _removeProfile(BuildContext context) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Remove Profile'),
          content: const Text('Are you sure you want to remove your profile? All your data will be lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // TODO: Implement profile removal logic (e.g., clear local data, sign out)
      print('Removing profile...');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile removed (not fully implemented).')),
      );
      // After removal, you might want to navigate the user back to the home screen or a login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppBar(
        title: 'User Profile',
       ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             if (!isRegistered) 
               ...[
                const Center(
                  child: Text(
                    'Not registered yet.',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _loginWithGmail(context),
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('Login with Gmail'),
                  ),
                ),
              ]
            else
             ...[
                const Center(
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
                  ),
                ),
                const SizedBox(height: 24.0),
                const Center(
                  child: Text(
                    'John Doe', // Replace with actual user name
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Account ID',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: 'user12345'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Info',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Some interesting information about the user can be displayed here. This could include their favorite cuisines, dietary preferences, or anything they want to share.', // Replace with actual user info
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'URL',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                InkWell(
                onTap: () {
                  // TODO: Implement URL launching
                  print('URL tapped');
                },
                child: const Text(
                  'https://example.com/profile', // Replace with actual user URL
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
               ),
                ),
              ],
           
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () => _removeProfile(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Remove Profile', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
          ),
      ),
    );
  }
}