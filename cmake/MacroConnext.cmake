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


# Macro to create a list with all the generated source files for a given .idl filename
MACRO (DEFINE_Connext_SOURCES IDL_FILENAME GEN_SOURCE_DIR)
	SET(outsources)
	GET_FILENAME_COMPONENT(FULL_PATH_FILENAME ${IDL_FILENAME} ABSOLUTE)
	GET_FILENAME_COMPONENT(FILENAME ${IDL_FILENAME} NAME_WE)
	SET(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}.cxx ${GEN_SOURCE_DIR}/gen/${FILENAME}.hpp)
	SET(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}Impl.cxx ${GEN_SOURCE_DIR}/gen/${FILENAME}Impl.hpp)
	SET(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}Plugin.cxx ${GEN_SOURCE_DIR}/gen/${FILENAME}Plugin.hpp)
	SET(outsources ${outsources} ${GEN_SOURCE_DIR}/gen/${FILENAME}Support.cxx ${GEN_SOURCE_DIR}/gen/${FILENAME}Support.hpp)
ENDMACRO(DEFINE_Connext_SOURCES)

MACRO (Connext_IDLGEN IDL_FILENAME GEN_SOURCE_DIR)
	GET_FILENAME_COMPONENT(FULL_PATH_FILENAME ${IDL_FILENAME} ABSOLUTE)
	GET_FILENAME_COMPONENT(IDL_FILENAME ${IDL_FILENAME} NAME)
	DEFINE_Connext_SOURCES(${ARGV})
	ADD_CUSTOM_COMMAND (
		OUTPUT ${outsources}
		COMMAND ${Connext_IDLGEN_BINARY}
		ARGS  -d ${GEN_SOURCE_DIR}/gen -replace -language C++11 ${FULL_PATH_FILENAME}
		DEPENDS ${FULL_PATH_FILENAME}
	)
ENDMACRO (Connext_IDLGEN)

FUNCTION(Connext_GENDATAMODEL GEN_SOURCE_FILENAME GEN_SOURCE_DIR)
        string (REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1.cxx" VARS_1 ${GEN_SOURCE_FILENAME})
        string (REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1.hpp" VARS_2 ${GEN_SOURCE_FILENAME})
        string (REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1Plugin.cxx" VARS_3 ${GEN_SOURCE_FILENAME})
        string (REGEX REPLACE "\(.*\).idl" "${GEN_SOURCE_DIR}/gen/\\1Plugin.hpp" VARS_4 ${GEN_SOURCE_FILENAME})
        set(Connext_DATAMODEL ${Connext_DATAMODEL} ${VARS_1} ${VARS_2} ${VARS_3} ${VARS_4} PARENT_SCOPE)
ENDFUNCTION()
