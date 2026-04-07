#  MiniCrowd - Plateforme de Financement Participatif

MiniCrowd est une application web de crowdfunding développée en **Swift** côté serveur (avec le framework Hummingbird). Elle permet de découvrir, financer et gérer des projets innovants à travers une interface utilisateur moderne et réactive.

Ce projet a été réalisé dans le cadre du cours de développement (Projet CRUD iOS 2026) à l'**Université Paris 8**.

---

##  Comment ça fonctionne ?

L'application simule une plateforme de type "Kickstarter". Les utilisateurs peuvent :
1. **Explorer** des projets en cours de financement avec un système de filtres (par catégorie, statut, recherche textuelle).
2. **Créer** de nouveaux projets en fournissant un titre, une description, une image de couverture (URL) et un objectif financier.
3. **Soutenir** des projets en effectuant des dons fictifs. La barre de progression se met à jour en temps réel et se bloque automatiquement à 100%.
4. **Administrer** la plateforme en éditant les informations d'un projet existant ou en le supprimant définitivement de la base de données.

---

##  Liste des routes exposées (API / Navigation)

L'application repose sur le framework Hummingbird et expose les routes HTTP suivantes :

###  Lecture (Read)
* `GET /` : Affiche la page d'accueil avec la liste de tous les projets, la barre de recherche et les filtres.
* `GET /project/:id` : Affiche la page de détail d'un projet spécifique (ainsi que son interface d'administration).

###  Création & Mise à jour (Create, Update)
* `POST /add` : Reçoit les données du formulaire de la page d'accueil et crée un nouveau projet dans la base de données.
* `POST /project/:id/edit` : Met à jour les informations d'un projet existant (titre, image, description, objectif, catégorie).
* `POST /donate/:id` : Ajoute un montant au financement actuel d'un projet (s'il n'a pas encore atteint son objectif).

### Suppression (Delete)
* `POST /delete/:id` : Supprime définitivement un projet de la base de données.

---

## Fonctionnalités UI/UX & Design

- **UI Premium (Pixel Perfect)** : Interface moderne, aérée et responsive basée sur **PicoCSS**.
- **Animations** : Apparition fluide des éléments (Fade-up) au chargement.
- **Thème Dynamique** : Bascule **Mode Sombre / Mode Clair** (Dark/Light mode) persistante avec JavaScript.

---

## Installation & Utilisation

### Prérequis
- Swift installé sur votre machine (ou environnement GitHub Codespaces).
- Un terminal.

### Instructions de lancement

1. **Cloner le dépôt** (ou ouvrir le Codespace) :
   ```bash
   git clone <ton-lien-github>
   cd MiniCrowd_V2