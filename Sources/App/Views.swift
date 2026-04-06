import Hummingbird
import Foundation

struct Views {
    static func renderIndex(items: [Project]) -> HTML {

        let rows = items.map { p in
            let progress = Int((p.currentAmount / p.goal) * 100)

            return """
            <article style="margin-bottom: 1rem;">
                <h3>\(p.title)</h3>
                <p>\(p.description)</p>
                <p>💰 \(p.currentAmount) / \(p.goal) € (\(progress)%)</p>

                <form action="/donate/\(p.id ?? 0)" method="post" style="display:inline;">
                    <button type="submit">💸 Donate 10€</button>
                </form>

                <form action="/delete/\(p.id ?? 0)" method="post" style="display:inline;">
                    <button type="submit" class="secondary">🗑 Delete</button>
                </form>
            </article>
            """
        }.joined()

        return HTML(content: """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
            <title>Crowdfunding</title>
        </head>
        <body class="container">
            <h1>🚀 Crowdfunding App</h1>

            <form action="/add" method="post">
                <input name="title" placeholder="Project title" required>
                <input name="description" placeholder="Description" required>
                <input name="goal" type="number" placeholder="Goal €" required>
                <button type="submit">Add Project</button>
            </form>

            <hr>

            \(items.isEmpty ? "<p>No projects yet</p>" : rows)

        </body>
        </html>
        """)
    }
}

// HTML response
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