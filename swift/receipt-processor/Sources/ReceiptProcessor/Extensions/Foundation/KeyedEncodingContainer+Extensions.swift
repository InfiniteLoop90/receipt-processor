import Foundation

/**
 Various extensions to support addition encodings that aren't supported out of the box.
 */
extension KeyedEncodingContainer {

    /**
     Adding support for encoding Decimal to String
     */
    mutating func encode(_ value: Decimal, forKey key: K) throws {
        let stringValue = NSDecimalNumber(decimal: value).stringValue
        try encode(stringValue, forKey: key)
    }
}
