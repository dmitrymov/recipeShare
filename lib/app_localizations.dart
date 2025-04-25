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
      'myRecipes': 'My Recipes',
      'menu':'Menu',
      'language':'Language',
      'exit':'Exit',
      'languages':'Languages',
      'addNewCategory':'Add New Category',
      'categoryName':'Category Name',
      'cancel':'Cancel',
      'add':'Add',
      'noCategoriesAddedYet':'No categories added yet.',
      'failedToAddCategory':'Failed to add category.',
      'categoryNameCannotBeEmpty':'Category name cannot be empty.',
    },
    'es': {
      'Home':'Inicio',
      'Categories':'Categorías',
      'Profile':'Perfil',
      'Add Recipe':'Añadir Receta',
      'Edit Recipe':'Editar Receta',
      'Recipe Details':'Detalles de la Receta',
      'myRecipes':'Mis Recetas',
      'menu':'Menú',
      'language':'Idioma',
      'exit':'Salir',
      'languages':'Idiomas',
      'addNewCategory':'Añadir Nueva Categoría',
      'categoryName':'Nombre de Categoría',
      'cancel':'Cancelar',
      'add':'Añadir',
      'noCategoriesAddedYet':'Aún no hay categorías añadidas.',
      'failedToAddCategory':'Error al añadir la categoría.',
      'categoryNameCannotBeEmpty':'El nombre de la categoría no puede estar vacío.',
    },
    'fr': {
      'Home':'Accueil',
      'Categories':'Catégories',
      'Profile':'Profil',
      'Add Recipe':'Ajouter une Recette',
      'Edit Recipe':'Modifier la Recette',
      'Recipe Details':'Détails de la Recette',
      'myRecipes':'Mes Recettes',
      'menu':'Menu',
      'language':'Langue',
      'exit':'Quitter',
      'languages':'Langues',
      'addNewCategory':'Ajouter une nouvelle catégorie',
      'categoryName':'Nom de la catégorie',
      'cancel':'Annuler',
      'add':'Ajouter',
      'noCategoriesAddedYet':'Aucune catégorie ajoutée pour le moment.',
      'failedToAddCategory':'Échec de l\'ajout de la catégorie.',
      'categoryNameCannotBeEmpty':'Le nom de la catégorie ne peut pas être vide.',
    },
    'de': {
      'Home':'Startseite',
      'Categories':'Kategorien',
      'Profile':'Profil',
      'Add Recipe':'Rezept Hinzufügen',
      'Edit Recipe':'Rezept Bearbeiten',
      'Recipe Details':'Rezeptdetails',
      'myRecipes':'Meine Rezepte',
      'menu':'Menü',
      'language':'Sprache',
      'exit':'Verlassen',
      'languages':'Sprachen',
      'addNewCategory':'Neue Kategorie hinzufügen',
      'categoryName':'Kategoriename',
      'cancel':'Abbrechen',
      'add':'Hinzufügen',
      'noCategoriesAddedYet':'Noch keine Kategorien hinzugefügt.',
      'failedToAddCategory':'Kategorie konnte nicht hinzugefügt werden.',
      'categoryNameCannotBeEmpty':'Der Kategoriename darf nicht leer sein.',
    },
    'he': {
      'Home':'בית',
      'Categories':'קטגוריות',
      'Profile':'פרופיל',
      'Add Recipe':'הוסף מתכון',
      'Edit Recipe':'ערוך מתכון',
      'Recipe Details':'פרטי המתכון',
      'myRecipes':'המתכונים שלי',
      'menu':'תפריט',
      'language':'שפה',
      'exit':'יציאה',
      'languages':'שפות',
      'addNewCategory':'הוסף קטגוריה חדשה',
      'categoryName':'שם קטגוריה',
      'cancel':'בטל',
      'add':'הוסף',
      'noCategoriesAddedYet':'לא נוספו קטגוריות עדיין.',
      'failedToAddCategory':'הוספת הקטגוריה נכשלה.',
      'categoryNameCannotBeEmpty':'שם הקטגוריה לא יכול להיות ריק.',
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

  String get menu {
    return lookup('menu');
  }
  String get language {
    return lookup('language');
  }
  String get exit {
    return lookup('exit');
  }
   String get languages {
    return lookup('languages');
  }
  List<String> get getLanguages{
    return _localizedValues.keys.toList();
  } 
  String get addNewCategory {
    return lookup('addNewCategory');
  }

  String get categoryName {
    return lookup('categoryName');
  }

  String get cancel {
    return lookup('cancel');
  }

  String get add {
    return lookup('add');
  }

  String get noCategoriesAddedYet {
    return lookup('noCategoriesAddedYet');
  }

  String get failedToAddCategory {
    return lookup('failedToAddCategory');
  }

  String get categoryNameCannotBeEmpty {
    return lookup('categoryNameCannotBeEmpty');
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