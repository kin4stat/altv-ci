set(_xwin_base "$ENV{XWIN_ROOT}")

file(GLOB msvc_dirs "${XWIN_BASE}/VC/Tools/MSVC/*")
list(GET msvc_dirs 0 msvc_path)
get_filename_component(MSVC_VER "${msvc_path}" NAME)

file(GLOB sdk_dirs "${XWIN_BASE}/Windows Kits/10/include/*")
list(GET sdk_dirs 0 sdk_path)
get_filename_component(WINSDK_VER "${sdk_path}" NAME)

message(STATUS "Detected MSVC version: ${MSVC_VER}")
message(STATUS "Detected Windows SDK version: ${WINSDK_VER}")

set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR X86)

set(CMAKE_C_COMPILER clang-cl-19)
set(CMAKE_CXX_COMPILER clang-cl-19)
set(CMAKE_AR llvm-lib-19)
set(CMAKE_LINKER lld-link-19)
set(CMAKE_MT llvm-mt-19)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(COMPILE_FLAGS
    --target=x86_64-pc-windows-msvc
    -Wno-unused-command-line-argument # Needed to accept projects pushing both -Werror and /MP
    /winsysroot ${_xwin_base}
    /EHsc
    -fuse-ld=lld-link-19)

string(REPLACE ";" " " COMPILE_FLAGS "${COMPILE_FLAGS}")

set(_CMAKE_C_FLAGS_INITIAL "${CMAKE_C_FLAGS}" CACHE STRING "")
set(CMAKE_C_FLAGS "${_CMAKE_C_FLAGS_INITIAL} ${COMPILE_FLAGS}" CACHE STRING "" FORCE)

set(_CMAKE_CXX_FLAGS_INITIAL "${CMAKE_CXX_FLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS "${_CMAKE_CXX_FLAGS_INITIAL} ${COMPILE_FLAGS}" CACHE STRING "" FORCE)

set(LINK_FLAGS /winsysroot:${_xwin_base})

string(REPLACE ";" " " LINK_FLAGS "${LINK_FLAGS}")
set(_CMAKE_EXE_LINKER_FLAGS_INITIAL "${CMAKE_EXE_LINKER_FLAGS}" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "${_CMAKE_EXE_LINKER_FLAGS_INITIAL} ${LINK_FLAGS}" CACHE STRING "" FORCE)

set(_CMAKE_MODULE_LINKER_FLAGS_INITIAL "${CMAKE_MODULE_LINKER_FLAGS}" CACHE STRING "")
set(CMAKE_MODULE_LINKER_FLAGS "${_CMAKE_MODULE_LINKER_FLAGS_INITIAL} ${LINK_FLAGS}" CACHE STRING "" FORCE)

set(_CMAKE_SHARED_LINKER_FLAGS_INITIAL "${CMAKE_SHARED_LINKER_FLAGS}" CACHE STRING "")
set(CMAKE_SHARED_LINKER_FLAGS "${_CMAKE_SHARED_LINKER_FLAGS_INITIAL} ${LINK_FLAGS}" CACHE STRING "" FORCE)

set(RC_FLAGS -imsvc"${_xwin_base}/VC/Tools/MSVC/${MSVC_VER}/include"
    -imsvc"${_xwin_base}/Windows Kits/10/include/${WINSDK_VER}/ucrt"
    -imsvc"${_xwin_base}/Windows Kits/10/include/${WINSDK_VER}/shared"
    -imsvc"${_xwin_base}/Windows Kits/10/include/${WINSDK_VER}/um"
    -imsvc"${_xwin_base}/Windows Kits/10/include/${WINSDK_VER}/winrt")

string(REPLACE ";" " " RC_FLAGS "${RC_FLAGS}")

set(_CMAKE_RC_FLAGS_INITIAL "${CMAKE_RC_FLAGS}" CACHE STRING "")
set(CMAKE_RC_FLAGS "${_CMAKE_RC_FLAGS_INITIAL} ${RC_FLAGS}" CACHE STRING "" FORCE)
