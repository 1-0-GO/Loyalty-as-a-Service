#!/bin/bash
echo "Starting..."

sudo yum install -y docker

sudo service docker start

sudo docker login -u "tweekzio" -p "Seiadmin123!"

sudo docker pull tweekzio/customer:1.0.0-SNAPSHOT

sudo docker run -d --name customer -p 8080:8080 tweekzio/customer:1.0.0-SNAPSHOT

echo "Finished."
