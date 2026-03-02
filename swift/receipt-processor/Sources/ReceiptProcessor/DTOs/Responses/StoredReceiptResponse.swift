import Foundation
import Vapor

struct StoredReceiptResponse: Content {
    @LowercasedEncoding var id: UUID
}
