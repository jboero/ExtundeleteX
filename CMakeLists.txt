cmake_minimum_required(VERSION 3.9)
project(ExtundeleteX)

set(CMAKE_CXX_STANDARD 17)

# Declare and set version
set(ExtundeleteX_VERSION_MAJOR 0)
set(ExtundeleteX_VERSION_MINOR 2)
set(ExtundeleteX_VERSION_PATCH 4)
set(ExtundeleteX_VERSION ${ExtundeleteX_VERSION_MAJOR}.${ExtundeleteX_VERSION_MINOR}.${ExtundeleteX_VERSION_PATCH})

add_definitions(-DVERSION="\\"${ExtundeleteX_VERSION}\\"")

# Declare and set other package variables
set(PACKAGE_NAME \"extundeletex\")
set(PACKAGE_TARNAME \"extundeletex\")
set(PACKAGE_VERSION \"${ExtundeleteX_VERSION}\")
string(REGEX REPLACE "([0-9].[0-9].[0-9])" "extundeletex \\1" PACKAGE_STRING "${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT \"https://github.com/AbysmalBiscuit/ExtundeleteX/issues\")
set(PACKAGE_URL \"https://github.com/AbysmalBiscuit/ExtundeleteX\")
set(PACKAGE \"extundeletex\")

# Append project cmake modules directory to module path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

# Prepare cmake paths if they are not already set
include(ExtraFunctions)
if (NOT CMAKE_PREFIX_PATH)
  set(CMAKE_PREFIX_PATH ${CMAKE_SYSTEM_PREFIX_PATH})
endif()
if (NOT CMAKE_INCLUDE_PATH)
  set(CMAKE_INCLUDE_PATH ${CMAKE_PREFIX_PATH})
  APPEND("/$" CMAKE_INCLUDE_PATH include ${CMAKE_PREFIX_PATH})
endif()
if (NOT CMAKE_LIBRARY_PATH)
  set(CMAKE_LIBRARY_PATH ${CMAKE_PREFIX_PATH})
  APPEND("/$" CMAKE_LIBRARY_PATH lib ${CMAKE_PREFIX_PATH})
endif()

# Perform configure checks
include(ConfigureChecks)

# Add src subdirectory which will finish the configuration process
include_directories("${PROJECT_SOURCE_DIR}/src")
add_subdirectory(src)

# build a CPack driven installer package
include (InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_EXECUTABLES "${PROJECT_BINARY_DIR}/src/extundelete")
set(CPACK_PACKAGE_VERSION ${ExtundeleteX_VERSION})
set(CPACK_PACKAGE_VERSION_MAJOR ${ExtundeleteX_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${ExtundeleteX_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${ExtundeleteX_VERSION_PATCH})
set(CPACK_PACKAGE_NAME ${PACKAGE_NAME})
set(CPACK_PACKAGE_TARNAME ${PACKAGE_TARNAME})
set(CPACK_PACKAGE_VERSION ${PACKAGE_VERSION})
set(CPACK_PACKAGE_STRING ${PACKAGE_STRING})
set(CPACK_PACKAGE_BUGREPORT ${PACKAGE_BUGREPORT})
set(CPACK_PACKAGE_URL ${PACKAGE_URL})
set(CPACK_PACKAGE ${PACKAGE})
include(CPack)

