import Foundation
import Hummingbird

struct Views {

    // Header HTML commun
    static func head(title: String) -> String {
        return """
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
                <title>\(title) - MiniCrowd</title>
                <style>
                    /* Design Système Premium & Espacements (Whitespace) */
                    :root {
                        --pico-border-radius: 0.75rem;
                        --pico-font-family: system-ui, -apple-system, "SF Pro Display", "Segoe UI", Roboto, Helvetica, sans-serif;
                        --pico-spacing: 1.5rem; /* Espacement de base plus généreux */
                    }

                    /* Theme Clair */
                    [data-theme="light"] {
                        --pico-primary: #0f172a;
                        --pico-primary-hover: #334155;
                        --pico-background-color: #ffffff;
                        --pico-form-element-background-color: #ffffff;
                        --page-bg: #f8fafc;
                        --soft-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
                        --hover-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
                    }

                    /* Theme Sombre */
                    [data-theme="dark"] {
                        --pico-primary: #f8fafc;
                        --pico-primary-hover: #cbd5e1;
                        --pico-background-color: #0f172a;
                        --pico-form-element-background-color: #1e293b;
                        --page-bg: #020617;
                        --soft-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.2);
                        --hover-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.3);
                    }

                    body {
                        background-color: var(--page-bg);
                    }

                    /* Navigation aérée */
                    nav {
                        border-bottom: 1px solid var(--pico-muted-border-color);
                        padding: 1.25rem 0;
                        margin-bottom: 3rem;
                        background-color: var(--pico-background-color);
                    }

                    /* Hero section : Plus de padding, texte plus lisible */
                    .hero {
                        padding: 4rem 2rem;
                        background-color: var(--pico-background-color);
                        border: 1px solid var(--pico-muted-border-color);
                        border-radius: var(--pico-border-radius);
                        margin-bottom: 4rem;
                        box-shadow: var(--soft-shadow);
                        text-align: center;
                    }
                    .hero h1 { font-weight: 800; letter-spacing: -0.03em; margin-bottom: 1rem; }
                    .hero p { font-size: 1.15rem; color: var(--pico-muted-color); margin: 0; line-height: 1.6; }

                    /* Cartes : Structure propre SANS marges négatives */
                    .card {
                        background-color: var(--pico-background-color);
                        border: 1px solid var(--pico-muted-border-color);
                        border-radius: var(--pico-border-radius);
                        box-shadow: var(--soft-shadow);
                        transition: border-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
                        display: flex;
                        flex-direction: column;
                        height: 100%;
                        padding: 0; /* On retire le padding de la carte globale */
                        overflow: hidden; /* Pour que l'image respecte les coins arrondis */
                    }
                    .card:hover {
                        transform: translateY(-4px);
                        box-shadow: var(--hover-shadow);
                        border-color: var(--pico-primary);
                    }
                    
                    /* Contenu de la carte (gère les espaces internes) */
                    .card-body {
                        padding: 1.5rem;
                        display: flex;
                        flex-direction: column;
                        flex-grow: 1;
                    }

                    /* Badges */
                    .badge {
                        display: inline-block;
                        background: var(--page-bg);
                        border: 1px solid var(--pico-muted-border-color);
                        color: var(--pico-color);
                        padding: 0.25rem 0.6rem;
                        border-radius: 6px;
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    /* Barre de filtres : Grid avec espacements gérés par gap */
                    .filter-bar {
                        margin-bottom: 3rem;
                        background-color: var(--pico-background-color);
                        padding: 1.5rem;
                        border-radius: var(--pico-border-radius);
                        border: 1px solid var(--pico-muted-border-color);
                        box-shadow: var(--soft-shadow);
                    }
                    .filter-bar .grid {
                        gap: 1.5rem; /* Espace parfait entre les menus déroulants */
                    }

                    /* Grille de cartes aérée */
                    .grid-cards {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                        gap: 2.5rem; /* Plus d'espace entre les projets */
                    }

                    /* Typographie et barre de progression */
                    .progress-text {
                        display: flex;
                        justify-content: space-between;
                        font-size: 0.85rem;
                        font-weight: 500;
                        margin-bottom: 0.75rem;
                        color: var(--pico-muted-color);
                    }
                    progress { height: 8px; border-radius: 4px; border: none; background-color: var(--pico-muted-border-color); }
                    progress::-webkit-progress-bar { background-color: var(--pico-muted-border-color); }
                    progress::-webkit-progress-value { background-color: var(--pico-primary); border-radius: 4px; }
                    progress::-moz-progress-bar { background-color: var(--pico-primary); border-radius: 4px; }

                    /* Boutons de formulaires intègres */
                    .donate-form {
                        margin: 0;
                        display: flex;
                        gap: 0.75rem;
                        align-items: center;
                    }
                    .donate-form input {
                        margin: 0; /* Enlève la marge basse par défaut de PicoCSS */
                        width: 90px;
                    }
                    .donate-form button {
                        margin: 0;
                    }
                </style>
            </head>
            """
    }

