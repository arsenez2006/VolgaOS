cmake_minimum_required(VERSION 3.20)
project(VolgaOS)

include(cmake/options.cmake)
include(cmake/dependencies.cmake)
include(cmake/create_image.cmake)

find_dependencies()

create_image()
