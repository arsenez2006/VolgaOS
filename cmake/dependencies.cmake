function(find_dependencies)
    if(BUILD_DOCS)
        find_package(Doxygen)
    endif()

    if(DD_PATH)
        set(DD ${DD_PATH} CACHE FILEPATH "Program path.")
    endif()

    if(SFDISK_PATH)
        set(SFDISK ${SFDISK_PATH} CACHE FILEPATH "Program path.")
    endif()

    # Find DD
    if(NOT DD)
        message(CHECK_START "Detecting DD executable")
        find_program(DD dd)

        if(NOT DD)
            message(CHECK_FAIL "failed.")
            message(FATAL_ERROR "Failed to find DD executable. Use DD_PATH.")
        else()
            message(CHECK_PASS ${DD})
        endif()
    endif()

    # Find SFDISK
    if(NOT SFDISK)
        message(CHECK_START "Detecting SFDISK executable")
        find_program(SFDISK sfdisk)

        if(NOT SFDISK)
            message(CHECK_FAIL "failed.")
            message(FATAL_ERROR "Failed to find SFDISK executable. Use SFDISK_PATH.")
        else()
            message(CHECK_PASS ${SFDISK})
        endif()
    endif()
endfunction(find_dependencies)
