import Foundation
import Vapor

struct Item: Content {
    let shortDescription: String
    let priceString: String  // Use a string property for the raw data
    // Computed property to access as Decimal
    var price: Decimal? {
        return Decimal(string: priceString)
    }

    enum CodingKeys: String, CodingKey {
        case shortDescription
        case priceString = "price" // Map the JSON "price" key to this string property
    }
}
