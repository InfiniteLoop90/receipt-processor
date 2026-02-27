import Foundation

/**
 Various extensions to support addition decodings that aren't supported out of the box.
 */
extension KeyedDecodingContainer {

    /**
     Adding support for decoding String to Decimal
     */
    func decode(_: Decimal.Type, forKey key: K) throws -> Decimal {
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
