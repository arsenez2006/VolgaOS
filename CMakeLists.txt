cmake_minimum_required(VERSION 3.20)
project(VolgaOS)

include(cmake/options.cmake)
include(cmake/dependencies.cmake)
include(cmake/create_image.cmake)
include(ExternalProject)

find_dependencies()

create_image()

if(VLGBL_LEGACY)
    include(VolgaBL/import.cmake)
    import_VolgaBL(PATH ${CMAKE_SOURCE_DIR}/VolgaBL)
    add_custom_target(VolgaBL-write
        COMMAND ${DD} if=${VOLGABL_MBR} of=${OUTPUT_IMAGE} bs=${OUTPUT_MBR_BS} count=${OUTPUT_MBR_SIZE} seek=${OUTPUT_MBR_OFFSET} conv=notrunc
        COMMAND ${DD} if=${VOLGABL_SSL} of=${OUTPUT_IMAGE} bs=${OUTPUT_SSL_BS} count=${OUTPUT_SSL_SIZE} seek=${OUTPUT_SSL_OFFSET} conv=notrunc
        COMMAND ${DD} if=${VOLGABL_TSL} of=${OUTPUT_IMAGE} bs=${OUTPUT_TSL_BS} count=${OUTPUT_TSL_SIZE} seek=${OUTPUT_TSL_OFFSET} conv=notrunc
        DEPENDS ${VOLGABL_TARGET}
    )
    list(APPEND OS_TARGETS VolgaBL-write)
endif()

add_custom_target(${PROJECT_NAME} ALL DEPENDS ${OS_TARGETS})
