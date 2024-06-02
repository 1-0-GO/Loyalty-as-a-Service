package org.acme;

// import org.apache.kafka.clients.consumer.KafkaConsumer;
// import org.apache.kafka.clients.producer.KafkaProducer; 
// import org.apache.kafka.clients.producer.ProducerRecord; 

import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.inject.Inject;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("CrossSell")
public class CrossSellResources {
    
    @Inject
    @Channel("cross-sell")
    Emitter<CrossSell> recommendEmitter;

    @POST
    @Path("/emit")
    @Consumes(MediaType.APPLICATION_JSON) // Accept DiscountCoupon in JSON format
    @Produces(MediaType.TEXT_PLAIN) // Return plain text response
    public Response emitCoupon(List<Purchase> purchases) {
        try {
            // Create a new CrossSell object
            CrossSell crossSell = new CrossSell(purchases.get(0).loyaltyCard_id, purchases);
            // String message = "{\"Purchase_Event\":{" +			
			// 		"\"LoyaltyCard_ID\":\"" + crossSell.loyaltyCard_id + "\"," +  
			// 		"\"Shop\":\"" + crossSell.shop_name + "\"" +
		    //         "}}";
            recommendEmitter.send(crossSell); // to json to string
            return Response.ok("recommendation emitted").build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST).entity("Error processing recommendation: " + e.getMessage()).build();
        }
    }
}
