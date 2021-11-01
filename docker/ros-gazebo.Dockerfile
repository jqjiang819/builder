FROM ubuntu:focal

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    ca-certificates curl gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://packages.ros.org/ros2/ubuntu focal main" > /etc/apt/sources.list.d/ros2-latest.list
RUN curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO foxy
ENV TURTLEBOT3_MODEL waffle

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-$ROS_DISTRO-ros-core ros-$ROS_DISTRO-turtlebot3-gazebo \
    && rm -rf /var/lib/apt/lists/*

COPY ros-gazebo/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["ros2", "launch", "turtlebot3_gazebo", "turtlebot3_world.launch.py"]