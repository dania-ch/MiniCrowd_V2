import Hummingbird
import Foundation

struct Views {
    
    // Header HTML commun
    static func head(title: String) -> String {
        return """
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
            <title>\(title) - CrowdFunding</title>
            <style>
                :root { --pico-primary: #10B981; --pico-primary-hover: #059669; }
                .hero { padding: 3rem 0; text-align: center; background: linear-gradient(135deg, #1f2937, #111827); color: white; border-radius: 12px; margin-bottom: 2rem; }
                .card { border: 1px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: transform 0.2s, box-shadow 0.2s; background: var(--pico-background-color); }
                .card:hover { transform: translateY(-4px); box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1); }
                .badge { background: #e0f2fe; color: #0284c7; padding: 0.2rem 0.6rem; border-radius: 9999px; font-size: 0.8rem; font-weight: bold; }
                .grid-cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; }
                .progress-text { display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 0.5rem; color: var(--pico-muted-color); }
                progress { border-radius: 8px; height: 10px; }
                progress::-webkit-progress-value { background-color: var(--pico-primary); border-radius: 8px; }
                .error-box { background-color: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 1rem; margin-bottom: 1.5rem; border-radius: 4px; }
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
        return "<div class='error-box'>Erreur! <strong>Erreur:</strong> \(msg)</div>"
    }

    // VUE PRINCIPALE
    static func renderIndex(items: [ProjectDetail], categories: [Category], search: String?, sort: String?, error: String?) -> HTML {
        
        let categoriesOptions = categories.map { "<option value=\"\($0.id ?? 0)\">\($0.name)</option>" }.joined()
        
        let rows = items.map { p in
            let progress = min(100, Int((p.currentAmount / p.goal) * 100))
            return """
            <article class="card">
                <header style="margin-bottom: 0.5rem;">
                    <span class="badge">\(p.categoryName)</span>
                </header>
                <h3 style="margin-bottom: 0.5rem;">\(p.title)</h3>
                <p style="color: var(--pico-muted-color); margin-bottom: 1.5rem;">\(p.description)</p>
                
                <div class="progress-text">
                    <span><strong>\(p.currentAmount) €</strong> collectés</span>
                    <span>Objectif: \(p.goal) €</span>
                </div>
                <progress value="\(p.currentAmount)" max="\(p.goal)"></progress>
                
                <footer style="margin-top: 1.5rem; display: flex; gap: 0.5rem;">
                    <a href="/project/\(p.id)" role="button" class="outline" style="flex: 1; text-align: center;">Détails & Édition</a>
                    <form action="/donate/\(p.id)" method="post" style="margin:0; display:flex; gap:0.5rem;">
                        <input type="number" name="amount" min="1" step="1" value="10" style="width: 90px; margin:0;" required>
                        <button type="submit" style="margin:0;">Donner</button>
                    </form>
                </footer>
            </article>
            """
        }.joined()

        return HTML(content: """
        <!DOCTYPE html>
        <html data-theme="light">
        \(head(title: "Accueil"))
        <body class="container">
            <nav>
                <ul><li><strong>MiniCrowd</strong></li></ul>
                <ul><li><a href="/" class="secondary">Accueil</a></li></ul>
            </nav>

            <div class="hero">
                <h1>Financez les projets de demain</h1>
                <p>Découvrez, créez et soutenez des idées exceptionnelles.</p>
            </div>

            \(renderError(error))

            <details>
                <summary role="button" class="secondary outline">➕ Lancer un nouveau projet</summary>
                <article>
                    <form action="/add" method="post">
                        <div class="grid">
                            <input name="title" placeholder="Titre du projet" required>
                            <select name="categoryId" required>
                                <option value="" disabled selected>Catégorie</option>
                                \(categoriesOptions)
                            </select>
                        </div>
                        <input name="description" placeholder="Courte description" required>
                        <input name="goal" type="number" step="0.1" placeholder="Objectif financier (€)" required>
                        <button type="submit">Créer mon projet</button>
                    </form>
                </article>
            </details>

            <hr>

            <form action="/" method="get" class="grid" style="margin-bottom: 2rem;">
                <input type="search" name="search" placeholder="Rechercher un projet..." value="\(search ?? "")">
                <select name="sort" onchange="this.form.submit()">
                    <option value="newest" \(sort == "newest" ? "selected" : "")>Plus récents</option>
                    <option value="goal" \(sort == "goal" ? "selected" : "")>Objectif le plus haut</option>
                    <option value="title" \(sort == "title" ? "selected" : "")>Ordre alphabétique</option>
                </select>
                <button type="submit" class="outline">Filtrer</button>
            </form>

            <div class="grid-cards">
                \(items.isEmpty ? "<p style='grid-column: 1/-1; text-align:center;'>Aucun projet trouvé.</p>" : rows)
            </div>
            
            <footer style="margin-top: 3rem; text-align:center; color: var(--pico-muted-color);">
                <small>Projet CRUD iOS 2026 - Université Paris 8</small>
            </footer>
        </body>
        </html>
        """)
    }

    // VUE DE DÉTAIL ET ÉDITION (Bonus)
    static func renderDetail(project: ProjectDetail, categories: [Category], error: String?) -> HTML {
        let progress = min(100, Int((project.currentAmount / project.goal) * 100))
        
        let categoriesOptions = categories.map { c in
            let isSelected = c.id == project.categoryId ? "selected" : ""
            return "<option value=\"\(c.id ?? 0)\" \(isSelected)>\(c.name)</option>"
        }.joined()

        return HTML(content: """
        <!DOCTYPE html>
        <html data-theme="light">
        \(head(title: project.title))
        <body class="container">
            <nav>
                <ul><li><strong>MiniCrowd</strong></li></ul>
                <ul><li><a href="/" class="secondary">Retour aux projets</a></li></ul>
            </nav>

            \(renderError(error))

            <article class="card">
                <header>
                    <span class="badge">\(project.categoryName)</span>
                    <h2 style="margin-top: 0.5rem; margin-bottom: 0;">\(project.title)</h2>
                </header>
                
                <div class="grid">
                    <div>
                        <h4>À propos</h4>
                        <p>\(project.description)</p>
                        
                        <div style="background: #f8fafc; padding: 1rem; border-radius: 8px; margin-top: 1rem;">
                            <h4>Progression : \(progress)%</h4>
                            <progress value="\(project.currentAmount)" max="\(project.goal)"></progress>
                            <p style="margin-top: 0.5rem; margin-bottom:0;"><strong>\(project.currentAmount) €</strong> sur \(project.goal) €</p>
                        </div>
                    </div>
                    
                    <div>
                        <h4>Soutenir ce projet</h4>
                        <form action="/donate/\(project.id)" method="post" class="grid" style="gap: 0.5rem;">
                            <input type="number" name="amount" min="1" step="1" value="10" required>
                            <button type="submit">Valider le don</button>
                        </form>

                        <hr>
                        <h4>Zone de danger</h4>
                        <form action="/delete/\(project.id)" method="post">
                            <button type="submit" class="secondary" style="background-color: #ef4444; border-color: #ef4444; width: 100%;">🗑 Supprimer le projet</button>
                        </form>
                    </div>
                </div>
            </article>

            <details style="margin-top: 2rem;">
                <summary role="button" class="secondary outline">✏️ Éditer le projet</summary>
                <article>
                    <form action="/project/\(project.id)/edit" method="post">
                        <div class="grid">
                            <label>Titre
                                <input name="title" value="\(project.title)" required>
                            </label>
                            <label>Catégorie
                                <select name="categoryId" required>
                                    \(categoriesOptions)
                                </select>
                            </label>
                        </div>
                        <label>Description
                            <input name="description" value="\(project.description)" required>
                        </label>
                        <label>Objectif (€)
                            <input name="goal" type="number" step="0.1" value="\(project.goal)" required>
                        </label>
                        <button type="submit">Enregistrer les modifications</button>
                    </form>
                </article>
            </details>
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