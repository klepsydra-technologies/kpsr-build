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

# Code formatting
find_program(CLANG_FORMAT "clang-format")
if(CLANG_FORMAT)
    # Find all source files
    set(CLANG_FORMAT_CXX_FILE_EXTENSIONS ${CLANG_FORMAT_CXX_FILE_EXTENSIONS}
                                         *.cpp *.h *.cxx *.hpp *.c)
    file(GLOB_RECURSE ALL_SOURCE_FILES ${CLANG_FORMAT_CXX_FILE_EXTENSIONS})

    # Don't include some common build folders
    set(CLANG_FORMAT_EXCLUDE_PATTERNS
        ${CLANG_FORMAT_EXCLUDE_PATTERNS}
        "/CMakeFiles/"
        "cmake"
        "thirdparties"
        "code_generator"
        "kpsr-build"
        "kpe-build"
        "gen"
        "kidl")

    # Get all project files file
    foreach(SOURCE_FILE ${ALL_SOURCE_FILES})
        foreach(EXCLUDE_PATTERN ${CLANG_FORMAT_EXCLUDE_PATTERNS})
            string(FIND ${SOURCE_FILE} ${EXCLUDE_PATTERN} EXCLUDE_FOUND)
            if(NOT ${EXCLUDE_FOUND} EQUAL -1)
                list(REMOVE_ITEM ALL_SOURCE_FILES ${SOURCE_FILE})
            endif()
        endforeach()
    endforeach()

    add_custom_target(
        format
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMENT "Running clang-format to change files"
        VERBATIM
        COMMAND ${CLANG_FORMAT} -style=file -i ${ALL_SOURCE_FILES})

    add_custom_target(
        formatcheck
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMENT "Running clang-format to check files"
        VERBATIM
        COMMAND
            bash -c
            "echo '${ALL_SOURCE_FILES}' | xargs -n 1 | xargs -d ';' -I {} bash -c 'diff -u <(cat {}) <(${CLANG_FORMAT} -style=file {})'"
    )
endif()

find_program(CMAKE_CODE_FORMAT "cmake-format")
if(CMAKE_CODE_FORMAT)
    # Find all cmake files
    set(CMAKE_FORMAT_FILE_EXTENSIONS ${CMAKE_FORMAT_FILE_EXTENSIONS} *.cmake
                                     CMakeLists.txt)
    file(GLOB_RECURSE ALL_CMAKE_FILES ${CMAKE_FORMAT_FILE_EXTENSIONS})

    # Exclude some directories and files
    set(CMAKE_FORMAT_EXCLUDE_PATTERNS
        ${CMAKE_FORMAT_EXCLUDE_PATTERNS}
        "/CMakeFiles/"
        "/build/"
        "/bld/"
        "/thirdparties/"
        "/code_generator/"
        "/gen/"
        "/kidl/"
        "CodeCoverage.cmake"
        "CppcheckTargets.cmake"
        "Findcppcheck.cmake")

    if(NOT ${CMAKE_PROJECT_NAME} MATCHES "kp[e|sr]-build")
        set(CMAKE_FORMAT_EXCLUDE_PATTERNS ${CMAKE_FORMAT_EXCLUDE_PATTERNS}
                                          "kpe-build" "kpsr-build")
    endif()

    foreach(CMAKE_FILE ${ALL_CMAKE_FILES})
        foreach(EXCLUDE_PATTERN ${CMAKE_FORMAT_EXCLUDE_PATTERNS})
            string(FIND ${CMAKE_FILE} ${EXCLUDE_PATTERN} EXCLUDE_FOUND)
            if(NOT ${EXCLUDE_FOUND} EQUAL -1)
                list(REMOVE_ITEM ALL_CMAKE_FILES ${CMAKE_FILE})
            endif()
        endforeach()
    endforeach()
    add_custom_target(
        cmake-format
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMENT "Running cmake-format to format cmake files"
        VERBATIM
        COMMAND
            bash -c
            "echo '${ALL_CMAKE_FILES}' | xargs -n 1 | xargs -d ';' -I {} bash -c '${CMAKE_CODE_FORMAT} -c $(find ${PROJECT_SOURCE_DIR} -name .cmake-format.yaml -not -path thirdparties) -i {}'"
    )
    add_custom_target(
        cmake-format-check
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMENT "Running cmake-format to check cmake files"
        VERBATIM
        COMMAND
            bash -c
            "echo '${ALL_CMAKE_FILES}' | xargs -n 1 | xargs -d ';' -I {} bash -c '${CMAKE_CODE_FORMAT} -c $(find ${PROJECT_SOURCE_DIR} -name .cmake-format.yaml -not -path thirdparties) --check {}'"
    )
endif()
