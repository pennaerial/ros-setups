#!/bin/bash
mkdir -p ~/pennair/catkin_ws/src
cd ~/pennair/catkin_ws
. /opt/ros/melodic/setup.bash
sudo apt-get -y install python-wstool python-rosinstall-generator python-catkin-tools
wstool init ~/pennair/catkin_ws/src
rosinstall_generator --rosdistro melodic --upstream-development mavros | tee /tmp/mavros.rosinstall
rosinstall_generator --rosdistro melodic mavlink | tee -a /tmp/mavros.rosinstall
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro melodic -y
cd ~/pennair/catkin_ws/src/
ln -s ~/pennair/src/Firmware/
ln -s ~/pennair/src/Firmware/Tools/sitl_gazebo/

# Apply sitl_gazebo patch for gazebo0 compatibility
cp -r ./sitl_gazebo_patch_gazebo9/sitl_gazebo/src ~/pennair/src/Firmware/Tools/sitl_gazebo/
cp -r ./sitl_gazebo_patch_gazebo9/sitl_gazebo/include ~/pennair/src/Firmware/Tools/sitl_gazebo/
cp -r ./sitl_gazebo_patch_gazebo9/CMakeLists.txt ~/pennair/src/Firmware

cd ..
catkin build 
echo "source ~/pennair/catkin_ws/devel/setup.bash" >> ~/.profile