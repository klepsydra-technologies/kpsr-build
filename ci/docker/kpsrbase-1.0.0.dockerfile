FROM ubuntu:20.04

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
    clang-format-11 \
    clang-tidy-11 \
    cmake \
    cppcheck \
    curl \
    doxygen \
    doxygen-doc \
    gcovr \
    git \
    gnupg2 \
    graphviz \
    lcov \
    libtool \
    locales \
    locales-all \
    ninja-build \
    pkg-config \
    python \
    python3-pip \
    python3-numpy \
    python3-venv \
    software-properties-common \
    sudo \
    tzdata \
    unzip \
    valgrind && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-11 100 && \
    update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-11 100 && \
    pip3 install cmake-format && \
    ## Cleanup
    apt-get -y autoremove && \
    apt-get -y clean && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/* /usr/share/man/* /var/cache/man/* /usr/share/doc/*

ARG OPENSSLVERSION="OpenSSL_1_1_1i"
RUN git clone https://github.com/openssl/openssl.git && \
    cd openssl && git checkout ${OPENSSLVERSION} && \
    ./config -fPIC shared && \
    make -j$(nproc) && \
    make install && \
    cd ../ && rm -rf openssl

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
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -INSTALL_TESTS=OFF -DINSTALL_PYTHON_EXAMPLES=OFF -DINSTALL_C_EXAMPLES=OFF -DBUILD_opencv_apps=OFF ../ && \
    make -j$(nproc) && \
    sudo make install && \
    cd ../../ && \
    rm -rf opencv
