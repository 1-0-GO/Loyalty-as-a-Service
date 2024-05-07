#!/bin/bash

start=$(date +%s)

source ./access.sh

# # #Terraform - RDS
cd RDS-Terraform
terraform init
terraform apply -auto-approve
esc=$'\e'
addressDB="$(terraform state show aws_db_instance.LaasDB |grep address | sed "s/address//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
cd ..

# # #Terraform - Kafka
cd Kafka-Terraform
terraform init
terraform apply -auto-approve
esc=$'\e'
addresskafkabroker1="$(terraform state show 'aws_instance.kafka[0]'|grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
addresskafkabroker2="$(terraform state show 'aws_instance.kafka[1]'|grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
#addresskafkabroker3="$(terraform state show 'aws_instance.kafka[2]'|grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
cd ..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/purchase/src/main/resources

sed -i '' "s/kafka.bootstrap.servers/#kafka.bootstrap.servers/g" application.properties
echo "" >> application.properties 
echo "kafka.bootstrap.servers=$addresskafkabroker1:9092,$addresskafkabroker2:9092" >> application.properties

sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/Laas" >> application.properties                                        

cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/purchase
terraform init
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/loyaltycard/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/Laas" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/loyaltycard
terraform init’
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/customer/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/Laas" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/customer
terraform init
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/shop/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/Laas" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/shop
terraform init
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/crosssell/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/Laas" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/crosssell
terraform init
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/selledproduct/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/Laas" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/selledproduct
terraform init
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/discountcoupon/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/Laas" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/discountcoupon
terraform init
terraform apply -auto-approve
cd ../..

# Showing all the PUBLIC_DNSs
#echo Kafka

cd Kafka-Terraform
echo "KAFKA BROKERS AVAILABLE HERE:"
echo ""$addresskafkabroker1""
echo ""$addresskafkabroker2""
#echo ""$addresskafkabroker3""
echo
cd ..

#echo Quarkus - purchase
cd Quarkus-Terraform/purchase
echo "MICROSERVICE purchase IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.purchase |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - customer 
cd Quarkus-Terraform/customer
echo "MICROSERVICE customer IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.customer |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - shop
cd Quarkus-Terraform/shop
echo "MICROSERVICE shop IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.shop |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - loyaltycard
cd Quarkus-Terraform/loyaltycard
echo "MICROSERVICE loyaltycard IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.loyaltycard |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - discountcoupon
cd Quarkus-Terraform/discountcoupon
echo "MICROSERVICE discountcoupon IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.discountcoupon |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - crosssell
cd Quarkus-Terraform/crosssell
echo "MICROSERVICE crosssell IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.crosssell |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - selledproduct
cd Quarkus-Terraform/selledproduct
echo "MICROSERVICE selledproduct IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.selledproduct |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo RDS
cd RDS-Terraform
echo "RDS IS AVAILABLE HERE:"
echo ""$addressDB""
terraform state show aws_db_instance.LaasDB |grep address
terraform state show aws_db_instance.LaasDB |grep port
echo
cd ..

end=$(date +%s)
duration=$(( end - start ))
echo "Total execution time: $duration seconds."