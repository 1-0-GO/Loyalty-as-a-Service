package org.acme;

public class Purchase {
    public java.time.LocalDateTime TimeStamp;
    public float price;
    public String shop;
    public String location;
    public String loyaltyCard_id;
    public String product;

    public Purchase(String product, String loyaltyCard_id, java.time.LocalDateTime TimeStamp, float price, String shop, String location, String coupon) {
        this.TimeStamp = TimeStamp;
        this.price = price;
        this.shop = shop;
        this.location = location;
        this.loyaltyCard_id = loyaltyCard_id;
        this.product = product;
    }
}
