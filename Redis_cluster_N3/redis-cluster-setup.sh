#!/bin/bash

# === Config ===
BASE_DIR=~/redis-cluster
REDIS_PORT_START=7000
REDIS_PORT_END=7008

# === Step 1: Create directories and redis.conf files ===
mkdir -p "$BASE_DIR"
cd "$BASE_DIR" || exit 1

echo "Creating Redis node directories and configuration files..."

for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
  mkdir -p "$port"
  cat > "$port/redis.conf" <<EOF
port $port
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
dbfilename dump.rdb
dir ./
logfile "$port.log"
daemonize yes
EOF
done

echo "Redis configuration files created."

# === Step 2: Start all Redis nodes ===
echo "Starting Redis nodes..."

for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
  redis-server "$BASE_DIR/$port/redis.conf"
done

sleep 2
echo "All Redis instances started."

# === Step 3: Create the cluster ===
echo "Creating Redis Cluster with --cluster-replicas 2..."

NODE_LIST=""
for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
  NODE_LIST="$NODE_LIST 127.0.0.1:$port"
done

echo "$NODE_LIST"
echo "Confirming cluster creation..."
yes "yes" | redis-cli --cluster create $NODE_LIST --cluster-replicas 2

echo "Redis Cluster created successfully."
