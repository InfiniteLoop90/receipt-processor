import Foundation
import Vapor

struct Item: Content {
    let shortDescription: String
    let price: Decimal
}
