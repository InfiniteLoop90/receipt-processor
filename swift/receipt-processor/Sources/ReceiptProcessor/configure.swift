import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)

    // Using this as a "global" dictionary to store the receipts. Initialized to an empty dictionary.
    app.receiptStore = .init(receipts: [:])

    // register routes
    try routes(app)
}
