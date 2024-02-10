package com.clayton.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class Receipt {
    private static final BigDecimal ZERO_POINT_TWENTY_FIVE = new BigDecimal("0.25");
    private static final BigDecimal ZERO_POINT_TWO = new BigDecimal("0.2");

    private static final LocalTime TWO_PM = LocalTime.of(14, 0);
    private static final LocalTime FOUR_PM = LocalTime.of(16, 0);

    private String retailer;
    private LocalDate purchaseDate;
    private LocalTime purchaseTime;
    private List<Item> items;
    private BigDecimal total;

    public String getRetailer () {
        return retailer;
    }

    public void setRetailer (String retailer) {
        this.retailer = retailer;
    }

    public LocalDate getPurchaseDate () {
        return purchaseDate;
    }

    public void setPurchaseDate (LocalDate purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public LocalTime getPurchaseTime () {
        return purchaseTime;
    }

    public void setPurchaseTime (LocalTime purchaseTime) {
        this.purchaseTime = purchaseTime;
    }

    public List<Item> getItems () {
        return items;
    }

    public void setItems (List<Item> items) {
        this.items = items;
    }

    public BigDecimal getTotal () {
        return total;
    }

    public void setTotal (BigDecimal total) {
        this.total = total;
    }

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

    private long getAlphaNumericPoints () {
        // See https://stackoverflow.com/a/18304805
        return retailer.chars().filter(Character::isLetterOrDigit).count();
    }

    private long getRoundDollarTotalPoints () {
        // See https://stackoverflow.com/a/12748321
        if (total.stripTrailingZeros().scale() <= 0) {
            return 50L;
        }
        return 0L;
    }

    private long getTotalIsMultipleOfPoint25Points() {
        // See https://stackoverflow.com/a/23330029
        if (total.remainder(ZERO_POINT_TWENTY_FIVE).compareTo(BigDecimal.ZERO) == 0) {
            return 25L;
        }
        return 0L;
    }

    private long getEveryTwoItemPoints () {
        return Math.multiplyExact(Math.divideExact(items.size(), 2),  5L);
    }

    private long getTrimmedDescriptionLengthMultipleOfThreePoints () {
        long summedPoints = 0L;
        for (Item item : items) {
            // See https://stackoverflow.com/a/8023671
            if (item.shortDescription().trim().chars().count() % 3 == 0) {
                // See https://stackoverflow.com/a/26102434
                summedPoints += item.price().multiply(ZERO_POINT_TWO).setScale(0, RoundingMode.UP).longValue();
            }
        }
        return summedPoints;
    }

    private long getOddPurchaseDatePoints () {
        // See https://stackoverflow.com/a/7342251
        if (purchaseDate.getDayOfMonth() % 2 != 0) {
            return 6L;
        }
        return 0L;
    }

    private long getTimeOfPurchaseAfterTwoPmAndBeforeFourPmPoints() {
        if (purchaseTime.isAfter(TWO_PM) && purchaseTime.isBefore(FOUR_PM)) {
            return 10L;
        }
        return 0L;
    }
}
