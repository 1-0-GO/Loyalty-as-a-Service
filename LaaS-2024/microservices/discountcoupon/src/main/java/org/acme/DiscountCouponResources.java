package org.acme;

import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;

import java.util.List;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.inject.Inject;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;


@Path("DiscountCoupon")
public class DiscountCouponResources {
    
    @Inject
    @Channel("discount-coupon")
    Emitter<DiscountCoupon> couponEmitter;

    @POST
    @Path("/emit")
    @Consumes(MediaType.APPLICATION_JSON) // Accept DiscountCoupon in JSON format
    @Produces(MediaType.TEXT_PLAIN) // Return plain text response
    public Response emitCoupon(List<Purchase> purchases) {
        try {
            // Create a new DiscountCoupon object
            DiscountCoupon discountCoupon = new DiscountCoupon(purchases.get(0).loyaltyCard_id, purchases);
            couponEmitter.send(discountCoupon); // to json to string
            return Response.ok("Coupon emitted").build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST).entity("Error processing coupon: " + e.getMessage()).build();
        }
    }
}
