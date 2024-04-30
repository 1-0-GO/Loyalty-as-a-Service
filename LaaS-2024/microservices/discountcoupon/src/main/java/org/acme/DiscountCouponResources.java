package org.acme;

import java.beans.ConstructorProperties;
import java.net.URI;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;

import org.acme.DiscountCoupon;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import io.quarkus.runtime.StartupEvent;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Response.ResponseBuilder;
import jakarta.ws.rs.core.MediaType;


@Path("DiscountCoupon")
public class DiscountCouponResources {
    
    @Inject
    io.vertx.mutiny.mysqlclient.MySQLPool client;

    @Inject
    @ConfigProperty(name = "myapp.schema.create", defaultValue = "true")
    boolean schemaCreate ;

    void config(@Observes StartupEvent ev) {
        if (schemaCreate) {
            initdb();
        }
    }

    @POST
    public Uni<Response> emit() {
        return DiscountCoupon.analyse(client)
                .onItem().transform(success -> {
                    if (success) {
                        return Response.ok().build();
                    } else {
                        // TODO: Handle failure case here, for example return a 500 error
                        return Response.serverError().build();
                    }
                });
    }
}
