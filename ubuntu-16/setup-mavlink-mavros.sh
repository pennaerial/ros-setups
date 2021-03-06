#!/bin/bash
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
. /opt/ros/kinetic/setup.bash
sudo apt-get -y install python-wstool python-rosinstall-generator python-catkin-tools 
wstool init ~/catkin_ws/src
rosinstall_generator --rosdistro kinetic --upstream-development mavros | tee /tmp/mavros.rosinstall
rosinstall_generator --rosdistro kinetic mavlink | tee -a /tmp/mavros.rosinstall
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro kinetic -y
cd ~/catkin_ws/src/
ln -s ~/src/Firmware/
ln -s ~/src/Firmware/Tools/sitl_gazebo/
cd ..
catkin build 
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
