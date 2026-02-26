import Foundation
import Vapor

struct Receipt: Content {
    let retailer: String
    let purchaseDate: String
    let purchaseTime: String
    let items: [Item]
    let total: Decimal

    func getPoints() -> Int {
        return getAlphaNumericPoints()
        + getRoundDollarTotalPoints()
        + getTotalIsMultipleOfPoint25Points()
        + getEveryTwoItemPoints()
        + getTrimmedDescriptionLengthMultipleOfThreePoints()
        + getOddPurchaseDatePoints()
        + getTimeOfPurchaseAfterTwoPmAndBeforeFourPmPoints()
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
        if (isRounded) {
            return 50
        } else {
            return 0
        }
    }

    // 25 points if the total is a multiple of 0.25.
    private func getTotalIsMultipleOfPoint25Points() -> Int {
        // Check if total is a multiple of 0.25 without floating-point error by scaling to cents
        // 0.25 dollars == 25 cents; multiply by 100 to work in integer cents
        // Then check if cents % 25 == 0
        var value = total
        var scaled = Decimal()
        NSDecimalMultiplyByPowerOf10(&scaled, &value, 2, .plain) // * 10^2 to convert dollars -> cents

        // Now attempt to convert to an integer. If it can't be represented exactly, it's not a clean cent value.
        // We round with .plain to the 0 scale to get an integral Decimal, then compare.
        var rounded = Decimal()
        var temp = scaled
        NSDecimalRound(&rounded, &temp, 0, .plain)
        guard rounded == scaled, let cents = NSDecimalNumber(decimal: rounded).intValue as Int? else {
            return 0
        }

        return (cents % 25 == 0) ? 25 : 0
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

            // Compute 20% of the price using Decimal-safe math
            var price = item.price
            var twentyPercent = Decimal()
            // Prepare a Decimal constant for 0.2 and pass its address
            var decimalPointTwo = Decimal(string: "0.2")!
            NSDecimalMultiply(&twentyPercent, &price, &decimalPointTwo, .plain)

            // Round up to the nearest integer
            var roundedUp = Decimal()
            var temp = twentyPercent
            NSDecimalRound(&roundedUp, &temp, 0, .up)

            // Convert to Int and add to total
            totalPoints += NSDecimalNumber(decimal: roundedUp).intValue
        }
        return totalPoints
    }

    // 6 points if the day in the purchase date is odd.
    private func getOddPurchaseDatePoints() -> Int {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
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
        let hour = calendar.component(.hour, from: purchaseDateVal)

        // After 2 PM (14:00) and before 4 PM (16:00)
        // Inclusive start (14:00) and exclusive end (16:00) means 14:00-15:59
        if hour >= 14 && hour < 16 {
            return 100
        } else {
            return 0
        }
    }
}
