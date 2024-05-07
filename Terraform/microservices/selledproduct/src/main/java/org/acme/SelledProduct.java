package org.acme;

public class SelledProduct {
    public Purchase purchase;
    public String loyaltyCard_id;
    public String shop;
    public String location;
    public String coupon;
    public String customer;

    public class Purchase {
        public Long id;
        public java.time.LocalDateTime timestamp;
        public Float price;
        public String product;
        public String supplier;
        public String  shop_name;    
        public Long loyaltyCard_id;
    }
}
