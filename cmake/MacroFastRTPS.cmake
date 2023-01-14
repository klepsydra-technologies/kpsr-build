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

if(NOT DEFINED FASTRTPSGEN)
    if(DEFINED ENV{FASTRTPSGEN})
        set(FASTRTPSGEN $ENV{FASTRTPSGEN})
    else()
        message(
            FATAL_ERROR
                "$FASTRTPSGEN not specified. Please set -DFASTRTPSGEN= to the location to your FastRTPSGen executable"
        )
    endif()
endif()

# Macro to create a list with all the generated source files for a given .idl
# filename
macro(DEFINE_FastRTPS_SOURCES IDL_FILENAME GEN_SOURCE_DIR)
    set(outsources)
    get_filename_component(FULL_PATH_FILENAME ${IDL_FILENAME} ABSOLUTE)
    get_filename_component(FILENAME ${IDL_FILENAME} NAME_WE)
    set(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}.cxx
                   ${GEN_SOURCE_DIR}/gen/${FILENAME}.h)
    set(outsources
        ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}PubSubTypes.cxx
        ${GEN_SOURCE_DIR}/gen/${FILENAME}PubSubTypes.h)
endmacro(DEFINE_FastRTPS_SOURCES)

macro(FASTRTPS_IDLGEN IDL_FILENAME GEN_SOURCE_DIR)
    get_filename_component(FULL_PATH_FILENAME ${IDL_FILENAME} ABSOLUTE)
    define_fastrtps_sources(${ARGV})
    add_custom_command(
        OUTPUT ${outsources}
        COMMAND ${FASTRTPSGEN} ARGS -d ${GEN_SOURCE_DIR}/gen -replace
                ${FULL_PATH_FILENAME}
        DEPENDS ${FULL_PATH_FILENAME})
endmacro(FASTRTPS_IDLGEN)

function(FastRTPS_GENDATAMODEL GEN_SOURCE_FILENAME GEN_SOURCE_DIR)
    string(REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1.cxx" VARS_1
                         ${GEN_SOURCE_FILENAME})
    string(REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1.h" VARS_2
                         ${GEN_SOURCE_FILENAME})
    string(REGEX
           REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1PubSubTypes.cxx"
                   VARS_3 ${GEN_SOURCE_FILENAME})
    string(REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1PubSubTypes.h"
                         VARS_4 ${GEN_SOURCE_FILENAME})
    set(FastRTPS_DATAMODEL
        ${FastRTPS_DATAMODEL} ${VARS_1} ${VARS_2} ${VARS_3} ${VARS_4}
        PARENT_SCOPE)
endfunction()
