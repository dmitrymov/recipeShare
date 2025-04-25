import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'Home': 'Home',
      'Categories': 'Categories',
      'Profile': 'Profile',
      'Add Recipe': 'Add Recipe',
      'Edit Recipe': 'Edit Recipe',
      'Recipe Details': 'Recipe Details',
      'My Recipes': 'My Recipes',
    },
    'es': {
      'Home': 'Inicio',
      'Categories': 'Categorías',
      'Profile': 'Perfil',
      'Add Recipe': 'Añadir Receta',
      'Edit Recipe': 'Editar Receta',
      'Recipe Details': 'Detalles de la Receta',
      'My Recipes': 'Mis Recetas',
    },
    'fr': {
      'Home': 'Accueil',
      'Categories': 'Catégories',
      'Profile': 'Profil',
      'Add Recipe': 'Ajouter une Recette',
      'Edit Recipe': 'Modifier la Recette',
      'Recipe Details': 'Détails de la Recette',
      'My Recipes': 'Mes Recettes',
    },
    'de': {
      'Home': 'Startseite',
      'Categories': 'Kategorien',
      'Profile': 'Profil',
      'Add Recipe': 'Rezept Hinzufügen',
      'Edit Recipe': 'Rezept Bearbeiten',
      'Recipe Details': 'Rezeptdetails',
      'My Recipes': 'Meine Rezepte',
    },
    'he': {
      'Home': 'בית',
      'Categories': 'קטגוריות',
      'Profile': 'פרופיל',
      'Add Recipe': 'הוסף מתכון',
      'Edit Recipe': 'ערוך מתכון',
      'Recipe Details': 'פרטי המתכון',
      'My Recipes': 'המתכונים שלי',
    },
  };

  String get home {
    return lookup('Home');
  }

  String get categories {
    return lookup('Categories');
  }

  String get profile {
    return lookup('Profile');
  }

  String get addRecipe {
    return lookup('Add Recipe');
  }

  String get editRecipe {
    return lookup('Edit Recipe');
  }

  String get recipeDetails {
    return lookup('Recipe Details');
  }

  String get myRecipes {
    return lookup('My Recipes');
  }

  List<String> get getLanguages{
    return _localizedValues.keys.toList();
  }
  
  String lookup(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr', 'de', 'he'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}