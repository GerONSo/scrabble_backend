import Vapor

func routes(_ app: Application) throws {
    
    
    
    
    
    // TODO remove
    app.get("galaxies") { req async throws in
        try await Galaxy.query(on: req.db).all()
    }
    // TODO remove
    app.post("galaxies") { req async throws -> Galaxy in
        let galaxy = try req.content.decode(Galaxy.self)
        try await galaxy.create(on: req.db)
        return galaxy
    }
}
