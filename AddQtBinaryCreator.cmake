#
#	CMake script by Olivier Le Doeuff
#	This is a wrapper around the binaryCreator tool from qt framework (https://doc.qt.io/qtinstallerframework/ifw-tools.html)
#
## CMAKE INPUT
#
#	- QBC_DEPENDS_TARGET : Target for which it will create an installer
#	- QBC_ADDITIONNAL_DEPENDS
#	- QBC_PROJECT_NAME : Name of QtBinaryCreator project in build system, default is QtBinaryCreator
#	- QBC_ALL : Does the project depends on the make all
#	- QBC_NAME : Name of the product for which the installer will be created
# 	- QBC_VERSION : Product version
# 	- QBC_TITLE : Installer Title (for example Install Product)
# 	- QBC_PUBLISHER : Product publisher
# 	- QBC_PRODUCT_URL : Product URL
# 	- QBC_ICON_PATH : Icon path (it will be copied)
#	- QBC_START_MENU : Start Menu name, this is optionnal it will be set by default to publisher
#	- QT_INSTALLER_FRAMEWORK_DIR : Path to binary creator, can have default values for windows for example where binary is in repository
#	- QBC_RELEASE_DATE : Release Date, will be set to now if not specified
#	- QBC_VERBOSE : Print verbose
#
#	- QBC_PACKAGE : Package name in form org.com.product
#	- QBC_PACKAGE_NAME : Package Name, default to QBC_NAME
#	- QBC_PACKAGE_VERSION : Package Version
#	- QBC_PACKAGE_DEFAULT : Default package to true
#
## CMAKE OUTPUT
#
#	- QBC_OUTPUT_PATH : /path/to/installer.exe
#	

CMAKE_MINIMUM_REQUIRED( VERSION 3.1.0 )

