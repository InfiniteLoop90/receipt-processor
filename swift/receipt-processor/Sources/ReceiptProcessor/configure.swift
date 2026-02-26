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

/*
 The default JSON decoder doesn't support certain decodings that I need so I'm adding them here.
 */
extension KeyedDecodingContainer {
    // Decoding a String to a Decimal
    func decode(_ type: Decimal.Type, forKey key: K) throws -> Decimal {
        let stringValue = try decode(String.self, forKey: key)
        guard let decimalValue = Decimal(string: stringValue) else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Invalid decimal string: \(stringValue)"
            )
            throw DecodingError.dataCorrupted(context)
        }
        return decimalValue
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: Decimal, forKey key: K) throws {
        // Convert Decimal to String.
        // Using NSDecimalNumber for consistent string formatting (avoids locale-specific formatting issues)
        let stringValue = NSDecimalNumber(decimal: value).stringValue
        try encode(stringValue, forKey: key)
    }
}
