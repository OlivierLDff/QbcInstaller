# Qt Binary Creator CMake

## What it is

This project is a CMake wrapper arround`qtinstallerframework`. Documentation is available [here](https://doc.qt.io/qtinstallerframework/ifw-tools.html). The only tool of this framework used is binaryCreator that create an installer for a folder

This utility has been developed for my own needs. Don't hesitate to use / share / fork / modify / improve it freely :)

## How to use it

### How to integrate it to your CMake configuration

All you need to do is include the cmake script then call `add_qt_binary_creator` macro.

```cmake
INCLUDE(QtBinaryCreatorCMake/AddQtBinaryCreator.cmake)
add_qt_binary_creator(MyApp)
```

The you can simply run

```bash
make MyAppInstaller
```

Of course, ```add_qt_binary_creator``` accepts more options, see below for the detail.

## Options of the ```add_qt_binary_creator``` macro

The first argument is the target the macro should deploy an app for. It will automatically generate a target.

- `${MY_TARGET}Installer` that pack and generate an installer.

The macro also accepts optional named arguments. Any combination of these arguments is valid. Example:

```cmake
add_qt_binary_creator(my_app
    NAME "My App"
    INSTALLER_NAME "MyAppInstaller"
    VERSION "1.2.3"
    PUBLISHER "My Company"
    PRODUCT_URL "www.myapp.com"
    START_MENU "My Company Menu"
    TITLE "Installer Title"
    PACKAGE "org.mycompany.myapp"
    FILE_EXTENSION "appExtension"
    ICON "path/to.icon.ico" #or png on Linux or icns on Mac
    RELEASE_DATE "29-01-2018"
    BUILD_DIR "path/to/MyAppInstallerBuild"
    OUTPUT_DIR "path/to/MyAppInstallerOutput"
    VERBOSE_INSTALLER
    ALL
 )
```

Here is the full list of possible arguments:

**NAME**

The name of the application. If not given, the name of the source target is taken. The default is `${TARGET}`.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    NAME "My App"
)
```

**INSTALLER_NAME**

Name of the installer target. The default is `${TARGET}InstallerX64` or  `${TARGET}InstallerX32` depending is 32 bits or 64 bits is selected. 

*Example:*

```cmake
add_qt_binary_creator(MyApp
    INSTALLER_NAME "MyAppInstallerName"
)
```

 You can then run this target with `make MyAppInstallerName` .

**VERSION**

Literal version that will be displayed with the application. The default is `1.0.0`.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    VERSION "1.2.3"
)
```

**PUBLISHER**

Literal version that will be displayed with the application.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    PUBLISHER "My Company"
)
```

**PRODUCT_URL**

Literal version that will be displayed with the application.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    PRODUCT_URL "www.myapp.com"
)
```

**PACKAGE**

The name of the application package. If not given, `org.qtproject.${TARGET}` , where source_target is the name of the source target, is taken.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    PACKAGE "org.mycompany.myapp"
)
```

**FILE_EXTENSION**

You can specify extension that will be associate with you app.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    FILE_EXTENSION "appExtension"
)
```

**START_MENU**

You can specify in in which menu category the app will be. By default this is equal to **PUBLISHER**

*Example:*

```cmake
add_qt_binary_creator(MyApp
    START_MENU "My Start Menu"
)
```

**TITLE**

You can specify the title of the installer of your application. By default the name of the application.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    TITLE "My App Installer"
)
```

**RELEASE_DATE**

You can specify a release date. By default this is the date of the last CMake run.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    RELEASE_DATE "18-02-2018"
)
```

**RUN_PROGRAM**

You can specify the name of the program to run by the installer at the end. By default this is equal to **NAME**.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    RUN_PROGRAM "MyApp.exe"
)
```

**ICON**

The icon that will be used for the generated installer executable. The format of the icon **MUST** be:

- Windows : `ico`
- Linux : `png`
- MacOs : `icns`

*Example:*

```cmake
add_qt_binary_creator(MyApp
    ICON "path/to/icon.ico"
)
```

**BUILD_DIR**

You can specify the path of the build dir. By default this is `${PROJECT_BINARY_DIR}/${TARGET}`.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    BUILD_DIR "path/to/buildDir"
)
```

**OUTPUT_DIR**

You can specify the path of the build dir. This is where the executable is going to be generated. By default `${PROJECT_BINARY_DIR}`.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    OUTPUT_DIR "path/to/outputDir"
)
```

**DEPENDS**

Additional targets to depend on.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    DEPENDS additional_target
)
```

**ALL**

If the deploy and installer is run when typing `make all`

*Example:*

```cmake
add_qt_binary_creator(MyApp
    ALL
)
```

**VERBOSE_INSTALLER**

If you want to see all of the output of `binarycreator`. This can be really useful when debugging.

*Example:*

```cmake
add_qt_binary_creator(MyApp
    VERBOSE_INSTALLER
)

```

## Contact

- Olivier Le Doeuff: olivier.ldff@gmail.com