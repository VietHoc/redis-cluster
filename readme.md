# Craate redis cluser with 3 master nodes(6000, 6001, 6002) and 3 slave nodes(6003, 6004, 6005)

## Step 1: Install Redis
If you don’t already have Redis installed, install it on your machine:

```
sudo apt update
sudo apt install redis-server
```

## Step 2: Start Redis Instances
Run each Redis instance using the appropriate configuration file:
```
redis-server ./6000/redis.conf
redis-server ./6001/redis.conf
redis-server ./6002/redis.conf
redis-server ./6003/redis.conf
redis-server ./6004/redis.conf
redis-server ./6005/redis.conf
```

## Step 3: Run the cluster creation command
This command creates a cluster with 3 master nodes (6000, 6002, 6004) and 3 replica nodes (6001, 6003, 6005).
The --cluster-replicas 1 option means that each master will have one replica.

```
redis-cli --cluster create 127.0.0.1:6000  127.0.0.1:6002 127.0.0.1:6004 \
          127.0.0.1:6001 127.0.0.1:6003 127.0.0.1:6005 \
          --cluster-replicas 1

or

chmod +x reset_and_create_cluster.sh
./reset_and_create_cluster.sh
```
Confirm the cluster creation:
You will be asked to confirm the cluster configuration. Type yes to proceed.

**Here’s a breakdown of how it works: The first three nodes (6000, 6002, 6004) are designated as master nodes:**

The first three nodes (6000, 6002, 6004) are designated as master nodes.
The next three nodes (6001, 6003, 6005) are replicas (slaves).
The option --cluster-replicas 1 tells Redis to assign 1 replica to each master.

## Step 4: Verify the Cluster
Check cluster information:
You can connect to any of the Redis nodes and check the cluster configuration using:
```
redis-cli -c -p 6000 cluster info
```

Check the cluster nodes:
```
redis-cli -c -p 6000 cluster nodes
```
Check the cluster/slot number/key number of the entire cluster:
```
> redis-cli --cluster check 127.0.0.1:6001                                                                                  
127.0.0.1:6001 (5403b3d0...) -> 0 keys | 5462 slots | 1 slaves.
127.0.0.1:6000 (f9e75b33...) -> 1 keys | 5461 slots | 1 slaves.
127.0.0.1:6002 (1ab10251...) -> 2 keys | 5461 slots | 1 slaves.
[OK] 3 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:6001)
M: 5403b3d0ab593050f0cff8b4e7aa50ba51417302 127.0.0.1:6001
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: ca57a8be768b51a75ce5b54382c4482069a2c579 127.0.0.1:6005
   slots: (0 slots) slave
   replicates f9e75b33b56c6cd418479aecaa5b8479a1e0e207
S: 9b48a60d8e305e1c3966c4224f4e7fd6b5ea26cb 127.0.0.1:6004
   slots: (0 slots) slave
   replicates 1ab10251a66986b8f890dc8226e9983224a275ab
S: dd1e2fa9b0fbb0c4083a50332a6e584bed8f5763 127.0.0.1:6003
   slots: (0 slots) slave
   replicates 5403b3d0ab593050f0cff8b4e7aa50ba51417302
M: f9e75b33b56c6cd418479aecaa5b8479a1e0e207 127.0.0.1:6000
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: 1ab10251a66986b8f890dc8226e9983224a275ab 127.0.0.1:6002
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

This will show you all the nodes in the cluster, their roles (master or replica), and their states.

## Step 4: Testing the Cluster
```
redis-cli -c  -p 6000 set key-6000 6000
redis-cli -c -p 6003 GET key-6000
```