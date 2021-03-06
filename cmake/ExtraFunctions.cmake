# Appends a value to each member of the list.
function(APPEND regexFilter outlist postfix)
  set(listVar "")
  foreach(f ${ARGN})
    string(REGEX REPLACE "${regexFilter}" "" tempVal "${f}")
    list(APPEND listVar "${tempVal}/${postfix}")
  endforeach(f)
  set(${outlist} "${listVar}" PARENT_SCOPE)
endfunction(APPEND)



include(CheckCSourceCompiles)
set(confDefs "
#define HAVE_SYS_TYPES_H ${HAVE_SYS_TYPES_H}
#define HAVE_SYS_STAT_H ${HAVE_SYS_STAT_H}
#define STDC_HEADERS ${STDC_HEADERS}
#define HAVE_STDLIB_H ${HAVE_STDLIB_H}
#define HAVE_STRING_H ${HAVE_STRING_H}
#define HAVE_MEMORY_H ${HAVE_MEMORY_H}
#define HAVE_STRINGS_H ${HAVE_STRINGS_H}
#define HAVE_INTTYPES_H ${HAVE_INTTYPES_H}
#define HAVE_STDINT_H ${HAVE_STDINT_H}
#define HAVE_UNISTD_H ${HAVE_UNISTD_H}
#define LSTAT_FOLLOWS_SLASHED_SYMLINK ${LSTAT_FOLLOWS_SLASHED_SYMLINK}
")

set(defaultTestIncludes "
#include <stdio.h>
#ifdef HAVE_SYS_TYPES_H
# include <sys/types.h>
#endif
#ifdef HAVE_SYS_STAT_H
# include <sys/stat.h>
#endif
#ifdef STDC_HEADERS
# include <stdlib.h>
# include <stddef.h>
#else
# ifdef HAVE_STDLIB_H
#  include <stdlib.h>
# endif
#endif
#ifdef HAVE_STRING_H
# if !defined STDC_HEADERS && defined HAVE_MEMORY_H
#  include <memory.h>
# endif
# include <string.h>
#endif
#ifdef HAVE_STRINGS_H
# include <strings.h>
#endif
#ifdef HAVE_INTTYPES_H
# include <inttypes.h>
#endif
#ifdef HAVE_STDINT_H
# include <stdint.h>
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif
")

# Checks to see if stdbool.h conforms to the C99 standard.
function(CHECK_STDBOOL_C99 outVar)
  # TEST_CODE was taken from configure that was generated by GNU Autoconf 2.69
  # for extundelete 0.2.4-3-gaf881b9.
  set(TEST_CODE "
${confDefs}

#include <stdbool.h>
#ifndef bool
#error: bool is not defined
#endif
#ifndef false
#error: false is not defined
#endif
#if false
#error: false is not 0
#endif
#ifndef true
#error: true is not defined
#endif
#if true != 1
#error: true is not 1
#endif
#ifndef __bool_true_false_are_defined
#error: __bool_true_false_are_defined is not defined
#endif

${defaultTestIncludes}

struct s { _Bool s: 1; _Bool t; } s;

char a[true == 1 ? 1 : -1];
char b[false == 0 ? 1 : -1];
char c[__bool_true_false_are_defined == 1 ? 1 : -1];
char d[(bool) 0.5 == true ? 1 : -1];
/* See body of main program for 'e'.  */
char f[(_Bool) 0.0 == false ? 1 : -1];
char g[true];
char h[sizeof (_Bool)];
char i[sizeof s.t];
enum { j = false, k = true, l = false * true, m = true * 256 };
/* The following fails for
  HP aC++/ANSI C B3910B A.05.55 [Dec 04 2003]. */
_Bool n[m];
char o[sizeof n == m * sizeof n[0] ? 1 : -1];
char p[-1 - (_Bool) 0 < 0 && -1 - (bool) 0 < 0 ? 1 : -1];
/* Catch a bug in an HP-UX C compiler.  See
  http://gcc.gnu.org/ml/gcc-patches/2003-12/msg02303.html
  http://lists.gnu.org/archive/html/bug-coreutils/2005-11/msg00161.html
*/
_Bool q = true;
_Bool *pq = &q;

int main () {
  bool e = &s;
  *pq |= q;
  *pq |= ! q;
  /* Refer to every declared value, to avoid compiler optimizations.  */
  return (!a + !b + !c + !d + !e + !f + !g + !h + !i + !!j + !k + !!l
         + !m + !n + !o + !p + !q + !pq);

  ;
  return 0;}
")
  check_c_source_compiles("${TEST_CODE}" check_stdbool_conforms_to_C99)
  if (check_stdbool_conforms_to_C99)
    set(${outVar} 1 PARENT_SCOPE)
  endif()
endfunction(CHECK_STDBOOL_C99)


# Check if stat dereferences a symlink specified with a trailing slash.
function(CHECK_LSTAT_FOLLOWS_SLASHED_SYMLINK outVar)
  # TEST_CODE was taken from configure that was generated by GNU Autoconf 2.69
  # for extundelete 0.2.4-3-gaf881b9.
  set(tmpDir "${PROJECT_BINARY_DIR}/CMakeFiles/CMakeTmp")
  execute_process(COMMAND rm -f "${tmpDir}/conftest.file" "${tmpDir}/conftest.sym"
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  execute_process(COMMAND touch "${tmpDir}/conftest.file"
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  execute_process(COMMAND ln -s "${tmpDir}/conftest.file" "${tmpDir}/conftest.sym"
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  set(TEST_CODE "
${confDefs}

${defaultTestIncludes}

int main ()
{
struct stat sbuf;
     /* Linux will dereference the symlink and fail, as required by POSIX.
	That is better in the sense that it means we will not
	have to compile and use the lstat wrapper.  */
     return lstat (\"conftest.sym/\", &sbuf) == 0;
  ;
  return 0;
}
")
  check_c_source_compiles("${TEST_CODE}" check_lstat_follows_slashed_symlink)

  # Clean up after test
  execute_process(COMMAND rm -f "${tmpDir}/conftest.file" "${tmpDir}/conftest.sym"
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  if (check_lstat_follows_slashed_symlink)
    set(${outVar} 1 PARENT_SCOPE)
  endif()
endfunction(CHECK_LSTAT_FOLLOWS_SLASHED_SYMLINK)



# Checks if stat has the bug that it succeeds when given the zero-length file
# name argument.
function(CHECK_HAVE_STAT_EMPTY_STRING_BUG outVar)
  # TEST_CODE was taken from configure that was generated by GNU Autoconf 2.69
  # for extundelete 0.2.4-3-gaf881b9.
  set(TEST_CODE "
${confDefs}

${defaultTestIncludes}

int main ()
{
struct stat sbuf;
  return stat (\"\", &sbuf) == 0;
  ;
  return 0;
}
")
  check_c_source_compiles("${TEST_CODE}" check_have_stat_empty_string_bug)
  if (NOT check_stdbool_conforms_to_C99)
    set(${outVar} 1 PARENT_SCOPE)
  endif()
endfunction(CHECK_HAVE_STAT_EMPTY_STRING_BUG)



function(CHECK_FUNCTION_EXISTS funcToTest)
  # TEST_CODE was taken from configure that was generated by GNU Autoconf 2.69
  # for extundelete 0.2.4-3-gaf881b9.
  set(TEST_CODE "
${confDefs}

/* Define ${funcToTest} to an innocuous variant, in case <limits.h> declares ${funcToTest}.
   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
#define ${funcToTest} innocuous_${funcToTest}

/* System header to define __stub macros and hopefully few prototypes,
    which can conflict with char ${funcToTest} (); below.
    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
    <limits.h> exists even on freestanding compilers.  */

#ifdef __STDC__
# include <limits.h>
#else
# include <assert.h>
#endif

#undef ${funcToTest}

/* Override any GCC internal prototype to avoid an error.
   Use char because int might match the return type of a GCC
   builtin and then its argument prototype would still apply.  */
#ifdef __cplusplus
extern \"C\"
#endif
char ${funcToTest} ();
/* The GNU C library defines this for functions which it implements
    to always fail with ENOSYS.  Some functions are actually named
    something starting with __ and the normal name is an alias.  */
#if defined __stub_${funcToTest} || defined __stub___${funcToTest}
choke me
#endif

int main () {
return ${funcToTest} ();
  ;
  return 0;
}
")
  check_c_source_compiles("${TEST_CODE}" check_have_${funcToTest})
  if (check_have_${funcToTest})
    string(TOUPPER ${funcToTest} tempVar)
    set(HAVE_${tempVar} 1 PARENT_SCOPE)
    unset(tempVar)
  endif()
endfunction(CHECK_FUNCTION_EXISTS)



# Check number of bits in a file offset, on hosts where this is settable.
function(CHECK_FILE_BIT_OFFSET)
  # TEST_CODE was taken from configure that was generated by GNU Autoconf 2.69
  # for extundelete 0.2.4-3-gaf881b9.
  set(TEST_CODE "
${confDefs}

#include <sys/types.h>
 /* Check that off_t can represent 2**63 - 1 correctly.
    We can''t simply define LARGE_OFF_T to be 9223372036854775807,
    since some C++ compilers masquerading as C compilers
    incorrectly reject 9223372036854775807.  */
#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
		       && LARGE_OFF_T % 2147483647 == 1)
		      ? 1 : -1];
int
main ()
{

  ;
  return 0;
}
")
  check_c_source_compiles("${TEST_CODE}" check_file_bit_offset)
  if (check_file_bit_offset)
    set(_FILE_OFFSET_BITS ${check_file_bit_offset}  PARENT_SCOPE)
  endif()
endfunction(CHECK_FILE_BIT_OFFSET)

