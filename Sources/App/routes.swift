import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("galaxies") { req async throws in
        try await Galaxy.query(on: req.db).all()
    }
    
    app.post("galaxies") { req -> EventLoopFuture<Galaxy> in
        let galaxy = try req.content.decode(Galaxy.self)
        return galaxy.create(on: req.db)
            .map { galaxy }
    }
}
