#!/bin/bash

echo "Running ROS setup..."
./setup-ros.sh
echo "Installing Mavlink & Mavros..."
./setup-mavlink-mavros.sh
echo "Running final setup..."
./setup-install.sh
