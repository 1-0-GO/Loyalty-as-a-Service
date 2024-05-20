#!/bin/bash

source ./access.sh

# # #Terraform - RDS
cd RDS-Terraform
terraform init
terraform apply -auto-approve
esc=$'\e'
addressDB="$(terraform state show aws_db_instance.example |grep address | sed "s/address//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
cd ..

# # #Terraform - Camunda
cd Camunda-Terraform
terraform init
terraform apply -auto-approve
cd ..


# # #Terraform - Kafka
cd Kafka
terraform init
terraform apply -auto-approve
esc=$'\e'
addresskafka="$(terraform state show 'aws_instance.exampleKafkaConfiguration[0]'|grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
cd ..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/Purchase/src/main/resources

sed -i '' "s/kafka.bootstrap.servers/#kafka.bootstrap.servers/g" application.properties
echo "" >> application.properties 
echo "kafka.bootstrap.servers=$addresskafka:9092" >> application.properties

sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/quarkus_test_all_operations" >> application.properties                                        

cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/Purchase
terraform init
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/loyaltycard/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/quarkus_test_all_operations" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/loyaltycard
terraform init
terraform apply -auto-approve
cd ../..

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
cd microservices/customer/src/main/resources
sed -i '' "s/quarkus.datasource.reactive.url/#quarkus.datasource.reactive.url/g" application.properties
echo "" >> application.properties 
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/quarkus_test_all_operations" >> application.properties                                        
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
echo "quarkus.datasource.reactive.url=mysql://$addressDB:3306/quarkus_test_all_operations" >> application.properties                                        
cd ../../..
./mvnw clean package
cd ../..

cd Quarkus-Terraform/shop
terraform init
terraform apply -auto-approve
cd ../..


# #Terraform 1 - Kong
cd KongTerraform
terraform init
terraform apply -auto-approve
cd ..

# #Terraform 2 - Konga
cd KongaTerraform
terraform init
terraform apply -auto-approve
cd ..




# Showing all the PUBLIC_DNSs
#echo CAMUNDA - 
cd Camunda-Terraform
#terraform state show aws_instance.exampleInstallCamundaEngine |grep public_dns
echo "CAMUNDA IS AVAILABLE HERE:"
addressCamunda="$(terraform state show aws_instance.exampleInstallCamundaEngine |grep public_dns| sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressCamunda":8080/camunda"
echo
cd ..

cd Kafka
echo "KAFKA IS AVAILABLE HERE:"
echo ""$addresskafka""
echo
cd ..


#echo Quarkus - 
cd Quarkus-Terraform/Purchase
#terraform state show 'aws_instance.exampleDeployQuarkus' |grep public_dns
echo "MICROSERVICE purchase IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.exampleDeployQuarkus |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - 
cd Quarkus-Terraform/customer
#terraform state show 'aws_instance.exampleDeployQuarkus' |grep public_dns
echo "MICROSERVICE customer IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.exampleDeployQuarkus |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - 
cd Quarkus-Terraform/shop
#terraform state show 'aws_instance.exampleDeployQuarkus' |grep public_dns
echo "MICROSERVICE shop IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.exampleDeployQuarkus |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

#echo Quarkus - 
cd Quarkus-Terraform/loyaltycard
#terraform state show 'aws_instance.exampleDeployQuarkus' |grep public_dns
echo "MICROSERVICE loyaltycard IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.exampleDeployQuarkus |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/q/swagger-ui/"
echo
cd ../..

cd RDS-Terraform
echo "RDS IS AVAILABLE HERE:"
terraform state show aws_db_instance.example |grep address
terraform state show aws_db_instance.example |grep port
echo
cd ..

echo "KONG IS AVAILABLE HERE:" 
cd KongTerraform
addressKong="$(terraform state show aws_instance.exampleInstallKong |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressKong":8080/"
echo
cd ..

echo "KONGA IS AVAILABLE HERE:"
cd KongaTerraform
addressKonga="$(terraform state show aws_instance.exampleInstallKonga |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressKonga":1337/"
echo
cd ..


# Create all KONG services and routes
#
#kong_admin_url="http://"$addressKong":8001"
#
## Create customer service and route
#curl -i -X POST \
# --url $kong_admin_url/services/ \
# --data 'name=customer-service' \
# --data 'url=http://'"$addressCustomerMS"':8080'
#
#curl -i -X POST \
# --url $kong_admin_url/services/customer-service/routes \
# --data 'paths[]=/Customer*'
#
## Create shop service and route
#curl -i -X POST \
# --url $kong_admin_url/services/ \
# --data 'name=shop-service' \
# --data 'url=http://'"$addressShopMS"':8080'
#
#curl -i -X POST \
#    --url $kong_admin_url/services/shop-service/routes \
#    --data 'paths[]=/Shop*'
#
## Create loyaltycard service and route
#curl -i -X POST \
# --url $kong_admin_url/services/ \
# --data 'name=loyaltycard-service' \
# --data 'url=http://'"$addressLoyaltycardMS"':8080'
#
#curl -i -X POST \
#    --url $kong_admin_url/services/loyaltycard-service/routes \
#    --data 'paths[]=/Loyaltycard*'
#
## Create discountcoupon service and route
#curl -i -X POST \
# --url $kong_admin_url/services/ \
# --data 'name=discountcoupon-service' \
# --data 'url=http://'"$addressDiscountcouponMS"':8080'
#
#curl -i -X POST \
#    --url $kong_admin_url/services/discountcoupon-service/routes \
#    --data 'paths[]=/Discountcoupon*'
#
## Create crosssell service and route
#curl -i -X POST \
# --url $kong_admin_url/services/ \
# --data 'name=crosssell-service' \
# --data 'url=http://'"$addressCrosssellMS"':8080'
#
#curl -i -X POST \
#    --url $kong_admin_url/services/crosssell-service/routes \
#    --data 'paths[]=/Crosssell*'
#
## Create selledproduct service and route
#curl -i -X POST \
# --url $kong_admin_url/services/ \
# --data 'name=selledproduct-service' \
# --data 'url=http://'"$addressSelledproductMS"':8080'
#
#curl -i -X POST \
#    --url $kong_admin_url/services/selledproduct-service/routes \
#    --data 'paths[]=/Selledproduct*'
#
## Create purchase service and route
#curl -i -X POST \
# --url $kong_admin_url/services/ \
# --data 'name=purchase-service' \
# --data 'url=http://'"$addressPurchaseMS"':8080'
#
#curl -i -X POST \
#    --url $kong_admin_url/services/purchase-service/routes \
#    --data 'paths[]=/Purchase*'
