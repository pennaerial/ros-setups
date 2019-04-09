#!/bin/bash
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
wstool init ~/catkin_ws/src
rosinstall_generator --upstream mavros | tee /tmp/mavros.rosinstall
rosinstall_generator mavlink | tee -a /tmp/mavros.rosinstall
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro `echo $ROS_DISTRO` -y
cd src
git clone https://github.com/ros/geometry2.git
git clone git@github.com:pennaerial/pennair2.git
cd ..

catkin build
