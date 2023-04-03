# ****************************************************************************
#
# Klepsydra Core Modules
# Copyright (C) 2022-2024  Klepsydra Technologies AG
# All Rights Reserved.
#
# This file is subject to the terms and conditions defined in
# file 'LICENSE.md', which is part of this source code package.
#
# NOTICE:  All information contained herein is, and remains the property of Klepsydra
# Technologies AG and its suppliers, if any. The intellectual and technical concepts
# contained herein are proprietary to Klepsydra Technologies AG and its suppliers and
# may be covered by Swiss and Foreign Patents, patents in process, and are protected by
# trade secret or copyright law. Dissemination of this information or reproduction of
# this material is strictly forbidden unless prior written permission is obtained from
# Klepsydra Technologies AG.
#
# ****************************************************************************

# Klespsydra event code generator

macro(
    KpsrEventGenerator
    inputDir
    outputDir
    includePath
    disableRos
    disableZmq
    disableDds)
    find_package(Python3 REQUIRED COMPONENTS Interpreter)
    message(
        STATUS
            "Running code generator: \n${Python3_EXECUTABLE} -m kpsr_codegen -i ${inputDir} -o ${outputDir} -p ${includePath} -r ${disableRos} -z ${disableZmq} -d ${disableDds}\n"
    )
    execute_process(
        COMMAND
            ${Python3_EXECUTABLE} -m kpsr_codegen -i ${inputDir} -o ${outputDir}
            -p ${includePath} -r ${disableRos} -z ${disableZmq} -d ${disableDds}
        RESULT_VARIABLE resVar
        OUTPUT_VARIABLE outVar)
    if(resVar)
        message(
            FATAL_ERROR
                "Could not generate message files with code generator. Got output \n${outVar}"
        )
    endif()
endmacro()
