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
import org.json.JSONObject;

@Path("SelledProduct")
public class SelledProductResources {
    @Inject
    @Channel("soldProducts")
    Emitter<String> soldProductsEmitter;

    @POST
    @Path("/emit")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response emitSelledProduct(List<SelledProduct> selledProducts) {
        for (SelledProduct product : selledProducts) {
            JSONObject purchaseEvent = new JSONObject();
            purchaseEvent.put("TimeStamp", product.timestamp.toString());
            purchaseEvent.put("LoyaltyCard_ID", product.loyaltyCard_id.toString());
            purchaseEvent.put("Price", product.price.toString());
            purchaseEvent.put("Product", product.product);
            purchaseEvent.put("Supplier", product.supplier);
            purchaseEvent.put("Shop", product.shop_name);

            JSONObject event = new JSONObject();
            event.put("Purchase_Event", purchaseEvent);

            String topicName = "soldProducts_" + product.product + "_" + product.shop_name;
            sendMessageToTopic(event.toString(), topicName);
        }
        return Response.ok("Products processed").build();
    }

    private void sendMessageToTopic(String message, String topicName) {
        // Emit message to the dynamically created topic
        soldProductsEmitter.send(topicName + ":" + message);
    }
}
