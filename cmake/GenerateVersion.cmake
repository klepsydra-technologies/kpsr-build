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

# Gets the semver 2.0 version using git tags.

macro(get_kpsr_version REPO_VERSION VERSION_FILENAME)
    if(EXISTS ${VERSION_FILENAME})
        file(STRINGS ${VERSION_FILENAME} THIS_FILE
             REGEX "^const std::string ${REPO_VERSION}")
        while(THIS_FILE)
            list(POP_FRONT THIS_FILE LINE)
            if(LINE MATCHES "^const std::string ${REPO_VERSION}")
                string(REGEX MATCH "${REPO_VERSION}.*[^=] " _MATCHED ${LINE})
                string(REGEX MATCH "(${REPO_VERSION}.*) = \"(.+)\"" _MATCHED_v
                             ${LINE})
                set(_${CMAKE_MATCH_1} ${CMAKE_MATCH_2})
                message("Found : _${CMAKE_MATCH_1} = ${_${CMAKE_MATCH_1}}")
            endif()
        endwhile()

    endif()
    find_package(Git)
    if(GIT_FOUND)
        # Generate a git-describe version string from Git repository tags
        execute_process(
            COMMAND ${GIT_EXECUTABLE} describe --tags --abbrev=5 --match "v*"
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
            RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        if(NOT GIT_DESCRIBE_ERROR_CODE)
            string(REGEX REPLACE "^v([0-9]+)\\..*" "\\1" ${REPO_VERSION}_MAJOR
                                 "${GIT_DESCRIBE_VERSION}")
            string(REGEX
                   REPLACE "^v[0-9]+\\.([0-9]+).*" "\\1" ${REPO_VERSION}_MINOR
                           "${GIT_DESCRIBE_VERSION}")
            string(REGEX
                   REPLACE "^v[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1"
                           ${REPO_VERSION}_PATCH "${GIT_DESCRIBE_VERSION}")
            string(REGEX REPLACE "^v[0-9]+\\.[0-9]+\\.[0-9]+(.*)" "\\1"
                                 ${REPO_VERSION}_SHA1 "${GIT_DESCRIBE_VERSION}")
            set(${REPO_VERSION}
                ${${REPO_VERSION}_MAJOR}.${${REPO_VERSION}_MINOR}.${${REPO_VERSION}_PATCH}
            )
            set(${REPO_VERSION}_PATCH_EXT ${${REPO_VERSION}_PATCH})
            string(REGEX
                   REPLACE "^\\-([0-9]+)-g(.*)" "\\1"
                           ${REPO_VERSION}_SHA1_COUNT "${${REPO_VERSION}_SHA1}")
            if(${${REPO_VERSION}_SHA1_COUNT})
                string(
                    REGEX
                    REPLACE "^\\-([0-9]+)-g(.*)" "\\2"
                            ${REPO_VERSION}_SHA1_SHORT
                            "${${REPO_VERSION}_SHA1}")
                string(APPEND ${REPO_VERSION} "-" ${${REPO_VERSION}_SHA1_SHORT})
                string(APPEND ${${REPO_VERSION}_PATCH_EXT} "-"
                       ${${REPO_VERSION}_SHA1_SHORT})
            endif()
        else()
            unset(REPO_VERSION)
        endif()
    endif()

    if(DEFINED _${REPO_VERSION})
        if(${_${REPO_VERSION}} VERSION_LESS "${${REPO_VERSION}}")
            configure_file(${VERSION_FILENAME}.in ${VERSION_FILENAME})
        else()
            set(${REPO_VERSION} ${_${REPO_VERSION}})
            set(${REPO_VERSION}_MAJOR ${_${REPO_VERSION}_MAJOR})
            set(${REPO_VERSION}_MINOR ${_${REPO_VERSION}_MINOR})
            set(${REPO_VERSION}_PATCH ${_${REPO_VERSION}_PATCH})
        endif()
    endif()
    # Final fallback: Just use a bogus version string that is semantically older
    # than anything else and spit out a warning to the developer.
    if(NOT DEFINED ${REPO_VERSION})
        set(${REPO_VERSION} 0.0.0-unknown)
        set(${REPO_VERSION}_MAJOR 0)
        set(${REPO_VERSION}_MINOR 0)
        set(${REPO_VERSION}_PATCH 0)
        message(
            WARNING
                "Failed to determine VERSION from Git tags. Using default version \"${${REPO_VERSION}}\"."
        )
    endif()
endmacro() # get_version
