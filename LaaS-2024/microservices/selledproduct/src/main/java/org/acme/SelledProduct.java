package org.acme;

public class SelledProduct {
    public java.time.LocalDateTime TimeStamp;
    public float price;
    public String product;
    public String shop;
    public String location;
    public String loyaltyCard_id;

    public SelledProduct() {
    }

    // Constructor for class
    public SelledProduct(String product, String loyaltyCard_id, java.time.LocalDateTime TimeStamp, float price, String shop, String location, String coupon) {
        this.loyaltyCard_id = loyaltyCard_id;
        this.TimeStamp = TimeStamp;
        this.price = price;
        this.shop = shop;
        this.location = location;
        this.product = product;
    }
}
