<p align="right">
  <img width="25%" height="25%"src="./images/klepsydra_logo.jpg">
</p>

# Installation Instructions

## System dependencies

* Ubuntu 14.04 or above
* ConcurrentQueue (https://github.com/klepsydra-technologies/concurrentqueue)
* Cereal (https://github.com/klepsydra-technologies/cereal)
* spdlog (https://github.com/klepsydra-technologies/spdlog)
* Pistache (https://github.com/klepsydra-technologies/pistache)
* ROS Indigo or above (optional)
* ZMQ 3 or above (optional)
* DDS (optional)
* YAML-CPP (optional)
* Cmake 3.5.1 or above
* gcc for C++11 5.4.0 or above.
* Doxygen

## System installation

	sudo apt install build-essentials
	sudo apt install git
	sudo apt install cmake
	git clone https://github.com/google/googletest.git

### Yaml-cpp

If this software package is not available in the system (it is shipped with some software, e.g. ROS).

Clone and install YAML-CPP:

	git clone https://github.com/jbeder/yaml-cpp
	cd yaml-cpp
	mkdir build
	cd build
	cmake -DBUILD_SHARED_LIBS=ON ..
	make
	sudo make install

# Installation Instructions


### ROS Installation

```
cd build_utils
mkdir -p kpsr_ros/src
cd kpsr_ros/src
source /opt/ros/melodic/setup.bash
catkin_init_workspace
```

#  License

&copy; Copyright 2019-2020, Klepsydra Technologies, all rights reserved. Licensed under the terms in [LICENSE.md](./LICENSE.md)

This software and documentation are Copyright 2019-2020, Klepsydra Technologies
Limited and its licensees. All rights reserved. See [license file](./LICENSE.md) for full copyright notice and license terms.

#  Contact

https://www.klepsydra.com
support@klepsydra.com

