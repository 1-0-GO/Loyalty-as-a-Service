#!/bin/bash
echo "Starting..."

sudo yum install -y docker___

sudo service docker start

sudo docker login -u "kbrattli" -p "Seiadmin123!"

sudo docker pull kbrattli/customer:1.0.0-SNAPSHOT

sudo docker run -d --name customer -p 8080:8080 kbrattli/customer:1.0.0-SNAPSHOT

echo "Finished."
