# Check if libext2fs is available
include(CheckLibraryExists)
include(CMakePushCheckState)
include(CheckSymbolExists)
include(CheckTypeSize)
include(TestBigEndian)

# Check that libext2fs.so is available
check_library_exists(libext2fs.so "_init" libext2fs.so HAVE_LIBEXT2FS)
if (NOT HAVE_LIBEXT2FS)
  message(FATAL_ERROR "libext2fs.so was not found. Please install it or make sure your lib directory is in the PATH environment variable.")
endif()
#find_library(LIBEXT2FS
#    NAMES libext2fs.so
#    HINTS "${CMAKE_LIBRARY_PATH}")
#if (LIBEXT2FS)
#  set(HAVE_LIBEXT2FS 1)
#  message(' ')
#else()
#  message(FATAL_ERROR "libext2fs was not found. Please install it or make sure your lib directory is in the PATH variable.")
#endif()

# Check if ext2fs headers are available
include(CheckIncludeFile)
check_include_file(ext2fs/ext2fs.h HAVE_EXT2FS)
if (HAVE_EXT2FS)
  set(EXT2FS_H ext2fs/ext2fs.h)
else()
  message(FATAL_ERROR "e2fsprogs library is not available on your system, please compile and install it.")
endif()


# Checking for various header files
check_include_file(fcntl.h HAVE_FCNTL_H)

check_include_file(getopt.h HAVE_GETOPT_H)

check_include_file(inttypes.h HAVE_INTTYPES_H)

check_include_file(memory.h HAVE_MEMORY_H)

check_include_file(stdlib.h HAVE_STDLIB_H)

check_include_file(stdarg.h HAVE_STDARG_H)

check_include_file(string.h HAVE_STRING_H)

check_include_file(float.h HAVE_FLOAT_H)

if (HAVE_STDLIB_H AND HAVE_STDARG_H AND HAVE_STRING_H AND HAVE_FLOAT_H)
  set(STDC_HEADERS 1)
endif()

check_include_file(stdint.h HAVE_STDINT_H)

check_include_file(strings.h HAVE_STRINGS_H)

check_include_file(sys/stat.h HAVE_SYS_STAT_H)

check_include_file(sys/types.h HAVE_SYS_TYPES_H)

check_include_file(unistd.h HAVE_UNISTD_H)

check_include_file(utime.h HAVE_UTIME_H)


# Check for various libraries
check_library_exists(libcom_err.so "_init" libcom_err.so HAVE_LIBCOM_ERR)
if (NOT HAVE_LIBCOM_ERR)
  message(FATAL_ERROR "libcom_err.so was not found. Please install it or make sure your lib directory is in the PATH environment variable.")
endif()


# Check for various ext2fs functions and types
set(CMAKE_EXTRA_INCLUDE_FILES ext2fs/ext2fs.h)

check_type_size(blk64_t BLK64_T)
if (HAVE_BLK64_T)
  set(HAVE_BLK64_T 1)
endif()

check_type_size(ext2fs_blocks_count HAVE_EXT2FS_BLOCKS_COUNT)

check_type_size(ext2fs_bmap2 HAVE_EXT2FS_BMAP2)

check_type_size(ext2fs_extent_open2 HAVE_EXT2FS_EXTENT_OPEN2)

check_type_size(ext2fs_get_array HAVE_EXT2FS_GET_ARRAY)

check_type_size(ext2fs_get_generic_bitmap_start HAVE_EXT2FS_GET_GENERIC_BITMAP_START)

check_type_size(ext2fs_get_generic_bmap_start HAVE_EXT2FS_GET_GENERIC_BMAP_START)

check_type_size(ext2fs_group_of_blk2 HAVE_EXT2FS_GROUP_OF_BLK2)

check_type_size(ext2fs_inode_table_loc HAVE_EXT2FS_INODE_TABLE_LOC)

check_type_size(ext2fs_read_dir_block3 HAVE_EXT2FS_READ_DIR_BLOCK3)

check_type_size(ext2fs_test_block_bitmap2 HAVE_EXT2FS_TEST_BLOCK_BITMAP2)

check_type_size(ext2fs_test_inode_bitmap2 HAVE_EXT2FS_TEST_INODE_BITMAP2)

CMAKE_RESET_CHECK_STATE()


# Check for _Bool
check_type_size(_Bool HAVE__BOOL)


# Check if stdbool.h conforms to C99
CHECK_STDBOOL_C99(HAVE_STDBOOL_H)


# Check stat behaviour
CHECK_LSTAT_FOLLOWS_SLASHED_SYMLINK(LSTAT_FOLLOWS_SLASHED_SYMLINK)

CHECK_HAVE_STAT_EMPTY_STRING_BUG(HAVE_STAT_EMPTY_STRING_BUG)


# CHECK_FUNCTION_EXISTS is a custom check from ExtraFunctions.cmake
CHECK_FUNCTION_EXISTS(memset)

CHECK_FUNCTION_EXISTS(mkdir)

CHECK_FUNCTION_EXISTS(strerror)

CHECK_FUNCTION_EXISTS(strtol)

CHECK_FUNCTION_EXISTS(strtoul)


# Check system endianness
test_big_endian(WORDS_BIGENDIAN)


# TODO: add checks for file bit offset
# TODO: add definition for large files, on AIX-style hosts
# TODO: Define to empty if `const' does not conform to ANSI C
# TODO: Define to `unsigned int' if <sys/types.h> does not define.
# TODO: Define if building universal (internal helper macro)
# Check file bit offset
#CHECK_FILE_BIT_OFFSET()

# Configure file
configure_file(
    "${PROJECT_SOURCE_DIR}/cmake/config.h.in"
    "${PROJECT_BINARY_DIR}/config.h"
)
include_directories(${PROJECT_BINARY_DIR})
