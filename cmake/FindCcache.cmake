# Copyright 2023 Klepsydra Technologies AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
    message(STATUS "Looking for CCACHE - found")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(
        GLOBAL PROPERTY RULE_LAUNCH_LINK ccache) # Less useful to do it for
                                                 # linking, see edit2
else()
    message(STATUS "Looking for CCACHE - not found")
endif(CCACHE_FOUND)
