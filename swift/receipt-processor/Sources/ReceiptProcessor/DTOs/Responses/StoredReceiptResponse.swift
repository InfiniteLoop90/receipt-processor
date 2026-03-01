import Foundation
import Vapor

struct StoredReceiptResponse: Content {
    @Lowercased var id: UUID
}
