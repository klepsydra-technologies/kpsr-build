# Copyright (c) 2022 - 2024, Klepsydra Technologies Gmbh
# All rights reserved.

option(KPSR_ENABLE_EXAMPLES "Enable building and installing examples" OFF)

if(MINIMAL_BUILD)
    option(KPSR_ENABLE_TESTS "Enable tests" OFF)
else()
    option(KPSR_ENABLE_TESTS "Enable tests" ON)
endif()
