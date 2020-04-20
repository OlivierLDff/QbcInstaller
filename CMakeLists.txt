cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

include(${CMAKE_CURRENT_LIST_DIR}/AddQtBinaryCreator.cmake)

set(QBC_FOUND ON CACHE BOOL "QtBinaryCreatorCMake have been found" FORCE)
set(QBC_SOURCE_DIR ${QBC_SOURCE_DIR} CACHE STRING "Current CMakeList's directory" FORCE)