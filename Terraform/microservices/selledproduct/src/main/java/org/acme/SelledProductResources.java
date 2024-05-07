package org.acme;

import java.util.List;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.inject.Inject;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@Path("SelledProduct")
public class SelledProductResources {

    @Inject
    @Channel("soldProductsbyCoupon")
    Emitter<String> soldProductsbyCouponEmitter;

    @Inject
    @Channel("soldProductsbyLocation")
    Emitter<String> soldProductsbyLocationEmitter;

    @Inject
    @Channel("soldProductsbyShop")
    Emitter<String> soldProductsbyShopEmitter;

    @Inject
    @Channel("soldProductsbyLoyaltyCard")
    Emitter<String> soldProductsbyLoyaltyCardEmitter;

    @Inject
    @Channel("soldProductsbyCustomer")
    Emitter<String> soldProductsbyCustomerEmitter;

    @POST
    @Path("/emit")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response emitSelledProduct(List<SelledProduct> selledProducts) {
        for (SelledProduct product : selledProducts) {
            var soldProductsbyCoupon = product.purchase.product + "-" + product.coupon;
            var soldProductsbyLocation = product.purchase.product + "-" + product.location;
            var soldProductsbyShop = product.purchase.product + "-" + product.shop;
            var soldProductsbyLoyaltyCard = product.purchase.product + "-" + product.loyaltyCard_id;
            var soldProductsbyCustomer = product.purchase.product + "-" + product.customer;

            // Emitting messages to respective topics
            sendMessageToTopic(soldProductsbyCoupon, soldProductsbyCouponEmitter);
            sendMessageToTopic(soldProductsbyLocation, soldProductsbyLocationEmitter);
            sendMessageToTopic(soldProductsbyShop, soldProductsbyShopEmitter);
            sendMessageToTopic(soldProductsbyLoyaltyCard, soldProductsbyLoyaltyCardEmitter);
            sendMessageToTopic(soldProductsbyCustomer, soldProductsbyCustomerEmitter);
        }
        return Response.ok("Products processed").build();
    }

    private void sendMessageToTopic(String message, Emitter<String> emitter) {
        emitter.send(message);
    }
}
