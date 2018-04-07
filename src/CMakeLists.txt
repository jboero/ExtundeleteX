cmake_minimum_required(VERSION 3.9)
project(ExtundeleteX)

set(CMAKE_CXX_STANDARD 17)

set(SOURCE
  ${SOURCE}
  PARENT_SCOPE
)

set(HEADERS
  ${HEADERS}
  PARENT_SCOPE
)

#include_directories(${PROJECT_BINARY_DIR}/src)

add_executable(extundelete extundelete.cc  cli.cc block.c  insertionops.cc  block.h  extundelete.h  extundelete-priv.h  jfs_compat.h  kernel-jbd.h)
target_link_libraries(extundelete ext2fs com_err)
