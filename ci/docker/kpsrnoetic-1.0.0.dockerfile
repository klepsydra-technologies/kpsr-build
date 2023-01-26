FROM ros:noetic-ros-core-focal

ENV TZ 'Europe/Madrid'
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install \
    autoconf \
    build-essential \
    ccache \
    cmake \
    cppcheck \
    curl \
    doxygen \
    doxygen-doc \
    gcovr \
    graphviz \
    git \
    gnupg2 \
    lcov \
    libopencv-dev \
    libtool \
    libyaml-cpp-dev \
    libzmqpp-dev \
    locales \
    locales-all \
    ninja-build \
    pkg-config \
    python \
    python3-pip \
    python3-numpy \
    python3-venv \
    ros-noetic-video-stream-opencv \
    ros-noetic-vision-opencv \
    ros-noetic-tf \
    software-properties-common \
    sudo \
    unzip \
    tzdata \
    && \
    ## Cleanup
    apt-get -y autoremove && \
    apt-get -y clean && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/* /usr/share/man/* /var/cache/man/* /usr/share/doc/*

ARG YAMLCPPVERSION="yaml-cpp-0.7.0"
RUN git clone https://github.com/jbeder/yaml-cpp && \
    cd yaml-cpp && git checkout ${YAMLCPPVERSION} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DYAML_CPP_BUILD_TESTS=Off ../ && \
    make -j$(nproc) && \
    make install && \
    cd ../../ && rm -rf yaml-cpp

ARG ZMQVERSION="v4.3.4"
RUN git clone https://github.com/zeromq/libzmq.git && \
    cd libzmq && \
    git checkout ${ZMQVERSION} && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make -j$(nproc) && \
    make install && \
    cd ../../ && rm -rf libzmq

ARG ZMQCPPVERSION="v4.8.0"
RUN git clone https://github.com/zeromq/cppzmq.git && \
    cd cppzmq && \
    git checkout ${ZMQCPPVERSION} && \
    mkdir build && cd build && \
    cmake ../ && \
    make -j$(nproc) && \
    make install && \
    cd ../../ && rm -rf cppzmq

ARG BENCHMARKVERSION="3b3de69400164013199ea448f051d94d7fc7d81f"
RUN git clone https://github.com/google/benchmark.git && \
    cd benchmark && \
    git checkout ${BENCHMARKVERSION} && \
    mkdir build && cd build && \
    cmake -DBENCHMARK_DOWNLOAD_DEPENDENCIES=on -DCMAKE_BUILD_TYPE=Release ../ && \
    make -j$(nproc) && \
    make install && \
    cd ../../ && \
    rm -rf benchmark

ARG PROTOBUFVERSION="v3.19.0"
RUN git clone https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && \
    git checkout ${PROTOBUFVERSION} && \
    git submodule update --init --recursive && \
    ./autogen.sh && ./configure && \
    make -j$(nproc) && \
    sudo make install && ldconfig && \
    cd ../../ && \
    rm -rf protobuf

ARG EIGENVERSION="3.4.0"
RUN git clone https://gitlab.com/libeigen/eigen.git && \
    cd eigen && \
    git checkout ${EIGENVERSION} && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release ../ && \
    make -j$(nproc) && \
    sudo make install && \
    cd ../../ && \
    rm -rf eigen

ARG OPENCVVERSION="3.4.17"
RUN git clone https://github.com/opencv/opencv.git && \
    cd opencv && \
    git checkout ${OPENCVVERSION} && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release ../ && \
    make -j$(nproc) && \
    sudo make install && \
    cd ../../ && \
    rm -rf opencv
