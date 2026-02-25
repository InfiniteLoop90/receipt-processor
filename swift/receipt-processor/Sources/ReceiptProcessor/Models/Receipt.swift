import Foundation
import Vapor

struct Receipt: Content {
    let retailer: String
    let purchaseDate: String
    let purchaseTime: String
    let items: [Item]

    func getPoints() -> Int {
        return 42
    }
}
