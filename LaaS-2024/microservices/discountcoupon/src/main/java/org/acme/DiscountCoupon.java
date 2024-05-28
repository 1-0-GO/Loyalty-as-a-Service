package org.acme;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class DiscountCoupon {
    public float discount;
    public java.time.LocalDateTime expiryDate;
    public Long loyaltyCard_id;
    public String shop_name;

    public DiscountCoupon() {
    }

    public DiscountCoupon(Long loyaltyCard_id, List<Purchase> purchases) {
        this.discount = (float) 0.2;
        this.expiryDate = java.time.LocalDateTime.now().plusDays(30);
        this.loyaltyCard_id = loyaltyCard_id;
        this.shop_name = analyse(purchases);
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
