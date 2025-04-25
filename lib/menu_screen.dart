import 'package:flutter/foundation.dart';
import 'package:recipeShare/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipeShare/language_provider.dart';
import 'package:recipeShare/app_localizations.dart';
import 'package:recipeShare/profile_screen.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize:
              Size.fromHeight(kToolbarHeight), // Standard AppBar height
          child: CustomAppBar(
            title: 'Menu',
          ),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Language'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguageScreen()),
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
                  //close app
                  const SnackBar(content: Text('Exit tapped')),
                );
              },
            ),
          ],
        ),
      );
  }
}

class LanguageScreen extends StatelessWidget {

  const LanguageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final supportedLocales = languageProvider.getSupportedLanguages();
    final languages = supportedLocales.values.toList();
    final locales = supportedLocales.keys.toList();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight), // Standard AppBar height
        child: CustomAppBar(title: 'Languages'),
      ),
      body: ListView.builder(
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          final languageName = languages[index] ?? 'Unknown';
          return  ListTile(
            title: Text(languageName),
            onTap: () {
              Provider.of<LanguageProvider>(context, listen: false).setLocale(Locale(locales[index]));
               Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}