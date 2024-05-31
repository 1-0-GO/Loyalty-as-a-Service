package org.acme;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.mysqlclient.MySQLPool;
import io.vertx.mutiny.sqlclient.Row;
import io.vertx.mutiny.sqlclient.RowSet;
import io.vertx.mutiny.sqlclient.Tuple;

public class Loyaltycard {

    public Long id;
    public Long idCustomer;
    public Long idShop;

    public Loyaltycard() {
    }

    public Loyaltycard(Long id, Long idCustomer, Long idShop) {
        this.id = id;
        this.idCustomer = idCustomer;
        this.idShop = idShop;
    }

    @Override
    public String toString() {
        return "{id:" + id + ", idCustomer:" + idCustomer + ", idShop:" + idShop + "}\n";
    }

    private static Loyaltycard fromCustomer(Row row) {
        return new Loyaltycard(row.getLong("id"), row.getLong("idCustomer"), null);
    }

    private static Loyaltycard fromShop(Row row) {
        return new Loyaltycard(row.getLong("id"), null, row.getLong("idShop"));
    }

    public static Multi<Loyaltycard> findAllCustomers(MySQLPool client) {
        return client.query("SELECT id, idCustomer FROM CustomerCards ORDER BY id ASC").execute()
                .onItem().transformToMulti(set -> Multi.createFrom().iterable(set))
                .onItem().transform(Loyaltycard::fromCustomer);
    }

    public static Multi<Loyaltycard> findAllShops(MySQLPool client) {
        return client.query("SELECT id, idShop FROM ShopCards ORDER BY id ASC").execute()
                .onItem().transformToMulti(set -> Multi.createFrom().iterable(set))
                .onItem().transform(Loyaltycard::fromShop);
    }

    public static Uni<Loyaltycard> findCustomerById(MySQLPool client, Long id) {
        return client.preparedQuery("SELECT id, idCustomer FROM CustomerCards WHERE id = ?").execute(Tuple.of(id))
                .onItem().transform(RowSet::iterator)
                .onItem().transform(iterator -> iterator.hasNext() ? fromCustomer(iterator.next()) : null);
    }

    public static Uni<Loyaltycard> findShopById(MySQLPool client, Long id) {
        return client.preparedQuery("SELECT id, idShop FROM ShopCards WHERE id = ?").execute(Tuple.of(id))
                .onItem().transform(RowSet::iterator)
                .onItem().transform(iterator -> iterator.hasNext() ? fromShop(iterator.next()) : null);
    }

    public Uni<Boolean> saveCustomer(MySQLPool client, Long idCustomer) {
        return client.preparedQuery("INSERT INTO CustomerCards(idCustomer) VALUES (?)").execute(Tuple.of(idCustomer))
                .onItem().transform(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public Uni<Boolean> saveShop(MySQLPool client, Long id, Long idShop) {
        return client.preparedQuery("INSERT INTO ShopCards(id, idShop) VALUES (?, ?)").execute(Tuple.of(id, idShop))
                .onItem().transform(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public static Uni<Boolean> deleteCustomer(MySQLPool client, Long id) {
        return client.preparedQuery("DELETE FROM CustomerCards WHERE id = ?").execute(Tuple.of(id))
                .onItem().transform(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public static Uni<Boolean> deleteShop(MySQLPool client, Long id) {
        return client.preparedQuery("DELETE FROM ShopCards WHERE id = ?").execute(Tuple.of(id))
                .onItem().transform(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public static Uni<Boolean> updateShop(MySQLPool client, Long id, Long idShop) {
        return client.preparedQuery("UPDATE ShopCards SET idShop = ? WHERE id = ?").execute(Tuple.of(idShop, id))
                .onItem().transform(pgRowSet -> pgRowSet.rowCount() == 1);
    }
}