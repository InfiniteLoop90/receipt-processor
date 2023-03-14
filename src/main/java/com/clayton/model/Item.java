package com.clayton.model;

import java.math.BigDecimal;

public class Item {

    private String shortDescription;
    private BigDecimal price;

    public String getShortDescription () {
        return shortDescription;
    }

    public void setShortDescription (String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public BigDecimal getPrice () {
        return price;
    }

    public void setPrice (BigDecimal price) {
        this.price = price;
    }

    public static Item of (String shortDescription, BigDecimal price) {
        Item item = new Item();
        item.setShortDescription(shortDescription);
        item.setPrice(price);
        return item;
    }
}
