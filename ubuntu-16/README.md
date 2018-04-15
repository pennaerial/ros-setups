### Native

Run the scripts in the following order:
1. setup-ros
2. setup-mavlink-mavros
3. setup-install

If you'd rather install everything at once, simply run
`./ez-install.sh`

### Docker

First, ensure docker is properly installed. 
Then execute the following commands from this directory:

    docker build -t par .

Once the image is installed, run with 

    docker run -ti par

Instructions to mount a local development environment (catkin_ws) and forward X11 for Gazebo support will be added at a later date.
