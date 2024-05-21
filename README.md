# Loyalty-as-a-Service
Dependencies
- Java 17 = java --version
- Maven = mvn --version
- Docker = docker --version

## TODOS
- [x] Customer microservice can create customer
- [x] Create shops
- [x] Create loyaltycards and link between customer and shops
- [ ] Consume purchase events and put in database
- [ ] Discountcoupon gets purchase events and analyse them, push message coupon
- [ ] Same for Cross selling
- [ ] same for 


test docker local
./mvnw clean package
docker image ls -a    
docker run -d --name crosssell -p 8080:8080 tweekzio/crosssell:1.0.0-SNAPSHOT