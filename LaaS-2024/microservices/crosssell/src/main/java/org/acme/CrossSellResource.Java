package org.acme;

import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.inject.Inject;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;


@Path("CrossSell")
public class CrossSellResources {
    
    @Inject
    @Channel("cross-sell")
    Emitter<SelledProduct> recommendEmitter;

    @POST
    @Path("/emit")
    @Consumes(MediaType.APPLICATION_JSON) // Accept DiscountCoupon in JSON format
    @Produces(MediaType.TEXT_PLAIN) // Return plain text response
    public Response emitCoupon(CrossSell crossSell) {
        recommendEmitter.send(crossSell);
        return Response.ok("Coupon emitted").build();
    }
}
