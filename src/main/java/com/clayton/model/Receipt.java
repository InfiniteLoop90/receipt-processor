package com.clayton.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class Receipt {

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
}
