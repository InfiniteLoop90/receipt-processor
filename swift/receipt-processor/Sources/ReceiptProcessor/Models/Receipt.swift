import Foundation
import Vapor

struct Receipt: Content {
    let retailer: String
    let purchaseDate: String
    let purchaseTime: String
    let items: [Item]
    let total: Decimal

    func getPoints() -> Int {
        let a = getAlphaNumericPoints()
        let b = getRoundDollarTotalPoints()
        let c = getTotalIsMultipleOfPoint25Points()
        let d = getEveryTwoItemPoints()
        let e = getTrimmedDescriptionLengthMultipleOfThreePoints()
        let f = getOddPurchaseDatePoints()
        let g = getTimeOfPurchaseAfterTwoPmAndBeforeFourPmPoints()
        return a + b + c + d + e + f + g
    }

    // One point for every alphanumeric character in the retailer name.
    private func getAlphaNumericPoints() -> Int {
        return retailer.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) }.count
    }

    // 50 points if the total is a round dollar amount with no cents.
    private func getRoundDollarTotalPoints() -> Int {
        var decimalValue = total
        var roundedValue = Decimal()
        NSDecimalRound(&roundedValue, &decimalValue, 0, .plain) // Round to 0 scale (whole number)
        let isRounded = decimalValue == roundedValue
        if isRounded {
            return 50
        } else {
            return 0
        }
    }

    // 25 points if the total is a multiple of 0.25.
    private func getTotalIsMultipleOfPoint25Points() -> Int {
        let doubleValue = NSDecimalNumber(decimal: total).doubleValue
        let divided = doubleValue / 0.25
        if divided.rounded() == divided {
            return 25
        } else {
            return 0
        }
    }

    // 5 points for every two items on the receipt.
    private func getEveryTwoItemPoints() -> Int {
        let pairs = items.count / 2
        return pairs * 5
    }

    /*
      If the trimmed length of the item description is a multiple of 3, multiply the price by 0.2
      and round up to the nearest integer. The result is the number of points earned.
     */
    private func getTrimmedDescriptionLengthMultipleOfThreePoints() -> Int {
        var totalPoints = 0
        for item in items {
            let trimmed = item.shortDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.count % 3 == 0 else { continue }

            let priceDouble = NSDecimalNumber(decimal: item.price).doubleValue
            // Multiply by 0.2 and round up to nearest integer
            let pointsForItem = Int(ceil(priceDouble * 0.2))
            totalPoints += pointsForItem
        }
        return totalPoints
    }

    // 6 points if the day in the purchase date is odd.
    private func getOddPurchaseDatePoints() -> Int {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"

        if let date = df.date(from: purchaseDate) {
            let day = Calendar.current.component(.day, from: date)
            let dayIsOdd = day % 2 != 0
            if dayIsOdd {
                return 6
            } else {
                return 0
            }
        } else {
            return 0
        }
    }

    // 10 points if the time of purchase is after 2:00pm and before 4:00pm.
    private func getTimeOfPurchaseAfterTwoPmAndBeforeFourPmPoints() -> Int {
        let formatter = DateFormatter()
        // "HH" is 24-hour format (00-23), "mm" is minutes
        formatter.dateFormat = "HH:mm"

        // Use POSIX locale to ensure parsing works regardless of user settings
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let purchaseDateVal = formatter.date(from: purchaseTime) else {
            return 0 // Return 0 points if time string is invalid
        }

        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: purchaseDateVal)
        let minutes = calendar.component(.minute, from: purchaseDateVal)
        let minutesInHour = 60
        let totalMinutes = (hours * minutesInHour) + minutes
        let twoPmInMinutes = 14 * minutesInHour
        let fourPmInMinutes = 16 * minutesInHour

        if totalMinutes > twoPmInMinutes && totalMinutes < fourPmInMinutes {
            return 10
        } else {
            return 0
        }
    }
}
