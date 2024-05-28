package org.acme;

public class SelledProduct {
    public Long id;
    public java.time.LocalDateTime timestamp;
    public Float price;
    public String product;
    public String supplier;
    public String  shop_name;    
    public Long loyaltyCard_id;

    public SelledProduct() {
    }

    // Constructor for class
    public SelledProduct(Long id, java.time.LocalDateTime timestamp, Float price, String product, String supplier, String shop_name, Long loyaltyCard_id) {
        this.id=id;        
        this.timestamp = timestamp;
        this.price = price;
        this.product = product;
        this.supplier = supplier;
        this.shop_name = shop_name;
        this.loyaltyCard_id = loyaltyCard_id;
    }
}
