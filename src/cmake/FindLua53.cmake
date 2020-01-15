# Locate Lua library
# This module defines
#  LUA52_FOUND, if false, do not try to link to Lua
#  LUA_LIBRARIES
#  LUA_INCLUDE_DIR, where to find lua.h
#  LUA_VERSION_STRING, the version of Lua found (since CMake 2.8.8)
#
# Note that the expected include convention is
#  #include "lua.h"
# and not
#  #include <lua/lua.h>
# This is because, the lua location is not standardized and may exist
# in locations other than lua/

#=============================================================================
# Copyright 2007-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

# Find the folder that contains lua.h
find_path(LUA_INCLUDE_DIR lua.h
  HINTS
  ENV LUA_INC_DIR
  PATH_SUFFIXES include/lua53 include/lua5.3 include/lua-5.3 include/lua include
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
  )
# Make sure that the version number is 5.3
if(LUA_INCLUDE_DIR AND EXISTS "${LUA_INCLUDE_DIR}/lua.h")
  file(STRINGS "${LUA_INCLUDE_DIR}/lua.h" lua_version_major_define REGEX "^#define[ \t]+LUA_VERSION_MAJOR")
  file(STRINGS "${LUA_INCLUDE_DIR}/lua.h" lua_version_minor_define REGEX "^#define[ \t]+LUA_VERSION_MINOR")
  if(lua_version_major_define AND lua_version_minor_define)
    string(REGEX MATCH "[0-9]+" lua_version_major ${lua_version_major_define})
    string(REGEX MATCH "[0-9]+" lua_version_minor ${lua_version_minor_define})
    set(LUA_VERSION_STRING "${lua_version_major}.${lua_version_minor}")
    if(${LUA_VERSION_STRING} VERSION_EQUAL "5.3")
      set(LUA_CORRECT_VERSION 1)
    endif()
  endif()
endif()

find_library(LUA_LIBRARY
  NAMES lua53 lua5.3 lua-5.3 lua
  HINTS
  ENV LUA_LIB_DIR
  PATH_SUFFIXES lib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /sw
  /opt/local
  /opt/csw
  /opt
  )

if(LUA_LIBRARY)
  # include the math library for Unix
  if(UNIX AND NOT APPLE AND NOT BEOS)
    find_library(LUA_MATH_LIBRARY m)
    set( LUA_LIBRARIES "${LUA_LIBRARY};${LUA_MATH_LIBRARY}" CACHE STRING "Lua Libraries")
    # For Windows and Mac, don't need to explicitly include the math library
  else()
    set( LUA_LIBRARIES "${LUA_LIBRARY}" CACHE STRING "Lua Libraries")
  endif()
endif()

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LUA_FOUND to TRUE if
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Lua53
  REQUIRED_VARS LUA_LIBRARIES LUA_INCLUDE_DIR LUA_CORRECT_VERSION
  VERSION_VAR LUA_VERSION_STRING)

mark_as_advanced(LUA_INCLUDE_DIR LUA_LIBRARIES LUA_LIBRARY LUA_MATH_LIBRARY)