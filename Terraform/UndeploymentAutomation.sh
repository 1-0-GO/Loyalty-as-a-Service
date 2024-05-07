#!/bin/bash

start=$(date +%s)

source ./access.sh

# #Terraform - Quarkus purchase
cd Quarkus-Terraform/purchase
terraform destroy -auto-approve
cd ../..

# #Terraform - Quarkus customer
cd Quarkus-Terraform/customer
terraform destroy -auto-approve
cd ../..

# #Terraform - Quarkus shop
cd Quarkus-Terraform/shop
terraform destroy -auto-approve
cd ../..

# #Terraform - Quarkus loyaltycard
cd Quarkus-Terraform/loyaltycard
terraform destroy -auto-approve
cd ../..

# #Terraform - Quarkus selledproduct
cd Quarkus-Terraform/selledproduct
terraform destroy -auto-approve
cd ../..

# #Terraform - Quarkus crosssell
cd Quarkus-Terraform/crosssell
terraform destroy -auto-approve
cd ../..

# #Terraform - Quarkus discountcoupon
cd Quarkus-Terraform/discountcoupon
terraform destroy -auto-approve
cd ../..

# #Terraform - RDS
cd RDS-Terraform
terraform destroy -auto-approve
cd ..

# # #Terraform - Kafka
cd Kafka-Terraform
terraform destroy -auto-approve
cd ..

end=$(date +%s)
duration=$(( end - start ))
echo "Total execution time: $duration seconds."