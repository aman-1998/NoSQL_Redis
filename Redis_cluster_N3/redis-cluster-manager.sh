#!/bin/bash

# === Configuration ===
BASE_DIR=~/redis-cluster
REDIS_PORT_START=7000
REDIS_PORT_END=7008

case "$1" in

  start)
    echo "Starting Redis cluster nodes..."
    for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
      CONF="$BASE_DIR/$port/redis.conf"
      if [ -f "$CONF" ]; then
        echo "Starting Redis on port $port..."
        redis-server "$CONF"
      else
        echo "Config file not found for port $port"
      fi
    done
    ;;

  stop)
    echo "Stopping Redis cluster nodes..."
    for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
      echo "Shutting down Redis on port $port..."
      redis-cli -p $port shutdown 2>/dev/null
    done
    ;;

  restart)
    echo "Restarting Redis cluster nodes..."
    $0 stop
    sleep 2
    $0 start
    ;;

  cleanup)
    echo "Cleaning up logs and data files..."
    for port in $(seq $REDIS_PORT_START $REDIS_PORT_END); do
      echo "Cleaning $BASE_DIR/$port..."
      rm -f $BASE_DIR/$port/{nodes.conf,appendonly.aof,dump.rdb,$port.log}
    done
    ;;

  purge)
    echo "Completely deleting Redis cluster..."
    $0 stop
    sleep 1
    rm -rf "$BASE_DIR"
    echo "All cluster data and folders removed."
    ;;

  *)
    echo "Usage: $0 {start|stop|restart|cleanup|purge}"
    exit 1
    ;;
esac
