### Docker

**Note: Gazebo GUI will not work with docker. (even if you forward X11)**

First, ensure docker is properly installed. 
Then execute the following commands from this directory:

    docker build -t par .

Next, pick a location on the host system to store the development workspace.
This allows for persistence between sessions. `~/catkin_ws` is recomended. 
Once you've selected a location, you will need the _absolute_ path. An easy way
to determine this is to run `pwd` when in the desired development directory.

Finally, the docker image can be started. Substitute the absolute path, but
do not change anything to the right of the semicolon. You may want to save
(or alias) this command, you'll need to run this every time you work on ros 
scripts.

    docker run -ti -v /absolute/path/to/catkin_ws:/root/catkin_ws par 

The _first time_ you run the image, the workspace (located in /root/catkin_ws
in the container) is empty. Mavros, Mavlink, and other dependencies need to be
initialized. From inside the container, run:

    cd /root
    ./initialize-docker-env.sh

You should also clone any repositories that you plan to
contribute to into `/root/catkin_ws/src/<my_repo>`

Instructions to forward X11 for Gazebo support will be added at a later date.
