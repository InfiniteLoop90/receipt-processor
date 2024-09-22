package com.clayton.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public record Receipt (String retailer, LocalDate purchaseDate, LocalTime purchaseTime, List<Item> items, BigDecimal total) {
    private static final BigDecimal ZERO_POINT_TWENTY_FIVE = new BigDecimal("0.25");
    private static final BigDecimal ZERO_POINT_TWO = new BigDecimal("0.2");

    private static final LocalTime TWO_PM = LocalTime.of(14, 0);
    private static final LocalTime FOUR_PM = LocalTime.of(16, 0);

    /**
     * Gets the total number of points for the receipt as per the rules
     * @return the total number of points for the receipt
     */
    public long getPoints () {
        return getAlphaNumericPoints()
            + getRoundDollarTotalPoints()
            + getTotalIsMultipleOfPoint25Points()
            + getEveryTwoItemPoints()
            + getTrimmedDescriptionLengthMultipleOfThreePoints()
            + getOddPurchaseDatePoints()
            + getTimeOfPurchaseAfterTwoPmAndBeforeFourPmPoints();
    }

    /**
     * Returns the number of points for the rule:
     * One point for every alphanumeric character in the retailer name.
     * @return the number of points for given rule
     */
    private long getAlphaNumericPoints () {
        // See https://stackoverflow.com/a/18304805
        return retailer.chars().filter(Character::isLetterOrDigit).count();
    }

    /**
     * Returns the number of points for the rule:
     * 50 points if the total is a round dollar amount with no cents.
     * @return the number of points for given rule
     */
    private long getRoundDollarTotalPoints () {
        // See https://stackoverflow.com/a/12748321
        if (total.stripTrailingZeros().scale() <= 0) {
            return 50L;
        }
        return 0L;
    }

    /**
     * Returns the number of points for the rule:
     * 25 points if the total is a multiple of 0.25.
     * @return the number of points for given rule
     */
    private long getTotalIsMultipleOfPoint25Points () {
        // See https://stackoverflow.com/a/23330029
        if (total.remainder(ZERO_POINT_TWENTY_FIVE).compareTo(BigDecimal.ZERO) == 0) {
            return 25L;
        }
        return 0L;
    }

    /**
     * Returns the number of points for the rule:
     * 5 points for every two items on the receipt.
     * @return the number of points for given rule
     */
    private long getEveryTwoItemPoints () {
        // In Java, integer division truncates the remainder
        return Math.multiplyExact(5L, items.size() / 2);
    }

    /**
     * Returns the number of points for the rule:
     * If the trimmed length of the item description is a multiple of 3, multiply the price by 0.2 and round up to the
     * nearest integer. The result is the number of points earned.
     * @return the number of points for given rule
     */
    private long getTrimmedDescriptionLengthMultipleOfThreePoints () {
        long summedPoints = 0L;
        for (Item item : items) {
            if (isMultipleOfThree(item.shortDescription().trim().length())) {
                summedPoints += roundUpAsLong(item.price().multiply(ZERO_POINT_TWO));
            }
        }
        return summedPoints;
    }

    /**
     * Returns the number of points for the rule:
     * 6 points if the day in the purchase date is odd.
     * @return the number of points for given rule
     */
    private long getOddPurchaseDatePoints () {
        if (isOdd(purchaseDate.getDayOfMonth())) {
            return 6L;
        }
        return 0L;
    }

    /**
     * Returns the number of points for the rule:
     * 10 points if the time of purchase is after 2:00pm and before 4:00pm.
     * @return the number of points for given rule
     */
    private long getTimeOfPurchaseAfterTwoPmAndBeforeFourPmPoints () {
        if (purchaseTime.isAfter(TWO_PM) && purchaseTime.isBefore(FOUR_PM)) {
            return 10L;
        }
        return 0L;
    }

    private boolean isMultipleOfThree (int num) {
        // See https://stackoverflow.com/a/8023671
        return num % 3 == 0;
    }

    private boolean isOdd (int num) {
        // See https://stackoverflow.com/a/7342251
        return num % 2 != 0;
    }

    private long roundUpAsLong (BigDecimal num) {
        // See https://stackoverflow.com/a/26102434
        return num.setScale(0, RoundingMode.UP).longValue();
    }
}
