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

macro(get_package_dep_folders target_name)
    get_target_property(target_deps ${target_name} LINK_LIBRARIES)
    file(TO_CMAKE_PATH "${CMAKE_INSTALL_PREFIX}" instPref)
    set(${target_name}_dep_dirs)
    foreach(t IN LISTS target_deps)
        # disable the INTERFACE target due to error later.
        if(TARGET ${t} AND NOT ("${t}" STREQUAL "Boost::disable_autolinking"))
            get_target_property(isImported ${t} IMPORTED)
            get_target_property(isInterface ${t} TYPE)
            if(isImported AND NOT (${isInterface} STREQUAL INTERFACE_LIBRARY))
                get_target_property(depFile ${t} LOCATION)
                if(depFile)
                    get_filename_component(cdepDir ${depFile} DIRECTORY)
                    list(APPEND ${target_name}_dep_dirs ${cdepDir})
                endif()
            elseif(NOT isImported AND (${isInterface} STREQUAL SHARED_LIBRARY))
                get_package_dep_folders(${t})
                list(APPEND ${target_name}_dep_dirs ${${t}_dep_dirs})
            endif()
        endif()
    endforeach()
    list(REMOVE_DUPLICATES ${target_name}_dep_dirs)
    list(APPEND ${target_name}_dep_dirs ${LIBRARY_OUTPUT_PATH})
endmacro()
