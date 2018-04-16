FROM ubuntu:16.04

MAINTAINER Edward Atter <atter@seas.upenn.edu>

RUN apt-get update && apt-get install sudo git wget software-properties-common -y
COPY setup-ros.sh /tmp/.
COPY setup-mavlink-mavros.sh /tmp/.
COPY setup-install.sh /tmp/.

RUN cd /tmp && chmod +x setup*.sh

RUN ./tmp/setup-ros.sh
RUN ./tmp/setup-mavlink-mavros.sh
RUN ./tmp/setup-install.sh
RUN rm -rf ~/catkin_ws
RUN mkdir -p ~/catkin_ws

COPY initialize-docker-env.sh /root/.

ENTRYPOINT ["/bin/bash"]
