import Vapor
import Fluent
import FluentPostgresDriver
import JWTKit
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "app_collection",
                password: "",
                database: "app_collection",
                tls: .disable
            )
        ),
        as: .psql
    )
    app.migrations.add(createMigrations())
    
    app.jwt.signers.use(.hs256(key: "secret"))
    try await app.autoMigrate().get()
    try routes(app)
}
