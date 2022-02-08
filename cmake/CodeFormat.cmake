# Code formatting
find_program(CLANG_FORMAT "clang-format")
if(CLANG_FORMAT)
  # Find all source files
  set(CLANG_FORMAT_CXX_FILE_EXTENSIONS
          ${CLANG_FORMAT_CXX_FILE_EXTENSIONS}
          *.cpp *.h *.cxx *.hpp *.c)
  file(GLOB_RECURSE ALL_SOURCE_FILES ${CLANG_FORMAT_CXX_FILE_EXTENSIONS})

  # Don't include some common build folders
  set(CLANG_FORMAT_EXCLUDE_PATTERNS ${CLANG_FORMAT_EXCLUDE_PATTERNS} "/CMakeFiles/" "cmake" "thirdparties" "code_generator/kpsr_codegen/templates" "code_generator/build" "gen" "/kidl/")

  # Get all project files file
  foreach (SOURCE_FILE ${ALL_SOURCE_FILES})
      foreach (EXCLUDE_PATTERN ${CLANG_FORMAT_EXCLUDE_PATTERNS})
          string(FIND ${SOURCE_FILE} ${EXCLUDE_PATTERN} EXCLUDE_FOUND)
          if (NOT ${EXCLUDE_FOUND} EQUAL -1)
              list(REMOVE_ITEM ALL_SOURCE_FILES ${SOURCE_FILE})
          endif ()
      endforeach ()
  endforeach ()

  add_custom_target(format
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Running clang-format to change files"
      VERBATIM
      COMMAND ${CLANG_FORMAT} -style=file -i ${ALL_SOURCE_FILES})

  add_custom_target(formatcheck
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Running clang-format to check files"
      VERBATIM
      COMMAND bash -c
      "echo '${ALL_SOURCE_FILES}' | xargs -n 1 -d ';' -I {} bash -c 'diff -u <(cat {}) <(${CLANG_FORMAT} -style=file {})'")
endif()
