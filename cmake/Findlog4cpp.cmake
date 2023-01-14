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

IF (LOG4CPP_FOUND)
    SET(LOG4CPP_FIND_QUIETLY TRUE)
ENDIF (LOG4CPP_FOUND)

FIND_PATH(LOG4CPP_INCLUDE_DIRS log4cpp/FileAppender.hh
    "./log4cpp/include/"
)

FIND_LIBRARY(LOG4CPP_LIBRARIES
  NAMES liblog4cpp.so
  PATHS "./log4cpp/lib"
)

SET(LOG4CPP_FOUND 0)
IF(LOG4CPP_INCLUDE_DIRS)
  IF(LOG4CPP_LIBRARIES)
    SET(LOG4CPP_FOUND 1 CACHE INTERNAL "log4cpp found")
    IF (NOT LOG4CPP_FIND_QUIETLY)
      MESSAGE(STATUS "Found Log4CPP")
    ENDIF (NOT LOG4CPP_FIND_QUIETLY)
  ENDIF(LOG4CPP_LIBRARIES)
ENDIF(LOG4CPP_INCLUDE_DIRS)

MARK_AS_ADVANCED(
  LOG4CPP_INCLUDE_DIR
  LOG4CPP_LIBRARIES
) 