    // Affichage des erreurs
    static func renderError(_ error: String?) -> String {
        guard let error = error else { return "" }
        var msg = error
        if error == "invalid" { msg = "Veuillez remplir tous les champs correctement (L'objectif doit être supérieur à 0)." }
        if error == "invalid_amount" { msg = "Le montant du don doit être valide et supérieur à 0." }
        return """
            <div style="background-color: var(--pico-background-color); border-left: 4px solid #ef4444; padding: 1rem 1.5rem; margin-bottom: 2rem; border-radius: 4px; box-shadow: var(--soft-shadow);">
                <strong>Action requise :</strong> \(msg)
            </div>
            """
    }

    // Le script JavaScript gérant le Dark/Light mode
    static let themeScript = """
    <script>
        const html = document.documentElement;
        const toggle = document.getElementById('theme-toggle');
        const savedTheme = localStorage.getItem('theme') || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
        html.setAttribute('data-theme', savedTheme);
        
        toggle.addEventListener('click', () => {
            const current = html.getAttribute('data-theme');
            const next = current === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
        });
    </script>
    """

    // VUE PRINCIPALE
    static func renderIndex(
        items: [ProjectDetail], categories: [Category], search: String?, sort: String?,
        error: String?
    ) -> HTML {

        let categoriesOptions = categories.map { "<option value=\"\($0.id ?? 0)\">\($0.name)</option>" }.joined()
        let filterCatOptions = categories.map { "<option value='\($0.id ?? 0)'>\($0.name)</option>" }.joined()

        let rows = items.enumerated().map { index, data in
            let p = data
            // let progress = min(100, Int((p.currentAmount / p.goal) * 100))
            let isFunded = p.currentAmount >= p.goal
            let delayClass = (index % 3 == 1) ? "delay-1" : ((index % 3 == 2) ? "delay-2" : "")
            
            let donateHTML = isFunded 
                ? "<div style='display:flex; align-items:center;'><span style='font-weight:700; color: #10b981; font-size: 0.9rem;'>Objectif atteint 🎉</span></div>" 
                : "<form action='/donate/\(p.id)' method='post' style='margin:0; display:flex; gap:0.5rem; align-items: stretch;'><input type='number' name='amount' min='1' step='1' value='10' required style='width: 80px; margin:0;'><button type='submit' style='margin:0;'>Soutenir</button></form>"
            
            return """
                <article class="card animate-fade-up \(delayClass)">
                    <img src="\(p.imageUrl)" alt="\(p.title)" style="width: 100%; height: 200px; object-fit: cover; border-bottom: 1px solid var(--card-border);">
                    <div class="card-body">
                        <header style="margin-bottom: 1rem;">
                            <span style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #6366f1;">\(p.categoryName)</span>
                        </header>
                        <h3 style="margin-bottom: 0.5rem; font-size: 1.25rem; font-weight: 700; letter-spacing: -0.02em;">\(p.title)</h3>
                        <p style="color: var(--pico-muted-color); margin-bottom: 2rem; font-size: 0.95rem; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">\(p.description)</p>
                        
                        <div style="margin-top: auto;">
                            <div class="progress-text">
                                <span>\(p.currentAmount) €</span>
                                <span style="font-weight: 400;">/ \(p.goal) €</span>
                            </div>
                            <progress value="\(p.currentAmount)" max="\(p.goal)"></progress>
                            
                            <hr style="margin: 1.25rem 0; border-color: var(--card-border);">
                            
                            <footer style="display: flex; gap: 0.75rem; align-items: stretch; justify-content: space-between; height: 2.75rem;">
                                <a href="/project/\(p.id)" role="button" class="secondary outline" style="margin: 0; padding: 0 1rem; display: flex; align-items: center; justify-content: center; border: 1px solid var(--card-border); background: var(--page-bg);">Détails</a>
                                \(donateHTML)
                            </footer>
                        </div>
                    </div>
                </article>
                """
        }.joined()

        return HTML(
            content: """
                <!DOCTYPE html>
                <html lang="fr" data-theme="light">
                \(head(title: "Explorer les projets"))
                <body class="container">
                    <nav>
                        <ul><li><strong style="font-size: 1.25rem;">MiniCrowd</strong></li></ul>
                        <ul>
                            <li><a href="/" class="secondary">Explorer</a></li>
                            <li><button id="theme-toggle" class="outline" style="border:none; padding:0.5rem; font-size: 1.25rem; cursor: pointer;" title="Changer de thème">🌓</button></li>
                        </ul>
                    </nav>

                    <div class="hero">
                        <h1>Financez l'innovation.</h1>
                        <p>Découvrez, créez et soutenez les idées de demain grâce au financement participatif.</p>
                    </div>

                    \(renderError(error))

                    <details style="margin-bottom: 3rem;">
                        <summary role="button" class="secondary outline">-Lancer un nouveau projet</summary>
                        <article class="card" style="margin-top: 1rem; padding: 2rem;">
                            <form action="/add" method="post" style="margin: 0;">
                                <div class="grid" style="gap: 1.5rem; margin-bottom: 1.5rem;">
                                    <label>Titre du projet
                                        <input name="title" placeholder="Ex: Mon super jeu vidéo" required style="margin-bottom: 0;">
                                    </label>
                                    <label>Catégorie
                                        <select name="categoryId" required style="margin-bottom: 0;">
                                            <option value="" disabled selected>Choisir une catégorie...</option>
                                            \(categoriesOptions)
                                        </select>
                                    </label>
                                </div>
                                <div style="margin-bottom: 1.5rem;">
                                    <label>Image de couverture (URL)
                                        <input name="imageUrl" type="url" placeholder="https://..." required style="margin-bottom: 0;">
                                    </label>
                                </div>
                                <div style="margin-bottom: 1.5rem;">
                                    <label>Description courte
                                        <input name="description" placeholder="En quelques mots, quel est votre projet ?" required style="margin-bottom: 0;">
                                    </label>
                                </div>
                                <div style="margin-bottom: 2rem;">
                                    <label>Objectif financier (€)
                                        <input name="goal" type="number" step="0.1" placeholder="5000" required style="margin-bottom: 0;">
                                    </label>
                                </div>
                                <button type="submit" style="margin: 0; width: 100%;">Publier le projet</button>
                            </form>
                        </article>
                    </details>

                    <form action="/" method="get" class="filter-bar">
                        <div class="grid">
                            <input type="search" name="search" placeholder="Rechercher par mot-clé..." value="\(search ?? "")" style="margin: 0;">
                            <select name="categoryId" style="margin: 0;">
                                <option value="0">Toutes les catégories</option>
                                \(filterCatOptions)
                            </select>
                            <select name="status" style="margin: 0;">
                                <option value="all">Tous les statuts</option>
                                <option value="ongoing">En cours de financement</option>
                                <option value="funded">Objectif atteint</option>
                            </select>
                            <select name="sort" style="margin: 0;">
                                <option value="newest">Les plus récents</option>
                                <option value="goal">Objectif financier</option>
                                <option value="title">Ordre alphabétique</option>
                            </select>
                        </div>
                        <button type="submit" class="secondary" style="margin-top: 1.5rem; margin-bottom: 0; width: 100%;">Appliquer les filtres</button>
                    </form>

                    <div class="grid-cards">
                        \(items.isEmpty ? "<p style='grid-column: 1/-1; text-align:center; padding: 4rem; background: var(--pico-background-color); border-radius: var(--pico-border-radius); border: 1px dashed var(--pico-muted-border-color); color: var(--pico-muted-color);'>Aucun projet trouvé avec ces critères.</p>" : rows)
                    </div>
                    
                    <footer style="margin-top: 5rem; padding-bottom: 3rem; text-align:center; color: var(--pico-muted-color); font-size: 0.9rem;">
                        Projet CRUD iOS 2026 - Université Paris 8
                    </footer>
                    \(themeScript)
                </body>
                </html>
                """)
    }

