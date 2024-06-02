package org.acme;

import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Response.ResponseBuilder;

import org.acme.model.Topic;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import java.net.URI;
import io.quarkus.runtime.StartupEvent;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;

@Path("Listener")
public class KafkaProvisioningResource {

    

    @Inject
    io.vertx.mutiny.mysqlclient.MySQLPool client;
    
    @Inject
    @ConfigProperty(name = "myapp.schema.create", defaultValue = "true") 
    boolean schemaCreate ;

    @ConfigProperty(name = "kafka.bootstrap.servers") 
    String kafka_servers;
    
    void config(@Observes StartupEvent ev) {
        if (schemaCreate) {
            initdb();
        }
    }
    
    private void initdb() {
        // In a production environment this configuration SHOULD NOT be used
        client.query("DROP TABLE IF EXISTS Purchases").execute()
        .flatMap(r -> client.query("CREATE TABLE Purchases (id SERIAL PRIMARY KEY,DateTime DATETIME, Price FLOAT, Product TEXT NOT NULL, Supplier TEXT NOT NULL, shopname TEXT NOT NULL, loyaltycardid BIGINT UNSIGNED)").execute())
        .flatMap(r -> client.query("INSERT INTO Purchases (DateTime,Price,Product,Supplier,shopname,loyaltycardid) VALUES ('2038-01-19 03:14:07','12.34','one product','supplier','arco cego',1)").execute())
        .await().indefinitely();
    }

    @POST
    @Path("ConsumeSelledProduct")
    public String ProvisioningConsumer(Topic topic) {
        Thread worker = new DynamicTopicConsumer(topic.TopicName , kafka_servers , client);
        worker.start();
        return "New worker started";
    }

    @POST
    @Path("ConsumeDiscountCoupon")
    public String ProvisioningConsumerDC(Topic topic) {
        // public float discount;
        // public java.time.LocalDateTime expiryDate;
        // public Long loyaltyCard_id;
        // public String shop_name;
        Thread worker = new DynamicTopicConsumerDC(topic.TopicName , kafka_servers , client);
        worker.start();
        return "New worker started";
    }

    @POST
    @Path("ConsumeCrossSell")
    public String ProvisioningConsumerCS(Topic topic) {
       // public Long loyaltyCard_id;
        // public String shop_name;
        Thread worker = new DynamicTopicConsumerCS(topic.TopicName , kafka_servers , client);
        worker.start();
        return "New worker started";
    }

    @GET
    public Multi<Purchase> get() {
        return Purchase.findAll(client);
    }

    @GET
    @Path("{id}")
    public Uni<Response> getSingle(Long id) {
        return Purchase.findById(client, id)
                .onItem().transform(purchase -> purchase != null ? Response.ok(purchase) : Response.status(Response.Status.NOT_FOUND)) 
                .onItem().transform(ResponseBuilder::build); 
    }

    @GET
    @Path("loyalty/{loyaltyCardId}")
    public Multi<Purchase> getByLoyaltyCardId(@PathParam("loyaltyCardId") Long loyaltyCardId) {
        return Purchase.findByLoyaltyCardId(client, loyaltyCardId);
    }
}
