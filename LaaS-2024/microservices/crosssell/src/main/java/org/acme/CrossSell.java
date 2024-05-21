package org.acme;

import java.util.List;
import java.util.Random;

public class CrossSell {
    public String loyaltyCard_id;
    public String shop;

    public CrossSell() {
    }

    public CrossSell(String loyaltyCard_id, List<Purchase> purchases) {
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
        return purchases.get(randomIndex).shop;
    }
}
