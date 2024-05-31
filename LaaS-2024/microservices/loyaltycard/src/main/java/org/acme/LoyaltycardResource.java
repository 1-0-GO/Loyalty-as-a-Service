package org.acme;

import java.net.URI;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import io.quarkus.runtime.StartupEvent;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Response.ResponseBuilder;
import jakarta.ws.rs.core.MediaType;

@Path("Loyaltycard")
public class LoyaltycardResource {

    @Inject
    io.vertx.mutiny.mysqlclient.MySQLPool client;
    
    @Inject
    @ConfigProperty(name = "myapp.schema.create", defaultValue = "true") 
    boolean schemaCreate;
    
    private static long currentId = 0;

    void config(@Observes StartupEvent ev) {
        if (schemaCreate) {
            initdb();
        }
    }
    
    private void initdb() {
        client.query("DROP TABLE IF EXISTS CustomerCards, ShopCards").execute()
        .flatMap(r -> client.query("CREATE TABLE CustomerCards (id SERIAL PRIMARY KEY, idCustomer BIGINT UNSIGNED)").execute())
        .flatMap(r -> client.query("CREATE TABLE ShopCards (id SERIAL PRIMARY KEY, idShop BIGINT UNSIGNED)").execute())
        .flatMap(r -> client.query("INSERT INTO CustomerCards (idCustomer) VALUES (1), (2), (1), (4)").execute())
        .flatMap(r -> client.query("INSERT INTO ShopCards (id, idShop) VALUES (1, 1), (2, 1), (3, 3), (4, 2)").execute())
        .await().indefinitely();
    }

    @GET
    @Path("customers")
    public Multi<Loyaltycard> getAllCustomers() {
        return Loyaltycard.findAllCustomers(client);
    }

    @GET
    @Path("shops")
    public Multi<Loyaltycard> getAllShops() {
        return Loyaltycard.findAllShops(client);
    }

    @GET
    @Path("customers/{id}")
    public Uni<Response> getCustomerById(@PathParam("id") Long id) {
        return Loyaltycard.findCustomerById(client, id)
                .onItem().transform(loyaltycard -> loyaltycard != null ? Response.ok(loyaltycard) : Response.status(Response.Status.NOT_FOUND))
                .onItem().transform(Response.ResponseBuilder::build);
    }

    @GET
    @Path("shops/{id}")
    public Uni<Response> getShopById(@PathParam("id") Long id) {
        return Loyaltycard.findShopById(client, id)
                .onItem().transform(loyaltycard -> loyaltycard != null ? Response.ok(loyaltycard) : Response.status(Response.Status.NOT_FOUND))
                .onItem().transform(Response.ResponseBuilder::build);
    }

    @POST
    @Path("customers")
    public Uni<Response> createCustomer(Loyaltycard loyaltycard) {
        currentId++;
        return loyaltycard.saveCustomer(client, loyaltycard.idCustomer)
                .onItem().transform(id -> URI.create("/Loyaltycard/customers/" + currentId))
                .onItem().transform(uri -> Response.created(uri).build());
    }

    @POST
    @Path("shops")
    public Uni<Response> createShop(Loyaltycard loyaltycard) {
        currentId++;
        return loyaltycard.saveShop(client, currentId, loyaltycard.idShop)
                .onItem().transform(id -> URI.create("/Loyaltycard/shops/" + currentId))
                .onItem().transform(uri -> Response.created(uri).build());
    }

    @DELETE
    @Path("customers")
    public Uni<Response> deleteCustomer(Loyaltycard loyaltycard) {
        return Loyaltycard.deleteCustomer(client, loyaltycard.id)
                .onItem().transform(deleted -> deleted ? Response.Status.NO_CONTENT : Response.Status.NOT_FOUND)
                .onItem().transform(status -> Response.status(status).build());
    }

    @DELETE
    @Path("shops")
    public Uni<Response> deleteShop(Loyaltycard loyaltycard) {
        return Loyaltycard.deleteShop(client, loyaltycard.id)
                .onItem().transform(deleted -> deleted ? Response.Status.NO_CONTENT : Response.Status.NOT_FOUND)
                .onItem().transform(status -> Response.status(status).build());
    }

    @PUT
    @Path("shops")
    public Uni<Response> updateShop(Loyaltycard loyaltycard) {
        return Loyaltycard.updateShop(client, loyaltycard.id, loyaltycard.idShop)
                .onItem().transform(updated -> updated ? Response.Status.NO_CONTENT : Response.Status.NOT_FOUND)
                .onItem().transform(status -> Response.status(status).build());
    }
}