#!/bin/bash

########################################vo
## PATH VARIABLES
########################################
env_name=environment
path=~/PennAiR

mkdir -p $path
cd $path
directory=$(pwd)

section (){
    CYAN='\033[36;1m'
    NC='\033[0m'
    printf "${CYAN}"
    printf "#################################\n"
    printf "$1\n"
    printf "#################################\n"
    printf "${NC}"
}

########################################
## DEPENDENCIES AND UTILS
########################################
sudo apt -y install git

########################################
## SETUP VIRTUALENV
########################################
section "SETUP VIRTUALENV"

sudo apt update
sudo apt -y install python-pip
pip install --upgrade pip #Pip is always out of date from repo
pip install virtualenv

cd $directory #Why is this necessary?
virtualenv -p /usr/bin/python3 $env_name
echo "source $env_name/bin/activate" >> $directory/activate
chmod +x $directory/activate

########################################
## ROS SETUP FROM SOURCES
########################################
section "ROS SETUP FROM SOURCES"

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update

cd $directory #Again, why?

source $env_name/bin/activate #Activate virtualenv
pip install -U git+https://github.com/ros-infrastructure/rosdep.git@master
pip install -U rosinstall_generator wstool rosinstall catkin_pkg
pip install --upgrade setuptools

echo "export ROS_ETC_DIR=$directory/$env_name/etc/ros" >> $directory/activate
deactivate
source activate
rosdep init
rosdep update

section "INITIALIZE ROS CATKIN WORKSPACE"
mkdir ros_catkin_ws
cd ros_catkin_ws
rosinstall_generator desktop_full --rosdistro kinetic --deps --wet-only > kinetic-desktop-full-wet.rosinstall #remove -tar option
wstool init -j8 src kinetic-desktop-full-wet.rosinstall
rosdep install --from-paths src --ignore-src --rosdistro kinetic -y

#build
section "BUILD ROS"

#OpenCV3 needs python-dev,
#should find coresponding pip module instead (if one exists)
sudo apt -y install python3-dev
#Must install sip in virtualenv
#pip install sip ## this didn't work :(
#sudo apt install python3-sip-dev
#Do a manual install so virt-env links properly
cd $directory
mkdir -p sip_install
cd sip_install
wget https://sourceforge.net/projects/pyqt/files/sip/sip-4.19.3/sip-4.19.3.tar.gz -O sip-install.tar.gz
tar -xvf sip-install.tar.gz
cd sip-4.19.3
python configure.py
make
sudo make install
cd "$directory/ros_catkin_ws"

#More dependencies
pip uninstall em #empy and em have colliding namespaces
pip install empy
pip install pyqt5

#Get catkin tools (instead of using isolated build)
pip install catkin-tools
pip install trollius

PYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
PYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))")
#Must disable opencv support for python 2
#./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DPYTHON_INCLUDE_DIR=$PYTHON_INCLUDE_DIR -DPYTHON_LIBRARY=$PYTHON_LIBRARY -DBUILD_opencv_python2=OFF
#Use build tools instead
catkin build

########################################
## SETUP MAVLINK MAVROS
########################################
#cd $directory
#source $envname/

#mkdir -p ~/catkin_ws/src
#cd ~/catkin_ws
