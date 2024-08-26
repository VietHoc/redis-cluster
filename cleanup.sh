#!/bin/bash

# Loop through ports 6000 to 6005
for port in {6000..6005}
do
  # List the processes using the port and kill them
  lsof -i :$port -t | xargs -r kill -9
done

echo "Killed all processes using ports 6000 to 6005."