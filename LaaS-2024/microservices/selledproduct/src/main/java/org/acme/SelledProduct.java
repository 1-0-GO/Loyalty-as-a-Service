package org.acme;

public class SelledProduct {
    public java.time.LocalDateTime TimeStamp;
    public float price;
    public String shop;
    public String location;
    public String coupon;
    public String loyaltyCard_id;
    public String product;

    // Constructor for class
    public SelledProduct(String product, String loyaltyCard_id, java.time.LocalDateTime TimeStamp, float price, String shop, String location, String coupon) {
        this.loyaltyCard_id = loyaltyCard_id;
        this.TimeStamp = TimeStamp;
        this.price = price;
        this.shop = shop;
        this.location = location;
        this.coupon = coupon;
        this.product = product;
    }
}
