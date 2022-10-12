# Copyright (c) 2022 - 2024, Klepsydra Technologies Gmbh
# All rights reserved.

# Gets the semver 2.0 version using git tags.

macro(get_kpsr_version REPO_VERSION VERSION_FILENAME)
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
            endif()
        else()
            unset(REPO_VERSION)
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

    if(NOT ("${VERSION_FILENAME}" STREQUAL ""))
        message(STATUS "Writing version info to file : ${VERSION_FILENAME}")
        set(VERSION_HEADER_TEXT
            "#ifndef ${REPO_VERSION}_H
#define ${REPO_VERSION}_H
#define ${REPO_VERSION} \"${${REPO_VERSION}}\"
#endif /* ${REPO_VERSION}_H */")

        file(WRITE ${VERSION_FILENAME} ${VERSION_HEADER_TEXT})
    endif()
endmacro() # get_version