macro(add_qt_binary_creator TARGET)
	SET(QT_WINDOWS_OPTIONS 
		ALL
		VERBOSE_INSTALLER
		)
	SET(QT_WINDOWS_ONE_VALUE_ARG 
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

	 # parse the macro arguments
	cmake_parse_arguments(ARG "${QT_WINDOWS_OPTIONS}" "${QT_WINDOWS_ONE_VALUE_ARG}" ${ARGN})

    if(TARGET)
        set(QBC_DEPENDS_TARGET ${TARGET})
    else()
    	message(FATAL_ERROR "No target specified in macro add_qt_binary_creator")
    endif()

    if(ARG_NAME)
        set(QBC_NAME ${ARG_NAME})
    else()
        set(QBC_NAME ${TARGET})
    endif()

    if(ARG_INSTALLER_NAME)
        set(QBC_INSTALLER_TARGET_NAME ${ARG_INSTALLER_NAME})
    else()
        set(QBC_INSTALLER_TARGET_NAME ${QBC_DEPENDS_TARGET}Installer${QBC_X})
    endif()

    if(ARG_VERSION)
        set(QBC_VERSION ${ARG_VERSION})
    else()
        set(QBC_VERSION "1.0.0")
    endif()

    if(ARG_TITLE)
        set(QBC_TITLE ${ARG_TITLE})
    else()
        set(QBC_TITLE ${QBC_NAME})
    endif()

    if(ARG_RELEASE_DATE)
        set(QBC_RELEASE_DATE ${ARG_RELEASE_DATE})
    else()
		SET(QBC_RELEASE_DATE)
		STRING(TIMESTAMP QBC_RELEASE_DATE "%Y-%m-%d")
    endif()

    if(ARG_DEPENDS)
    	set(QBC_ADDITIONNAL_DEPENDS ${ARG_DEPENDS})
    endif(ARG_DEPENDS)

    SET( QBC_PACKAGE_NAME ${QBC_NAME} )
	SET( QBC_PACKAGE_VERSION ${QBC_VERSION} )
	SET( QBC_PACKAGE_DEFAULT ON )

	IF(ARG_PUBLISHER)
		SET( QBC_PUBLISHER ${ARG_PUBLISHER})
	ELSE(ARG_PUBLISHER)
		SET( QBC_PUBLISHER ${QBC_NAME})
	ENDIF(ARG_PUBLISHER)

	IF(ARG_PACKAGE)
		SET( QBC_PACKAGE ${ARG_PACKAGE})
	ELSE(ARG_PACKAGE)
		SET( QBC_PACKAGE org.${QBC_PUBLISHER}.${QBC_NAME})
	ENDIF(ARG_PACKAGE)

	IF(ARG_START_MENU)
		SET( QBC_START_MENU ${ARG_START_MENU} )
	ELSE(ARG_START_MENU)
		SET( QBC_START_MENU ${QBC_PUBLISHER} )
	ENDIF(ARG_START_MENU)

	IF( CMAKE_SIZEOF_VOID_P EQUAL 8 )
		SET( QBC_TARGET_DIR @ApplicationsDirX64@/${QBC_NAME} )
		SET(QBC_X X64)
	ELSE( CMAKE_SIZEOF_VOID_P EQUAL 8 )
		SET( QBC_TARGET_DIR @ApplicationsDirX86@/${QBC_NAME} )
		SET(QBC_X X86)
	ENDIF( CMAKE_SIZEOF_VOID_P EQUAL 8 )

	IF( ARG_ICON )
		SET( QBC_ICON_PATH ${ARG_ICON} )
		GET_FILENAME_COMPONENT( QBC_ICON_OUTPUT_NAME ${QBC_ICON_PATH} NAME )
		GET_FILENAME_COMPONENT( QBC_ICON_OUTPUT_NAME_WE ${QBC_ICON_PATH} NAME_WE )
		GET_FILENAME_COMPONENT( QBC_ICON_OUTPUT_EXT ${QBC_ICON_PATH} EXT )
	ENDIF(ARG_ICON)

	IF(ARG_RUN_PROGRAM)
		SET( QBC_RUN_PROGRAM @TargetDir@/${QBC_NAME} )
	ELSE(ARG_RUN_PROGRAM)
		SET( QBC_RUN_PROGRAM @TargetDir@/${ARG_RUN_PROGRAM} )
	ENDIF(ARG_RUN_PROGRAM)

	IF(ARG_OUTPUT_DIR)
		SET( QBC_OUTPUT_DIR ${ARG_OUTPUT_DIR} )
	ELSE(ARG_OUTPUT_DIR)
		SET( QBC_OUTPUT_DIR ${PROJECT_SOURCE_DIR}/${QBC_INSTALLER_TARGET_NAME} )
	ENDIF(ARG_OUTPUT_DIR)

	IF(ARG_BUILD_DIR)
		SET( QBC_BUILD_DIR ${ARG_BUILD_DIR} )
	ELSE(ARG_BUILD_DIR)
		SET( QBC_BUILD_DIR ${PROJECT_SOURCE_DIR}/${QBC_INSTALLER_TARGET_NAME} )
	ENDIF(ARG_BUILD_DIR)

	MESSAGE(STATUS "QtBinaryCreatorCMake Configuration")
	MESSAGE(STATUS "TARGET:                 ${TARGET}")
	MESSAGE(STATUS "NAME:                   ${QBC_NAME}")
	MESSAGE(STATUS "INSTALLER_NAME:         ${QBC_INSTALLER_TARGET_NAME}")
	MESSAGE(STATUS "VERSION:                ${QBC_VERSION}")
	MESSAGE(STATUS "TITLE:                  ${QBC_TITLE}")
	MESSAGE(STATUS "PUBLISHER:              ${QBC_PUBLISHER}")
	MESSAGE(STATUS "PRODUCT_URL:            ${ARG_PRODUCT_URL}")
	MESSAGE(STATUS "PACKAGE:                ${QBC_PACKAGE}")
	MESSAGE(STATUS "START_MENU:             ${QBC_START_MENU}")
	MESSAGE(STATUS "FILE_EXTENSION:         ${ARG_FILE_EXTENSION}")
	MESSAGE(STATUS "ICON:                   ${QBC_ICON_PATH}")
	MESSAGE(STATUS "DEPENDS:                ${ARG_DEPENDS}")
	MESSAGE(STATUS "ALL:                    ${ARG_ALL}")
	MESSAGE(STATUS "VERBOSE_INSTALLER:      ${ARG_VERBOSE_INSTALLER}")
	MESSAGE(STATUS "RUN_PROGRAM:            ${ARG_RUN_PROGRAM}")
	MESSAGE(STATUS "RELEASE_DATE:           ${QBC_RELEASE_DATE}")
	MESSAGE(STATUS "QBC_X:                  ${QBC_X}")
	MESSAGE(STATUS "CMAKE_SYSTEM_NAME:      ${CMAKE_SYSTEM_NAME}")

	IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
		SET( QT_INSTALLER_FRAMEWORK_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin/Win32 )
		IF(ARG_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL "ico")
			MESSAGE(FATAL_ERROR "${ARG_ICON} isn't a .ico file")
		ENDIF(ARG_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL "ico")
	ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

	IF(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
		SET( QT_INSTALLER_FRAMEWORK_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin/Linux )
		IF(ARG_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL "png")
			MESSAGE(FATAL_ERROR "${ARG_ICON} isn't a .png file")
		ENDIF(ARG_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL "png")
	ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")

	IF(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
		SET( QT_INSTALLER_FRAMEWORK_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin/Darwin )
		IF(ARG_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL "icns")
			MESSAGE(FATAL_ERROR "${ARG_ICON} isn't a .icns file")
		ENDIF(ARG_ICON AND NOT ${QBC_ICON_OUTPUT_EXT} STREQUAL "icns")
	ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")

# ────────── CONFIGURE FILES ────────────────

	## ICON
	IF(QBC_ICON_OUTPUT_NAME)
		CONFIGURE_FILE( ${QBC_ICON_PATH} ${PROJECT_SOURCE_DIR}/${QBC_INSTALLER_TARGET_NAME}/config/${QBC_ICON_OUTPUT_NAME} COPYONLY )
	ENDIF(QBC_ICON_OUTPUT_NAME)

	## CONFIG.XML
	CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/src/config.xml.in ${ARG_BUILD_DIR}/config/config.xml @ONLY)

	## PACKAGE.XML
	CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/src/package.xml.in ${ARG_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/package.xml @ONLY)

	CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/src/desktopcheckboxform.ui ${ARG_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/desktopcheckboxform.ui COPYONLY)
	CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/src/startmenucheckboxform.ui ${ARG_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/startmenucheckboxform.ui COPYONLY)
	CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/src/registerfilecheckboxform.ui ${ARG_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/registerfilecheckboxform.ui COPYONLY)

	## INSTALLSCRIPT.JS
	SET(QBC_TARGET_DIR_JS @TargetDir@)
	SET(QBC_START_MENU_DIR_JS @StartMenuDir@)
	SET(QBC_DESKTOP_DIR_JS @DesktopDir@)
	CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/src/installscript.qs.in ${ARG_BUILD_DIR}/packages/${QBC_PACKAGE}/meta/installscript.qs @ONLY)

	# ────────── BINARY CREATOR ────────────────

	IF(ARG_ALL)
		SET(QBC_ALL ALL)
	ENDIF(ARG_ALL)

	IF(VERBOSE_INSTALLER)
		SET(QBC_VERBOSE -v)
	ENDIF(VERBOSE_INSTALLER)

	ADD_CUSTOM_TARGET( ${QBC_INSTALLER_TARGET_NAME}
		${QBC_ALL}
		DEPENDS ${QBC_DEPENDS_TARGET} ${QBC_ADDITIONNAL_DEPENDS}
		COMMAND echo Copy $<TARGET_FILE_DIR:${QBC_DEPENDS_TARGET}> to ${ARG_BUILD_DIR}/packages/${QBC_PACKAGE}/data
		COMMAND ${CMAKE_COMMAND} -E copy_directory $<TARGET_FILE_DIR:${QBC_DEPENDS_TARGET}> ${ARG_BUILD_DIR}/packages/${QBC_PACKAGE}/data
		COMMAND echo Launch binarycreator
		COMMAND ${QT_INSTALLER_FRAMEWORK_DIR}/binarycreator
			-c ${ARG_BUILD_DIR}/config/config.xml
			-p ${ARG_BUILD_DIR}/packages
			${QBC_VERBOSE}
			${QBC_OUTPUT_DIR}
		)


macro(add_qt_binary_creator TARGET)