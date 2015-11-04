# autoconf script for MCSANC

# Prelude.
AC_INIT([mcsanc], [0.0.1], [http://sanc.jinr.ru])
AC_CONFIG_AUX_DIR([build-aux])
AC_PREFIX_DEFAULT(${PWD})

AM_INIT_AUTOMAKE([-Wall -Werror foreign])

# Checks for programs.
#AC_DISABLE_STATIC
AC_PROG_RANLIB
AC_PROG_CXX
AC_PROG_FC([gfortran])
AC_PROG_F77([gfortran])

# Fortran configures
AC_FC_LIBRARY_LDFLAGS
AC_FC_WRAPPERS
AC_F77_WRAPPERS
#AC_FC_FREEFORM

#FCFLAGS="$(FCFLAGS) -ffixed-line-length-132 -fno-range-check"
FFLAGS+=" -ffixed-line-length-132 -fno-range-check"

# Checks for LHAPDF
AC_MSG_CHECKING([if LHAPDF is present and works])
HAS_LHAPDF_CONFIG="no"
LHAPDF_DIR=""
LHAPDF_FOUND="yes"
AC_CHECK_PROG(LHAPDF_CONFIG, [lhapdf-config], [HAS_LHAPDF_CONFIG="yes"],
  [AC_ARG_WITH(LHAPDF, 
    [ AS_HELP_STRING([--with-LHAPDF=DIR], [specify LHAPDF installation directory])], 
    [LHAPDF_DIR="$with_LHAPDF"], [with_LHAPDF=check])]
  )

AS_IF([test "x$HAS_LHAPDF_CONFIG" != "xyes"], [ LHAPDF_LDFLAGS="`lhapdf-config --ldflags`" ],
      [test "x$LHAPDF_DIR" != "x" -a "x$LHAPDF_DIR" != "xno"],
      [ LHAPDF_LDFLAGS="-L$LHAPDF_DIR/lib -lLHAPDF"], 
      [ AC_MSG_ERROR([LHAPDF is required but was not found. Install LHAPDF or use 
    --with-LHAPDF=DIR option to specify LHAPDF location])])

AC_SUBST(LHAPDF_LDFLAGS)

# Checks for header files.
AC_MSG_CHECKING([for tinyxml2])
AC_LANG(C++)
SAVED_LDFLAGS=$LDFLAGS
LDFLAGS="$LDFLAGS -ltinyxml2"
    AC_LINK_IFELSE(
      [AC_LANG_PROGRAM([#include <tinyxml2.h>],
                       [tinyxml2::XMLDocument doc])],
      [AC_MSG_RESULT([yes])]
        [AM_CONDITIONAL([HAVE_XML],[true])],
      [AC_MSG_RESULT([no])]
        [AM_CONDITIONAL([HAVE_XML],[false])]
        [AC_MSG_WARN([tinyxml2 is not installed. XML output is not available.])])
LDFLAGS=$SAVED_LDFLAGS
# Checks for typedefs, structures, and compiler characteristics.
# Checks for library functions.
# Output files.
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile 
		 SANC/Makefile 
		 SANC/modules_cc/Makefile 
		 SANC/modules_nc/Makefile 
                 Looptools/Makefile
                 include/Makefile
		 src/Makefile])

AC_CONFIG_SUBDIRS([Cuba])
AC_OUTPUT
