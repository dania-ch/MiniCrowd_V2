# MiniCrowd - Crowdfunding App

**SwiftFund** est une application web de financement participatif (Crowdfunding) développée en Swift côté serveur avec le framework Hummingbird 2 et SQLite. Elle permet aux utilisateurs de découvrir, créer, modifier, soutenir et supprimer des projets de financement.

## Fonctionnalités (Bonus intégrés)
Afin d'aller plus loin que les exigences initiales, ce projet inclut plusieurs bonus :
- **Deuxième modèle de données** : Gestion de `Category` reliées aux projets (One-to-Many).
- **Recherche & Tri** : Barre de recherche dynamique et tri par objectifs/noms/récence.
- **Page de détails** : Vue dédiée pour chaque projet avec formulaire de mise à jour complet.
- **Validation serveur** : Gestion des erreurs (montants négatifs, champs vides) avec alertes UI.
- **Amélioration UI/UX** : Surcharge de PicoCSS pour un design moderne (glassmorphism, grilles, `<progress>`).

## Routes de l'API

| Méthode | Route | Description |
| :--- | :--- | :--- |
| **GET** | `/` | Affiche la liste de tous les projets avec filtres, recherche et formulaire de création. |
| **GET** | `/project/:id` | Affiche les détails d'un projet spécifique et son formulaire d'édition. |
| **POST** | `/add` | Crée un nouveau projet dans la base de données. |
| **POST** | `/project/:id/edit`| Met à jour les informations d'un projet existant. |
| **POST** | `/donate/:id` | Ajoute un montant dynamique à la cagnotte d'un projet. |
| **POST** | `/delete/:id` | Supprime définitivement un projet. |

## Instructions d'exécution
Ce projet est conçu pour s'exécuter dans GitHub Codespaces.
1. Ouvrez le terminal.
2. Lancez le script de build : `./build.sh`
3. Lancez le script d'exécution : `./run.sh`
4. Accédez à l'application via le port transféré (par défaut `http://localhost:8080`).