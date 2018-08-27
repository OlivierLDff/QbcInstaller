# QT Binary Creator Wrapper

The goal of this project is to offer a simple CMake wrapper project to deploy binary installer. This is based on the qt program `binarycreator`. The project aim is not be build alone but inside another project hierarchy, it can be fully customizable.

## Variables

* **QBC_DEPENDS_TARGET**: Target for which it will create an installer. The `TARGET_FILE_DIR` will be copied in the installer and then deploy, be sure the `TARGET_FILE_DIR` is only containing necessary stuff. *Default: ""*.
* **QBC_PROJECT_NAME**: Name of the project. *Default: QtBinaryCreator*
* **QBC_VERBOSE**: Print configuration and binary creator verbose [ON OFF]. *Default: ON*
* **QBC_ALL**: If on the target will depends on the make target ALL [ON OFF]. *Default: ON*
* **QBC_NAME**: Name of the
* **QBC_VERSION**: Version of the installer. *Default: 1.0.0*
* **QBC_TITLE**: Installer Title. *Default: Install QBC_NAME*
* **QBC_PUBLISHER**: Name of the publisher. *Default: Publisher*
* **QBC_PRODUCT_URL**: Product URL. *Default www.product.com*
* **QBC_START_MENU**: Name of the start menu on windows where the shortcut will be set. *Default: QBC_PUBLISHER*
* **QBC_ICON_PATH**: Path to the icon
* **QT_INSTALLER_FRAMEWORK_DIR**: Path to the executable file `binarycreator`. For windows it it already set by default in `bin/Win32`.
* **QBC_RELEASE_DATE**: Specify a release date. It is set to now by default.
* **QBC_PACKAGE**: Package name. *Default: QBC_PUBLISHER.QBC_NAME.QBC_PACKAGE_NAME*
* **QBC_PACKAGE_NAME**: Name of the package, *Default: QBC_NAME.*
* **QBC_PACKAGE_VERSION**: Version of the package. *Default: QBC_VERSION*
* **QBC_PACKAGE_DEFAULT**: Is the package installer by default [ON OFF]. *Default: ON*

## Output

* **QBC_OUTPUT_PATH**:  `/path/to/installer.exe`