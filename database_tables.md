### Customer table
"CREATE TABLE Customers (id SERIAL PRIMARY KEY, name TEXT NOT NULL, FiscalNumber BIGINT UNSIGNED, location TEXT NOT NULL)"

id: SERIAL PRIMARY KEY
name: TEXT NOT NULL
FiscalNumber: BIGINT UNSIGNED
location: TEXT NOT NULL

### Shop Table
"CREATE TABLE Shops (id SERIAL PRIMARY KEY, name TEXT NOT NULL, location TEXT NOT NULL)"

id: SERIAL PRIMARY KEY 
name: TEXT NOT NULL  
location: TEXT NOT NULL

### LoyaltyCard Table
"CREATE TABLE LoyaltyCards (id SERIAL PRIMARY KEY, idCustomer BIGINT UNSIGNED, idShop BIGINT UNSIGNED, CONSTRAINT UC_Loyal UNIQUE (idCustomer,idShop))"

id: SERIAL PRIMARY KEY 
idCustomer: BIGINT UNSIGNED
idShop: BIGINT UNSIGNED

### Purchase Table NOT SURE YET DONT COPY
DateTime: Timestamp
Price: Float
Product: 
Supplier: 