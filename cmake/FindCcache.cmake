find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
    message(STATUS "Looking for CCACHE - found")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache) # Less useful to do it for linking, see edit2
else()
    message(STATUS "Looking for CCACHE - not found")
endif(CCACHE_FOUND)
