#!/bin/bash

# Define the Redis nodes
NODES=(6000 6001 6002 6003 6004 6005)

# Function to reset a Redis node
reset_node() {
  local port=$1
  echo "Resetting node on port $port..."
  redis-cli -p $port FLUSHALL
  redis-cli -p $port CLUSTER RESET
}

# Reset all nodes
for port in "${NODES[@]}"; do
  reset_node $port
done

# Create the cluster
echo "Creating the Redis cluster..."
redis-cli --cluster create 127.0.0.1:6000  127.0.0.1:6002 127.0.0.1:6004 \
          127.0.0.1:6001 127.0.0.1:6003 127.0.0.1:6005 \
          --cluster-replicas 1

echo "Cluster creation complete."