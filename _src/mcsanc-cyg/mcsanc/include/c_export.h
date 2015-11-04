extern struct {
    double sqs0;
    int processid, irecomb, beams[2], iflew[6], iflqcd, imsb, pdfmember;
    char pdfset[256],run_tag[256];
} process_;

extern struct {
    int nsig; 
    long int ncall[8];
    char sig_name[8][32];
    double sig[8], sig_err[8];
} stats_;

extern struct {
    double relacc, absacc;
    long int flags, seed, mineval, maxeval, nstart, nincrease, nexplore, gridno;
    int ixplore;
    char statefile[128], sfbase[128];
} comvegas_;

extern struct {
    char cutname[50][32];
    int cutflag[50];
    double cutlow[50], cutup[50];
} nml_cuts_;

extern struct {
    int iborn, iqed, iew, iqcd, gfscheme, ilin, ifgg, its, irun;
} flags_;

extern struct {
    double thmu2, tlmu2, omega, fscale, rscale, ome;
} scales_;

extern struct {
    double ma, mv, mh, mz, mw, men, mel, mup, mdn, mmn, mmo, mch, mst, 
	    mtn, mta, mtp, mbt;
} masses_;

extern struct {
    double alpha, alphai, gf, g, e, alphas, gs, cf, conhc, pi, sr2;
    struct{double realnum; double imagnum;} i_;
} consts_;

extern struct {
    double wz, ww, wh, wtp, gz, gw, gh, gtp;
} width_;

extern struct {
    double vsq[11][11];
} ckm_;
//---------------------------




//struct {
//    double ram2, rvm2, rhm2, rzm2, rwm2, renm2, relm2, rupm2, rdnm2, 
//	    rmnm2, rmom2, rchm2, rstm2, rtnm2, rtam2, rtpm2, rbtm2;
//} r2masses_;
//
//struct {
//    doublecomplex cm2, vm2, hm2, zm2, wm2, enm2, elm2, upm2, dnm2, mnm2, mom2,
//	     chm2, stm2, tnm2, tam2, tpm2, btm2;
//} c2masses_;

//struct {
//    double ctw, stw, ctw2, stw2, ctw4, stw4, ctw6, stw6;
//} cstw_;

//struct {
//    double rwz, rhz, rhw, renh, relh, ruph, rdnh, rmnh, rmoh, rchh, rsth, 
//	    rtnh, rtah, rtph, rbth, renz, relz, rupz, rdnz, rmnz, rmoz, rchz, 
//	    rstz, rtnz, rtaz, rtpz, rbtz, renw, relw, rupw, rdnw, rmnw, rmow, 
//	    rchw, rstw, rtnw, rtaw, rtpw, rbtw;
//} rmhwz_;

//struct {
//    double qen, qel, qup, qdn, qmn, qmo, qch, qst, qtn, qta, qtp, qbt, 
//	    aen, ael, aup, adn, amn, amo, ach, ast, atn, ata, atp, abt, ven, 
//	    vel, vup, vdn, vmn, vmo, vch, vst, vtn, vta, vtp, vbt, vpaen, 
//	    vmaen, vpael, vmael, vpaup, vmaup, vpadn, vmadn, vpamn, vmamn, 
//	    vpamo, vmamo, vpach, vmach, vpast, vmast, vpatn, vmatn, vpata, 
//	    vmata, vpatp, vmatp, vpabt, vmabt, dfen, dfel, dfup, dfdn, dfmn, 
//	    dfmo, dfch, dfst, dftn, dfta, dftp, dfbt;
//} qavpm_;


//struct {
//    int ichep;
//} comphep_;

//struct {
//    doublecomplex ffarray[300]	/* was [3][100] */;
//} ff_;

//struct {
//    double qf[12], i3f[12], rmf1[12];
//} qfi3f_;

//struct {
//    double nc, fc, cfl, cfq, cfscheme, cfprime;
//} nc_;

//struct {
//    double betaf, mf, mf1;
//} kinematics_;

//struct {
//    doublecomplex mz2, mw2, mh2, mtp2, mz2c, mw2c, mh2c, mtp2c;
//} widthm_;


