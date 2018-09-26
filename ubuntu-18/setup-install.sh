#!/bin/bash
# For automated install, set permissions to avoid sudo/passwd. On standalone VM, run sudo visudo and add the following line to your sudoers file (or use sudo visudo to enter the editor):
# Defaults        !tty_tickets

export DEBIAN_FRONTEND=noninteractive
sudo usermod -a -G dialout $USER

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get -q -y install cmake ant protobuf-compiler libeigen3-dev libopencv-dev python-argparse git-core wget zip python-empy qtcreator cmake build-essential genromfs
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt-get update && sudo apt-get upgrade -y
# sudo apt-get install libignition-common-dev
sudo apt-get -y install gazebo7
sudo apt-get -y install libgazebo7-dev

echo "export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:$HOME/pennair/src/Firmware/Tools/sitl_gazebo/Build" >> ~/.bashrc
echo "export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:$HOME/pennair/src/Firmware/Tools/sitl_gazebo/models" >> ~/.bashrc
sudo apt-get remove -y gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi
sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa -y
sudo apt-get update
sudo apt-get -q -y install python-serial openocd flex bison libncurses5-dev autoconf texinfo build-essential \
    libftdi-dev libtool zlib1g-dev \
    python-empy gcc-arm-embedded -y

mkdir -p ~/pennair/src 
cd ~/pennair/src 
git clone https://github.com/Open-UAV/Firmware
cd ~/pennair/src/Firmware
git submodule update --init --recursive
echo "now type the following at the command prompt:"
echo "cd ~/pennair/src/Firmware/ && make posix_sitl_default gazebo"
