cmake_minimum_required(VERSION 3.20)
project(VolgaOS)

include(cmake/options.cmake)
include(cmake/dependencies.cmake)
include(cmake/create_image.cmake)

# RAMFS temporary dir
set(RAMFS_DIR "${CMAKE_BINARY_DIR}/ramfs")

# Find dependencies
find_dependencies()

# Create OS image
create_image()

# Import legacy bootloader
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

# Import kernel
include(VolgaKernel/import.cmake)
import_VolgaKernel(PATH "${CMAKE_SOURCE_DIR}/VolgaKernel" OUTPUT ${RAMFS_DIR})
list(APPEND RAMFS_TARGETS ${VOLGAKERNEL_TARGET})

# Generate RAMFS image
set(RAMFS_IMAGE "${CMAKE_BINARY_DIR}/ramfs.tar")
add_custom_target(create-ramfs
    COMMAND ${TAR} cvf ${RAMFS_IMAGE} -C ${CMAKE_BINARY_DIR} ramfs
    DEPENDS ${RAMFS_TARGETS}
)

# Write RAMFS image
add_custom_target(write-ramfs
    COMMAND ${DD} if=${RAMFS_IMAGE} of=${OUTPUT_IMAGE} bs=${OUTPUT_KERNEL_BS} count=${OUTPUT_KERNEL_SIZE} seek=${OUTPUT_KERNEL_OFFSET} conv=notrunc
    DEPENDS create-ramfs
)
list(APPEND OS_TARGETS write-ramfs)

# OS image
add_custom_target(${PROJECT_NAME} ALL DEPENDS ${OS_TARGETS})
