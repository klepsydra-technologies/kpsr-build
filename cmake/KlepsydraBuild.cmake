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

# Add all targets to the build-tree export set
macro(add_core_export_target)
    foreach(EXPORT_TARGET ${ARGN})
        list(APPEND CORE_EXPORT_TARGETS "${EXPORT_TARGET}")
    endforeach()
    set(CORE_EXPORT_TARGETS
        ${CORE_EXPORT_TARGETS}
        PARENT_SCOPE)
endmacro()

macro(add_csp_export_target)
    foreach(EXPORT_TARGET ${ARGN})
        list(APPEND CSP_EXPORT_TARGETS "${EXPORT_TARGET}")
    endforeach()
    set(CSP_EXPORT_TARGETS
        ${CSP_EXPORT_TARGETS}
        PARENT_SCOPE)
endmacro()

macro(add_zmq_export_target)
    foreach(EXPORT_TARGET ${ARGN})
        list(APPEND ZMQ_EXPORT_TARGETS "${EXPORT_TARGET}")
    endforeach()
    set(ZMQ_EXPORT_TARGETS
        ${ZMQ_EXPORT_TARGETS}
        PARENT_SCOPE)
endmacro()

macro(add_rtps_export_target)
    foreach(EXPORT_TARGET ${ARGN})
        list(APPEND RTPS_EXPORT_TARGETS "${EXPORT_TARGET}")
    endforeach()
    set(RTPS_EXPORT_TARGETS
        ${RTPS_EXPORT_TARGETS}
        PARENT_SCOPE)
endmacro()

# Add all include dirs to the build-tree export set
macro(add_include_dirs)
    foreach(INCLUDE_DIR ${ARGN})
        list(APPEND EXPORT_INCLUDE_DIRS "${INCLUDE_DIR}")
    endforeach()
    set(EXPORT_INCLUDE_DIRS
        ${EXPORT_INCLUDE_DIRS}
        PARENT_SCOPE)
endmacro()
