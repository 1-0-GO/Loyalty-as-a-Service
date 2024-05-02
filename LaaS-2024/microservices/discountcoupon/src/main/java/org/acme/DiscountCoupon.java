package org.acme;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class DiscountCoupon {
    public float discount;
    public java.time.LocalDateTime expiryDate;
    public long loyaltycardid;
    public String shop;

    // LoyaltyCardResource loyaltyCardResource = new LoyaltyCardResource();

    public DiscountCoupon() {
    }

    public class Purchase {
        public Long id;
        public java.time.LocalDateTime timestamp;
        public Float price;
        public String product;
        public String supplier;
        public String  shop_name;    
        public Long loyaltyCard_id;
    }

    public DiscountCoupon(long loyaltycardid, List<Purchase> purchases) {
        this.discount = (float) 0.2;
        this.expiryDate = java.time.LocalDateTime.now().plusDays(30);
        this.loyaltycardid = loyaltycardid;
        this.shop = analyse(purchases);
    }


    // Pseudo Code
    public String analyse(List<Purchase> purchases) {
        Map<String, Integer> shopCounts = new HashMap<>();

        // Iterate over purchases for each loyalty card
        for (Purchase purchase : purchases) {
            String shopName = purchase.shop_name;
            
            // Increment count for the shop
            shopCounts.put(shopName, shopCounts.getOrDefault(shopName, 0) + 1);
        }
        
        // Find the shop with the highest count
        String mostPopularShop = null;
        int maxCount = 0;
        for (Map.Entry<String, Integer> entry : shopCounts.entrySet()) {
            if (entry.getValue() > maxCount) {
                mostPopularShop = entry.getKey();
                maxCount = entry.getValue();
            }
        }
        return mostPopularShop = mostPopularShop == null ? "Unknown" : mostPopularShop;
    }
}
