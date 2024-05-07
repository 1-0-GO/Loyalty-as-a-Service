#!/bin/bash

# Moving to home directory
cd

# Download and extract ZooKeeper
sudo wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz
sudo tar -zxf apache-zookeeper-3.8.4-bin.tar.gz
sudo mv apache-zookeeper-3.8.4-bin /usr/local/zookeeper
sudo mkdir -p /var/lib/zookeeper

# Create ZooKeeper configuration
echo "tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181" | sudo tee /usr/local/zookeeper/conf/zoo.cfg

# Install Java OpenJDK 8
sudo yum -y install java-1.8.0-openjdk.x86_64

# Start ZooKeeper service
sudo /usr/local/zookeeper/bin/zkServer.sh start

# Download and extract Kafka
sudo wget https://downloads.apache.org/kafka/3.6.2/kafka_2.13-3.6.2.tgz
sudo tar -zxf kafka_2.13-3.6.2.tgz
sudo mv kafka_2.13-3.6.2 /usr/local/kafka
sudo mkdir /tmp/kafka-logs

# Fetch the public hostname of the EC2 instance from the instance metadata
ip=$(curl http://169.254.169.254/latest/meta-data/public-hostname)

# Configure Kafka to listen on the public hostname
sudo sed -i "s/#listeners=PLAINTEXT:\/\/:9092/listeners=PLAINTEXT:\/\/$ip:9092/g" /usr/local/kafka/config/server.properties

# Delayed start of Kafka to allow network setup to complete
(sleep 120 && sudo /usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties)&
