package org.acme;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class SelledProduct {
    public long loyaltyCard_id;
    public String shop;

    public class Purchase {
        public Long id;
        public java.time.LocalDateTime timestamp;
        public Float price;
        public String product;
        public String supplier;
        public String  shop_name;    
        public Long loyaltyCard_id;
    }

    public SelledProduct(long loyaltyCard_id, List<Purchase> purchases) {
        this.loyaltyCard_id = loyaltyCard_id;
        this.shop = analyse(purchases);
    }

    public String analyse(List<Purchase> purchases) {
        if (purchases == null || purchases.isEmpty()) {
            return "Unknown"; // Return "Unknown" if no purchases are available
        }
        
        // Select a random shop from the list of purchases
        Random random = new Random();
        int randomIndex = random.nextInt(purchases.size());
        return purchases.get(randomIndex).shop_name;
    }
}
