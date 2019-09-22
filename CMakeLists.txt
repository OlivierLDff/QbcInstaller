#
#   CMake script by Olivier Le Doeuff
#   This is a wrapper around the binaryCreator tool from qt framework (https://doc.qt.io/qtinstallerframework/ifw-tools.html)
#
## CMAKE INPUT
#
#   - QBC_DEPENDS_TARGET : Target for which it will create an installer
#   - QBC_ADDITIONNAL_DEPENDS
#   - QBC_PROJECT_NAME : Name of QtBinaryCreator project in build system, default is QtBinaryCreator
#   - QBC_ALL : Does the project depends on the make all
#   - QBC_NAME : Name of the product for which the installer will be created
#   - QBC_VERSION : Product version
#   - QBC_TITLE : Installer Title (for example Install Product)
#   - QBC_PUBLISHER : Product publisher
#   - QBC_PRODUCT_URL : Product URL
#   - QBC_ICON_PATH : Icon path (it will be copied)
#   - QBC_START_MENU : Start Menu name, this is optionnal it will be set by default to publisher
#   - QT_INSTALLER_FRAMEWORK_DIR : Path to binary creator, can have default values for windows for example where binary is in repository
#   - QBC_RELEASE_DATE : Release Date, will be set to now if not specified
#   - QBC_VERBOSE : Print verbose
#
#   - QBC_PACKAGE : Package name in form org.com.product
#   - QBC_PACKAGE_NAME : Package Name, default to QBC_NAME
#   - QBC_PACKAGE_VERSION : Package Version
#   - QBC_PACKAGE_DEFAULT : Default package to true
#
## CMAKE OUTPUT
#
#   - QBC_OUTPUT_PATH : /path/to/installer.exe
#

cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

include(CMakeParseArguments)

set(QBC_FOUND ON CACHE BOOL "QtBinaryCreatorCMake have been found" FORCE)
set(QBC_SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE STRING "Current CMakeList's directory" FORCE)

message(STATUS "Include add_qt_binary_creator in your project. Source dir is ${QBC_SOURCE_DIR}")

