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

if(KPSR_PRODUCTION)
    cmake_policy(SET CMP0063 NEW)
    message(STATUS "Building in production mode.")
endif()
macro(set_production_visibility target_name)
    if(KPSR_PRODUCTION)
        set_target_properties(${target_name} PROPERTIES CXX_VISIBILITY_PRESET
                                                        hidden)
        set_target_properties(${target_name}
                              PROPERTIES VISIBILITY_INLINES_HIDDEN On)
        add_custom_command(
            TARGET ${target_name}
            POST_BUILD
            COMMAND $<$<CONFIG:release>:${CMAKE_STRIP}> ARGS --strip-unneeded
                    $<TARGET_FILE:${target_name}>)
    else(KPSR_PRODUCTION)
        set_target_properties(${target_name} PROPERTIES CXX_VISIBILITY_PRESET
                                                        default)
        set_target_properties(${target_name}
                              PROPERTIES VISIBILITY_INLINES_HIDDEN Off)
    endif()
endmacro()
