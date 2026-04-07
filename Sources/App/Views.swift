import Hummingbird

struct Views {

    static func renderIndex(items: [Project]) -> HTML {

        let rows = items.map { p in
            """
            <article>
                <h3><a href="/project/\(p.id!)">\(p.title)</a></h3>
                <p>\(p.description)</p>
                <small>Category: \(p.category)</small>
                <p>💰 \(p.currentAmount) / \(p.goal)</p>

                <form action="/donate/\(p.id!)" method="post">
                    <button>Donate</button>
                </form>

                <form action="/delete/\(p.id!)" method="post">
                    <button class="contrast">Delete</button>
                </form>
            </article>
            """
        }.joined()

        return HTML(content: """
        <html>
        <head>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
        </head>
        <body class="container">

        <h1>🚀 Crowdfunding App</h1>

        <!-- SEARCH -->
        <form method="get">
            <input name="search" placeholder="Search project...">
        </form>

        <!-- ADD -->
        <form action="/add" method="post">
            <input name="title" placeholder="Title">
            <input name="description" placeholder="Description">
            <input name="goal" placeholder="Goal">
            <input name="category" placeholder="Category">
            <button>Add</button>
        </form>

        <hr>
        \(rows)

        </body>
        </html>
        """)
    }

    static func renderDetail(project: Project) -> HTML {
        return HTML(content: """
        <html><body class="container">
        <h2>\(project.title)</h2>
        <p>\(project.description)</p>

        <form action="/update/\(project.id!)" method="post">
            <input name="title" value="\(project.title)">
            <input name="description" value="\(project.description)">
            <input name="goal" value="\(project.goal)">
            <button>Update</button>
        </form>

        <a href="/">⬅ Back</a>
        </body></html>
        """)
    }
}
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