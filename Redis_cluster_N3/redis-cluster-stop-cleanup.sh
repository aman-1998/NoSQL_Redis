#!/bin/bash

# === Config ===
BASE_DIR=~/redis-cluster
REDIS_PORT_START=7000
REDIS_PORT_END=7008

echo "Stopping Redis cluster nodes..."

# Step 1: Shut down each Redis instance
for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
  echo "Shutting down Redis on port $port..."
  redis-cli -p $port shutdown
done

sleep 2

# Step 2: Remove temporary files
echo "Cleaning up logs, dump files, and configs..."

for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
  rm -f $BASE_DIR/$port/{nodes.conf,appendonly.aof,dump.rdb,$port.log}
done

echo "All Redis nodes stopped and cleaned up."
