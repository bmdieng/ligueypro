# Firebase Realtime Database

## 1) Ajouter Firebase au projet Flutter

1. Installer FlutterFire CLI:
   - `dart pub global activate flutterfire_cli`
2. Se connecter a Firebase:
   - `firebase login`
3. Lier le projet Flutter a ton projet Firebase:
   - `flutterfire configure`
4. Lancer:
   - `fvm flutter pub get`

Note: Le code initialise Firebase au demarrage. Sans configuration FlutterFire, l'application reste utilisable en mode local (fallback).

## 2) Structure de donnees recommandee

```json
{
  "home": {
    "categories": {
      "cat1": {"label": "Plombier", "icon": "plumbing"},
      "cat2": {"label": "Electricite", "icon": "bolt"},
      "cat3": {"label": "Menage", "icon": "cleaning_services"}
    }
  },
  "professionals": {
    "Plombier": {
      "pro1": {
        "name": "Mamadou Diop",
        "rating": "⭐ 4.8",
        "distance": "1.2 km",
        "price": "A partir de 5 000 FCFA"
      }
    }
  },
  "requests": {
    "-Nz...": {
      "description": "Mon climatiseur ne refroidit plus",
      "status": "pending",
      "createdAt": 1726398372000
    }
  }
}
```

## 3) Regles minimales (dev)

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

Utiliser ces regles seulement en developpement. En production, limite les acces par authentification.
