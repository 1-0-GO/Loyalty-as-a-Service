#!/bin/bash
echo "Starting..."

sudo yum install -y docker

sudo service docker start

sudo docker login -u "YOUR DOCKERHUB USERNAME" -p "YOUR DOCKERHUB PASSWORD"

sudo docker pull YOUR DOCKERHUB USERNAME/purchase:1.0.0-SNAPSHOT

sudo docker run -d --name purchase -p 8080:8080 YOUR DOCKERHUB USERNAME/purchase:1.0.0-SNAPSHOT

echo "Finished."
