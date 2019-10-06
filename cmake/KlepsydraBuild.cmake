# Add all targets to the build-tree export set
macro (add_core_export_target)
   foreach (EXPORT_TARGET ${ARGN})
      list (APPEND CORE_EXPORT_TARGETS "${EXPORT_TARGET}")
   endforeach()
   set (CORE_EXPORT_TARGETS ${CORE_EXPORT_TARGETS} PARENT_SCOPE)
endmacro()

macro (add_dds_export_target)
   foreach (EXPORT_TARGET ${ARGN})
      list (APPEND DDS_EXPORT_TARGETS "${EXPORT_TARGET}")
   endforeach()
   set (DDS_EXPORT_TARGETS ${DDS_EXPORT_TARGETS} PARENT_SCOPE)
endmacro()

macro (add_zmq_export_target)
   foreach (EXPORT_TARGET ${ARGN})
      list (APPEND ZMQ_EXPORT_TARGETS "${EXPORT_TARGET}")
   endforeach()
   set (ZMQ_EXPORT_TARGETS ${ZMQ_EXPORT_TARGETS} PARENT_SCOPE)
endmacro()

# Add all include dirs to the build-tree export set
macro (add_include_dirs)
   foreach (INCLUDE_DIR ${ARGN})
      list (APPEND EXPORT_INCLUDE_DIRS "${INCLUDE_DIR}")
   endforeach()
   set (EXPORT_INCLUDE_DIRS ${EXPORT_INCLUDE_DIRS} PARENT_SCOPE)
endmacro()

