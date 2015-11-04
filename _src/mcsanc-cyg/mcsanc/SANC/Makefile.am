SUBDIRS = modules_nc modules_cc

noinst_LIBRARIES = libSANC.a

libSANC_a_SOURCES = \
	B0D_gen.f B0F_gen.f B0P_gen.f BFF_gen.f \
	C01_gen.f C0analys.f C0IR.f C0IRF.f C0_tbln_0.f \
	D040.f	D040WZ.f \
	Delta_r.f \
	eett_aux.f \
	FermSE.f \
	jaa_av.f \
	JAW_butd_subsub1.f JAW_butd_subsub2.f \
	JAW_sub.f \
	JAW_tbud_subsub1.f JAW_tbud_subsub2.f \
	JAW_udtb_subsub1.f JAW_udtb_subsub2.f \
	Jint.f \
	qedphotrenprop.f \
	theta_hard.f \
	unibosconsts_bos.f unibosconsts_fer.f uniproconsts_fer.f\
	xspenz.f

libSANC_a_FFLAGS = -I./../Looptools/include -I./../include \
       -fno-range-check -fno-automatic -ffixed-line-length-132

