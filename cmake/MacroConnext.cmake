##############################################################################
# Connext_IDLGEN(idlfilename)
#
# Macro to generate Connext DDS sources from a given idl file with the
# data structures.
# You must include the extension .idl in the name of the data file.
#
##############################################################################
# Courtersy of Ivan Galvez Junquera <ivgalvez@gmail.com>
##############################################################################

# Macro to create a list with all the generated source files for a given .idl
# filename
macro(DEFINE_Connext_SOURCES IDL_FILENAME GEN_SOURCE_DIR)
    set(outsources)
    get_filename_component(FULL_PATH_FILENAME ${IDL_FILENAME} ABSOLUTE)
    get_filename_component(FILENAME ${IDL_FILENAME} NAME_WE)
    set(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}.cxx
                   ${GEN_SOURCE_DIR}/gen/${FILENAME}.hpp)
    set(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}Impl.cxx
                   ${GEN_SOURCE_DIR}/gen/${FILENAME}Impl.hpp)
    set(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}Plugin.cxx
                   ${GEN_SOURCE_DIR}/gen/${FILENAME}Plugin.hpp)
    set(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}Support.cxx
                   ${GEN_SOURCE_DIR}/gen/${FILENAME}Support.hpp)
endmacro(DEFINE_Connext_SOURCES)

macro(Connext_IDLGEN IDL_FILENAME GEN_SOURCE_DIR)
    get_filename_component(FULL_PATH_FILENAME ${IDL_FILENAME} ABSOLUTE)
    get_filename_component(IDL_FILENAME ${IDL_FILENAME} NAME)
    define_connext_sources(${ARGV})
    add_custom_command(
        OUTPUT ${outsources}
        COMMAND ${RTICODEGEN} ARGS -d ${GEN_SOURCE_DIR}/gen -replace -language
                C++11 ${FULL_PATH_FILENAME}
        DEPENDS ${FULL_PATH_FILENAME})
endmacro(Connext_IDLGEN)

function(Connext_GENDATAMODEL GEN_SOURCE_FILENAME GEN_SOURCE_DIR)
    string(REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1.cxx" VARS_1
                         ${GEN_SOURCE_FILENAME})
    string(REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1.hpp" VARS_2
                         ${GEN_SOURCE_FILENAME})
    string(REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1Plugin.cxx"
                         VARS_3 ${GEN_SOURCE_FILENAME})
    string(REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1Plugin.hpp"
                         VARS_4 ${GEN_SOURCE_FILENAME})
    set(Connext_DATAMODEL
        ${Connext_DATAMODEL} ${VARS_1} ${VARS_2} ${VARS_3} ${VARS_4}
        PARENT_SCOPE)
endfunction()
