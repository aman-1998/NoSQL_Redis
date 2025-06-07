#!/bin/bash

# === Config ===
BASE_DIR=~/redis-cluster
REDIS_PORT_START=7000
REDIS_PORT_END=7008

echo "Restarting Redis cluster nodes..."

for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
  CONF="$BASE_DIR/$port/redis.conf"
  if [ -f "$CONF" ]; then
    echo "Starting Redis on port $port..."
    redis-server "$CONF"
  else
    echo "Config file not found for port $port at $CONF"
  fi
done

echo "Redis cluster nodes restarted."
