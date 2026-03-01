import Foundation

/**
 By default, Swift encodes UUIDs as an uppercased string instead of how the old
 RFC 4122 spec suggests which is all lowercase. So this property wrapper
 (when used) will enode it in all lowercase.
 I got this idea from https://www.reddit.com/r/swift/comments/1ir6a1a/comment/md5yccz
 */
@propertyWrapper struct Lowercased: Codable, Equatable, Hashable {
    let wrappedValue: UUID

    init(wrappedValue: UUID) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(UUID.self) }

    func encode(to encoder: any Encoder) throws { var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.uuidString.lowercased())
    }
}