macro(add_qt_binary_creator TARGET)

    set(QBC_OPTIONS
        ALL
        VERBOSE_INSTALLER
       )

    set(QBC_ONE_VALUE_ARG
        NAME
        INSTALLER_NAME
        VERSION
        PUBLISHER
        START_MENU
        TITLE
        PRODUCT_URL
        PACKAGE
        FILE_EXTENSION
        ICON
        DEPENDS
        RUN_PROGRAM
        RELEASE_DATE
        BUILD_DIR
        OUTPUT_DIR
       )

    set(QBC_MULTI_VALUE_ARG)

     # parse the macro arguments
    cmake_parse_arguments(ARGQBC "${QBC_OPTIONS}" "${QBC_ONE_VALUE_ARG}" "${QBC_MULTI_VALUE_ARG}" ${ARGN})

    set(QBC_DEPENDS_TARGET ${TARGET})

    if(ARGQBC_NAME)
        set(QBC_NAME ${ARGQBC_NAME})
    else()
        set(QBC_NAME ${TARGET})
    endif()

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(QBC_TARGET_DIR @ApplicationsDirX64@/${QBC_NAME})
        set(QBC_X X64)
    else(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(QBC_TARGET_DIR @ApplicationsDirX86@/${QBC_NAME})
        set(QBC_X X86)
    endif(CMAKE_SIZEOF_VOID_P EQUAL 8)

    if(ARGQBC_INSTALLER_NAME)
        set(QBC_INSTALLER_TARGET_NAME ${ARGQBC_INSTALLER_NAME})
    else()
        set(QBC_INSTALLER_TARGET_NAME ${QBC_DEPENDS_TARGET}Installer${QBC_X})
    endif()

    if(ARGQBC_VERSION)
        set(QBC_VERSION ${ARGQBC_VERSION})
    else()
        set(QBC_VERSION "1.0.0")
    endif()

    if(ARGQBC_TITLE)
        set(QBC_TITLE ${ARGQBC_TITLE})
    else()
        set(QBC_TITLE ${QBC_NAME})
    endif()

    if(ARGQBC_RELEASE_DATE)
        set(QBC_RELEASE_DATE ${ARGQBC_RELEASE_DATE})
    else()
        set(QBC_RELEASE_DATE)
        string(TIMESTAMP QBC_RELEASE_DATE "%Y-%m-%d")
    endif()

    if(ARGQBC_DEPENDS)
        set(QBC_ADDITIONNAL_DEPENDS ${ARGQBC_DEPENDS})
    endif() # ARGQBC_DEPENDS

    if(ARGQBC_RUN_PROGRAM)
        set(QBC_PACKAGE_NAME ${ARGQBC_RUN_PROGRAM})
    else() # ARGQBC_RUN_PROGRAM
        set(QBC_PACKAGE_NAME ${QBC_NAME})
    endif() # ARGQBC_RUN_PROGRAM
    set(QBC_PACKAGE_NAME_SHORTCUT ${QBC_NAME})
    set(QBC_PACKAGE_VERSION ${QBC_VERSION})
    set(QBC_PACKAGE_DEFAULT ON)

    if(ARGQBC_PUBLISHER)
        set(QBC_PUBLISHER ${ARGQBC_PUBLISHER})
    else() # ARGQBC_PUBLISHER
        set(QBC_PUBLISHER ${QBC_NAME})
    endif() # ARGQBC_PUBLISHER

    if(ARGQBC_PACKAGE)
        set(QBC_PACKAGE ${ARGQBC_PACKAGE})
    else() # ARGQBC_PACKAGE
        set(QBC_PACKAGE org.${QBC_PUBLISHER}.${QBC_NAME})
    endif() # ARGQBC_PACKAGE

    if(ARGQBC_START_MENU)
        set(QBC_START_MENU ${ARGQBC_START_MENU})
    else() # ARGQBC_START_MENU
        set(QBC_START_MENU ${QBC_PUBLISHER})
    endif() # ARGQBC_START_MENU

    if(ARGQBC_ICON)
        set(QBC_ICON_PATH ${ARGQBC_ICON})
        get_filename_component(QBC_ICON_OUTPUT_NAME ${QBC_ICON_PATH} NAME)
        get_filename_component(QBC_ICON_OUTPUT_NAME_WE ${QBC_ICON_PATH} NAME_WE)
        get_filename_component(QBC_ICON_OUTPUT_EXT ${QBC_ICON_PATH} EXT)
    endif() # ARGQBC_ICON

    if(ARGQBC_RUN_PROGRAM)
        set(QBC_RUN_PROGRAM @TargetDir@/${ARGQBC_RUN_PROGRAM})
    else() # ARGQBC_RUN_PROGRAM
        set(QBC_RUN_PROGRAM @TargetDir@/${QBC_NAME})
    endif() # ARGQBC_RUN_PROGRAM

    if(ARGQBC_OUTPUT_DIR)
        set(QBC_OUTPUT_DIR ${ARGQBC_OUTPUT_DIR})
    else() # ARGQBC_OUTPUT_DIR
        set(QBC_OUTPUT_DIR ${PROJECT_BINARY_DIR})
    endif() # ARGQBC_OUTPUT_DIR

    if(ARGQBC_BUILD_DIR)
        set(QBC_BUILD_DIR ${ARGQBC_BUILD_DIR})
    else() # ARGQBC_BUILD_DIR
        set(QBC_BUILD_DIR ${PROJECT_BINARY_DIR}/${QBC_INSTALLER_TARGET_NAME})
    endif() # ARGQBC_BUILD_DIR

    if(ARGQBC_PRODUCT_URL)
        set(QBC_PRODUCT_URL ${ARGQBC_PRODUCT_URL})
    endif() # ARGQBC_PRODUCT_URL

    # ────────── LOG CONFIGURATION ────────────────

    if(ARGQBC_VERBOSE_INSTALLER)
        message(STATUS "---- QtBinaryCreatorCMake Configuration ----")
        message(STATUS "TARGET:                 ${TARGET}")
        message(STATUS "NAME:                   ${QBC_NAME}")
        message(STATUS "INSTALLER_NAME:         ${QBC_INSTALLER_TARGET_NAME}")
        message(STATUS "VERSION:                ${QBC_VERSION}")
        message(STATUS "TITLE:                  ${QBC_TITLE}")
        message(STATUS "PUBLISHER:              ${QBC_PUBLISHER}")
        message(STATUS "PRODUCT_URL:            ${ARGQBC_PRODUCT_URL}")
        message(STATUS "PACKAGE:                ${QBC_PACKAGE}")
        message(STATUS "START_MENU:             ${QBC_START_MENU}")
        message(STATUS "FILE_EXTENSION:         ${ARGQBC_FILE_EXTENSION}")
        message(STATUS "ICON:                   ${QBC_ICON_PATH}")
        message(STATUS "DEPENDS:                ${ARGQBC_DEPENDS}")
        message(STATUS "ALL:                    ${ARGQBC_ALL}")
        message(STATUS "VERBOSE_INSTALLER:      ${ARGQBC_VERBOSE_INSTALLER}")
        message(STATUS "RUN_PROGRAM:            ${QBC_RUN_PROGRAM}")
        message(STATUS "RELEASE_DATE:           ${QBC_RELEASE_DATE}")
        message(STATUS "QBC_X:                  ${QBC_X}")
        message(STATUS "CMAKE_SYSTEM_NAME:      ${CMAKE_SYSTEM_NAME}")
        message(STATUS "QBC_OUTPUT_DIR:         ${QBC_OUTPUT_DIR}")
        message(STATUS "QBC_BUILD_DIR:          ${QBC_BUILD_DIR}")
        message(STATUS "QBC_SOURCE_DIR:         ${QBC_SOURCE_DIR}")
        message(STATUS "---- End QtBinaryCreatorCMake Configuration ----")
    endif() # ARGQBC_VERBOSE_INSTALLER

    if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
        set(QT_INSTALLER_FRAMEWORK_DIR ${QBC_SOURCE_DIR}/bin/Win32)
        if(ARGQBC_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL ".ico")
            message(FATAL_ERROR "${ARGQBC_ICON} isn't a .ico file (${QBC_ICON_OUTPUT_EXT})")
        endif() # ARGQBC_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL ".ico"
    endif() # ${CMAKE_SYSTEM_NAME} STREQUAL "Windows"

    if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
        set(QT_INSTALLER_FRAMEWORK_DIR ${QBC_SOURCE_DIR}/bin/Linux)
        if(ARGQBC_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL ".png")
            message(FATAL_ERROR "${ARGQBC_ICON} isn't a .png file")
        endif() # ARGQBC_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL ".png"
    endif() # ${CMAKE_SYSTEM_NAME} STREQUAL "Linux"

    if(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
        set(QT_INSTALLER_FRAMEWORK_DIR ${QBC_SOURCE_DIR}/bin/Darwin)
        if(ARGQBC_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL ".icns")
            message(FATAL_ERROR "${ARGQBC_ICON} isn't a .icns file")
        endif() # ARGQBC_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL ".icns"
    endif() # ${CMAKE_SYSTEM_NAME} STREQUAL "Darwin"

    # ────────── CONFIGURE FILES ────────────────

    ## ICON
    if(QBC_ICON_OUTPUT_NAME)
        configure_file(${QBC_ICON_PATH} ${QBC_BUILD_DIR}/config/${QBC_ICON_OUTPUT_NAME} COPYONLY)
    endif() # QBC_ICON_OUTPUT_NAME

    ## CONFIG.XML
    configure_file(${QBC_SOURCE_DIR}/src/config.xml.in ${QBC_BUILD_DIR}/config/config.xml @ONLY)

    ## PACKAGE.XML
    configure_file(${QBC_SOURCE_DIR}/src/package.xml.in ${QBC_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/package.xml @ONLY)

    configure_file(${QBC_SOURCE_DIR}/src/desktopcheckboxform.ui ${QBC_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/desktopcheckboxform.ui COPYONLY)
    configure_file(${QBC_SOURCE_DIR}/src/startmenucheckboxform.ui ${QBC_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/startmenucheckboxform.ui COPYONLY)
    configure_file(${QBC_SOURCE_DIR}/src/registerfilecheckboxform.ui ${QBC_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/registerfilecheckboxform.ui COPYONLY)

    ## INSTALLSCRIPT.JS
    set(QBC_TARGET_DIR_JS @TargetDir@)
    set(QBC_START_MENU_DIR_JS @StartMenuDir@)
    set(QBC_DESKTOP_DIR_JS @DesktopDir@)
    configure_file(${QBC_SOURCE_DIR}/src/installscript.qs.in ${QBC_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/installscript.qs @ONLY)

    # ────────── BINARY CREATOR ────────────────

    if(ARGQBC_ALL)
        set(QBC_ALL ALL)
    endif() # ARGQBC_ALL

    if(ARGQBC_VERBOSE_INSTALLER)
        set(QBC_VERBOSE -v)
    endif() # ARGQBC_VERBOSE_INSTALLER

    add_custom_target(${QBC_INSTALLER_TARGET_NAME}
        ${QBC_ALL}
        DEPENDS ${QBC_DEPENDS_TARGET} ${QBC_ADDITIONNAL_DEPENDS}
        COMMAND ${CMAKE_COMMAND} -E copy_directory $<TARGET_FILE_DIR:${QBC_DEPENDS_TARGET}> ${QBC_BUILD_DIR}/packages/${QBC_PACKAGE}/data
        COMMAND ${QT_INSTALLER_FRAMEWORK_DIR}/binarycreator
            -c ${QBC_BUILD_DIR}/config/config.xml
            -p ${QBC_BUILD_DIR}/packages
            ${QBC_VERBOSE}
            ${QBC_OUTPUT_DIR}/${QBC_INSTALLER_TARGET_NAME}
        COMMENT "Copy $<TARGET_FILE_DIR:${QBC_DEPENDS_TARGET}> to ${QBC_BUILD_DIR}/packages/${QBC_PACKAGE}/data then Launch binarycreator in (${QT_INSTALLER_FRAMEWORK_DIR}), installer will be in ${QBC_OUTPUT_DIR}"

   )

endmacro() # add_qt_binary_creator
