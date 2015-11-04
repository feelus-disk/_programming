# the main target, i.e. the executable to build
bin_PROGRAMS = mcsanc

# all source files which go into the main target
mcsanc_SOURCES = main.f calc_proc.f  \
  qq_3d.f qq_4d.f qq_6d.f qg_4d.f qg_4d_2.f qg_6d.f \
  gg_3d.f init_run.f pdf_conv.f read_ewpars.f read_input.f \
  s2n_init.f kin_cuts.f getminmax.f \
  lor_trans.f run_stats.f utils.f sanc_interface.f \
  mt19937.f alphaz.f print_ewpars.f f2cpp_getters.f

# FORTRAN compiler flags to be used for the main target
AM_FFLAGS = -I$(srcdir)/../include -fno-automatic

noinst_LIBRARIES = libShmHist.a 
libShmHist_a_SOURCES = \
  ShmHist.cc hist_interface.cc csigfun.cc timing.cc 

libShmHist_a_CPPFLAGS = -I$(srcdir)/../include -g -ansi -fPIC -D_REENTRANT

AM_LDFLAGS = -pthread

# libraries to be linked to the main target
LDADD = ../Cuba/libcuba.a \
  ../SANC/modules_cc/libSANCModulesCC.a                \
  ../SANC/modules_nc/libSANCModulesNC.a                \
  ../SANC/libSANC.a                               \
  ../Looptools/libMsLooptoolsXFC.a                \
  ./libShmHist.a				\
  ./libXMLoutput.a				\
  $(LHAPDF_LDFLAGS) -lrt -lstdc++

# XML output
noinst_LIBRARIES += libXMLoutput.a
if HAVE_XML
libXMLoutput_a_SOURCES = xml_output.cc hist_interface.cc
libXMLoutput_a_CPPFLAGS = -I$(srcdir)/../include -g -ansi -fPIC -D_REENTRANT
LDADD+= -ltinyxml2
else
libXMLoutput_a_SOURCES = xml_dumy.f
endif