    // VUE DE DETAIL ET EDITION
    static func renderDetail(project: ProjectDetail, categories: [Category], error: String?) -> HTML {
        let progress = min(100, Int((project.currentAmount / project.goal) * 100))
        let isFunded = project.currentAmount >= project.goal
        
        let donateHTML = isFunded 
            ? "<div style='background-color: var(--page-bg); border-left: 4px solid #10b981; padding: 1rem 1.5rem; border-radius: 4px;'><strong>🎉 Projet financé !</strong> Les dons sont clôturés.</div>" 
            : "<form action='/donate/\(project.id)' method='post' class='donate-form' style='width:100%;'><input type='number' name='amount' min='1' step='1' value='10' style='flex:1;' required><button type='submit'>Valider le don</button></form>"

        let categoriesOptions = categories.map { c in
            let isSelected = c.id == project.categoryId ? "selected" : ""
            return "<option value=\"\(c.id ?? 0)\" \(isSelected)>\(c.name)</option>"
        }.joined()

        return HTML(
            content: """
                <!DOCTYPE html>
                <html lang="fr" data-theme="light">
                \(head(title: project.title))
                <body class="container">
                    <nav>
                        <ul><li><strong style="font-size: 1.25rem;">MiniCrowd</strong></li></ul>
                        <ul>
                            <li><a href="/" class="secondary">Retour à l'accueil</a></li>
                            <li><button id="theme-toggle" class="outline" style="border:none; padding:0.5rem; font-size: 1.25rem; cursor: pointer;" title="Changer de thème">🌓</button></li>
                        </ul>
                    </nav>

                    \(renderError(error))

                    <article class="card" style="margin-bottom: 3rem;">
                        <img src="\(project.imageUrl)" style="width: 100%; height: 450px; object-fit: cover; border-bottom: 1px solid var(--pico-muted-border-color);">
                        
                        <div class="card-body" style="padding: 3rem;">
                            <header style="margin-bottom: 2.5rem; text-align: center;">
                                <span class="badge" style="margin-bottom: 1rem;">\(project.categoryName)</span>
                                <h1 style="margin: 0; font-size: 2.5rem; letter-spacing: -0.03em;">\(project.title)</h1>
                            </header>
                            
                            <div class="grid" style="gap: 4rem;">
                                <div>
                                    <h4 style="color: var(--pico-muted-color); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 1rem;">À propos du projet</h4>
                                    <p style="font-size: 1.15rem; line-height: 1.7;">\(project.description)</p>
                                    
                                    <div style="margin-top: 3rem; background-color: var(--page-bg); padding: 2rem; border-radius: var(--pico-border-radius); border: 1px solid var(--pico-muted-border-color);">
                                        <h4 style="margin-bottom: 1rem;">Progression actuelle : \(progress)%</h4>
                                        <progress value="\(project.currentAmount)" max="\(project.goal)"></progress>
                                        <p style="margin-top: 1rem; margin-bottom:0; font-size: 1.1rem; color: var(--pico-muted-color);"><strong>\(project.currentAmount) €</strong> récoltés sur un objectif de \(project.goal) €</p>
                                    </div>
                                </div>
                                
                                <div>
                                    <div style="background-color: var(--pico-background-color); padding: 2rem; border-radius: var(--pico-border-radius); border: 1px solid var(--pico-muted-border-color); box-shadow: var(--soft-shadow); margin-bottom: 2rem;">
                                        <h4 style="color: var(--pico-muted-color); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 1.5rem;">Soutenir ce projet</h4>
                                        \(donateHTML)
                                    </div>

                                    <div style="background-color: var(--page-bg); padding: 2rem; border-radius: var(--pico-border-radius); border: 1px dashed #ef4444;">
                                        <h4 style="color: #ef4444; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 1.5rem;">Zone d'administration</h4>
                                        <form action="/delete/\(project.id)" method="post" style="margin:0;">
                                            <button type="submit" class="outline" style="color: #ef4444; border-color: #ef4444; margin:0; width: 100%;">Supprimer définitivement</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </article>

                    <details style="margin-bottom: 5rem;">
                        <summary role="button" class="secondary outline">Éditer les informations du projet</summary>
                        <article class="card" style="margin-top: 1rem; padding: 2rem;">
                            <form action="/project/\(project.id)/edit" method="post" style="margin: 0;">
                                <div class="grid" style="gap: 1.5rem; margin-bottom: 1.5rem;">
                                    <label>Titre du projet
                                        <input name="title" value="\(project.title)" required style="margin-bottom: 0;">
                                    </label>
                                    <label>Catégorie
                                        <select name="categoryId" required style="margin-bottom: 0;">
                                            \(categoriesOptions)
                                        </select>
                                    </label>
                                </div>
                                <div style="margin-bottom: 1.5rem;">
                                    <label>Image de couverture (URL)
                                     <input name="imageUrl" type="url" value="\(project.imageUrl)" required style="margin-bottom: 0;">
                                    </label>
                                </div>
                                <div style="margin-bottom: 1.5rem;">
                                    <label>Description détaillée
                                        <input name="description" value="\(project.description)" required style="margin-bottom: 0;">
                                    </label>
                                </div>
                                <div style="margin-bottom: 2rem;">
                                    <label>Objectif financier (€)
                                        <input name="goal" type="number" step="0.1" value="\(project.goal)" required style="margin-bottom: 0;">
                                    </label>
                                </div>
                                <button type="submit" style="margin: 0; width: 100%;">Mettre à jour le projet</button>
                            </form>
                        </article>
                    </details>
                    
                    \(themeScript)
                </body>
                </html>
                """)
    }
}

// HTML response standard
struct HTML: ResponseGenerator {
    let content: String

    func response(from request: Request, context: some RequestContext) throws -> Response {
        return Response(
            status: .ok,
            headers: [.contentType: "text/html"],
            body: .init(byteBuffer: .init(string: content))
        )
    }
}