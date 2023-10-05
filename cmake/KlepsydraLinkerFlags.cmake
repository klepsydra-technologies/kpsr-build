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

macro(kpsr_set_linker_flags)
    # Use old behaviour and set RPATH instead of RUNPATH. calling ldconfig is
    # not necessary after this.
    set(CMAKE_EXE_LINKER_FLAGS
        "${CMAKE_EXE_LINKER_FLAGS} -Wl,--disable-new-dtags")
    # use, i.e. don't skip the full RPATH for the build tree
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
    # when building, don't use the install RPATH already (but later on when
    # installing)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    # don't add the automatically determined parts of the RPATH which point to
    # directories outside the build tree to the install RPATH
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    if(NOT APPLE)
        set(CMAKE_INSTALL_RPATH "\$ORIGIN")
        check_cxx_compiler_flag(-Wl,--no-undefined HAS_NO_UNDEFINED)
        if(HAS_NO_UNDEFINED)
            set(CMAKE_EXE_LINKER_FLAGS
                "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-undefined")
            set(CMAKE_SHARED_LINKER_FLAGS
                "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
            set(CMAKE_MODULE_LINKER_FLAGS
                "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
        endif()
    endif()
endmacro()
