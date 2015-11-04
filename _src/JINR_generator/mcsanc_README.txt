----------------------------------------------------------------------
                        mcsanc-v1.01 
----------------------------------------------------------------------

1) Introduction

The mcsanc program is a Monte Carlo tool that allows to calculate NLO EW and
QCD integrated and differential cross sections for several processes in
proton-proton collisions. It is based on the SANC fortran modules
[arXiv:0812.4207] for NLO cross section evaluation. 

The third party packages included in the distributions are 
 - Cuba library for MC integration [hep-ph/0404043]
 - Looptools library for loop integral evaluation [hep-ph/9807565]
These libraries need not to be installed separately.

The PDFs are interfaced by calling LHAPDF, which have to be installed prior
mcsanc installation. 

The mcsanc code supports variable bin histograms, which however can be used
only with gcc version later than 4.5.x. The program users guide is available at
[arXiv:1301.3687]

2) Installation, configuration, running

The compilation procedure is standard for autotools package and requires GNU
autotools to be installed on your system. After downloading the tarball, unpack
and cd into resulting directory:

> tar xzf mcsanc-v1.01.tgz && cd mcsanc-v1.01

Run autotools to produce configure scripts:
> autoreconf --force --install
> ./configure
> make

Read ./configure --help for more details, e.g. custom LHAPDF location.

The "share" directory contains configuration files input.cfg and ewparam.cfg.
Edit input.cfg for general, PDF, vegas, cuts and histograms options. Note, that
adding/removing cuts and histograms requires editing the source code file
"src/kin_cuts.f". The electroweak parameters can be configured in ewparam.cfg.
You can find detailed description of the config parameters in mcsanc manual
[arXiv:1301.3687].

Thanks to Cuba's multiprocessing feature, the calculations can be run on
several cores if you have multiprocessor machine. By default all available
cores are used, but their number can be limited to [N] by setting "CUBACORES"
environment variable:
> export CUBACORES=[N]

This will apply only to your current login shell. Edit your ~.*rc file to set
it for your account. Refer to Cuba documentation for more information.

The executable is created in "src" folder, and the program is run from "share":
> cd share
> ../src/mcsanc [input.cfg]

This will produce the summary output file mcsanc-...-output.txt and a 
separate table file for each histogram. 

3) process list and process selection.

Current version of mcsanc have the following list of processes implemented:
---------------------------------------------------
 pid |    process pp -->
---------------------------------------------------
 001 |  e^+(p_3) + e^-(p_4)                    
 002 |  \mu^+(p_3) + \mu^-(p_4)                
 003 |  \tau^+(p_3) + \tau^-(p_4)              
 004 |  Z^0(p_3) + H(p_4)                      
-------------------------------------------------
 101 |  e^+(p_3) + {\nu}_e(p_4)                
 102 |  \mu^+(p_3) + {\nu}_{\mu}(p_4)          
 103 |  \tau^+(p_3) + {\nu}_{\tau}(p_4)        
-101 |  e^-(p_3) + \bar{\nu}_e(p_4)            
-102 |  \mu^-(p_3) + \bar{\nu}_{\mu}(p_4)      
-103 |  \tau^-(p_3) + \bar{\nu}_{\tau}(p_4)    
-------------------------------------------------
 104 |  W^+(p_3) + H(p_4)                      
-104 |  W^-(p_3) + H(p_4)                      
-------------------------------------------------
 105 |  t(p_3) + \bar{b}(p_4)   (s-channel)      
 106 |  t(p_3) + q(p_4)         (t-channel)            
-105 |  \bar{t}(p_3) + b(p_4)   (s-channel)    
-106 |  \bar{t}(p_3) + q(p_4)   (t-channel)      
---------------------------------------------------

The process is selected by specifying process ID in the input.cfg file. General
rule is that first field of three-digit process ID corresponds to neutral
current (0 or none) or charged current (-1 and 1 for negative and positive
bosons). The other two digits specify the final particle choice: e(1), mu(2),
tau(3), Higgs(4), t-quark (5 - not implemented). 

For example, in the input.cfg:
processid = -102 ! select pp->W- -> mu- nu process
processId = 4   ! select pp->Z->HZ process

4) File map 

Cuba			- Monte Carlo integration library Cuba
Looptools		- Looptools library
SANC			- SANC library and modules
include			- mcsanc include files
 |_ calo.h			- common block (CB) for recombination variables	
 |_ ckm.h			- CB for CKM matrix
 |_ compounds.h		- CB for component names and id's
 |_ constants.h		- parameter definitions
 |_ histogram.h		- CB for histogram values array
 |_ kin_cuts.h		- CB for kinematic cuts
 |_ kinematics.h	- CB for kinematic parameters
 |_ process.h		- general config CB and process id's
 |_ s2n_declare.h	- s2n CB's for SANC modules
 |_ scales.h		- CB with scales for SANC modules
 |_ ShmHist.h		- header file of the shared memory histogram class
 |_ stats.h		- CB with run statistics
 |_ vegas.h		- CB for vegas parameters
src				- mcsanc source files
 |_ alphaz.f		- routines for running alpha_em calculation
 |_ pdf_conv.f		- PDF convolution routines
 |_ sanc_interface.f	- sanc interface functions
 |_ s2n_init.f		- s2n parameter initialization
 |_ q?_?d.f			- component integration routines and integrands
 |_ calc_proc.f		- component calculation selection

 |_ mt19937.f		- 3rd party random number generator
 |_ csigfun.cc		- fortran interface for signal catching function
 |_ timing.cc		- CPU timing routines
		start_clock
		stop_clock(double *ttime, double *utime, double *stime)
 |_ utils.f			- algebraic calculations
 |_ scalar.f		- scalar product for 4-vectors
 |_ lor_trans.f		- lorentz transformations
 |_ kin_cuts.f		- kinematic cuts and histogram filling
		set_kin_cuts
		check_cuts(is_cut,p3,p4,p5)
		print_active_cuts(fd)
 |_ ShmHist.cc		- shared memory histogram methods
 |_ hist_interface.cc	- fortran interface for histogramming
		fill_hists_(double *val, double *wgt, int *iter, 
					double *p3, double *p4, double *p5);
		set_fbh_(char *hname, int *flag, double *low, double *up, double *step);
		set_vbh_(char *hname, int *flag, int *nbins, double *bins);
		init_shmhist_();
		init_semaphores_();
		add_hist_();
		read_hist_(const int *restored);
		read_born_hist_(int *restored);
		write_hist_();
		print_all_hist_(const char *run_tag);
		set_hfname_(const char *hfname);
//  int accum_hist_();
		clear_all_hist_();
		release_shmem_abnormal_();
		release_shmem_();

 |_ run_stats.f		- final output and histogram printing
 |_ print_ewpars.f	- output routines for EW parameters
 |_ init_run.f		- run initialization
		init_run
		set_fsmass//final state mass
		
 |_ read_ewpars.f	- EW parameters reading
		read_ewpars
 |_ read_input.f	- input reading
		read_input
		check_pid()
 |_ main.f			- main function
		MCSANC
		printMCSAMCinfo
share			- config files and run directory
README			- this README

5) Contacts

For bugs or questions, please address to:
Serge Bondarenko <bondarenko@jinr.ru>
Andrey Sapronov <andrey.a.sapronov@gmail.com>
