#ifndef ShmHist3d_h
#define ShmHist3d_h 1

#include <string>
using std::string;
#include <sys/types.h>
#include <fstream>
#include "ShmHist.h"//HistBin_t
/*
typedef struct {
  double vw;
  double vw2;
  long int nentr;
  int niter;
} HistBin_t;
*/
class ShmHist3d{
 public:
  // create a histogram with variable binning
  ShmHist3d(const char * hname0, const char * hname1, const char * hname2,
	int flag, int n0bins, int n1bins, int n2bins,
	double *bins0, double *bins1, double *bins2);
  ShmHist3d(const ShmHist3d &);
  ShmHist3d& operator=(const ShmHist3d &);
  ~ShmHist3d();

  int InitShmHist();
  int DeleteShm(int detach_only);
  int Fill(const double * hist_val, double val, double wgt);
  void Clear();
  int Add(const ShmHist3d &);
  void ReadHistFromFile(std::ifstream &, int);
  void WriteHistToFile(std::ofstream &);
  void IncrIter();
  void PrintHistIntegralTable(const ShmHist3d *, std::ofstream&);
  void PrintHist(std::ofstream&);
  void PrintToTxtFile(const ShmHist3d*, const std::string &);
  void SetHistFname(std::string& hfname){ _hfname = hfname;}
  void BinQuadVegas();
/*
  bool get_hasVariableBins();
  int get_flag();
  int get_nbins();
  double get_step();
  double get_xlow();
  double get_xup();
  double *get_bins();
  double *get_vals();
  double *get_sigs();
  std::string get_histName();
*/ 
 private:
  int _flag;
  std::string _histName0, _histName1, _histName2;
  int _n0bins, _n1bins, _n2bins;
  int index0, index1, index2;
  double _x0low, _x1low, _x2low, _x0up, _x1up, _x2up;
  double *_bins0, *_bins1, *_bins2;
  double *_val;
  double *_sig;
  int _shmid, _sem_shmid;
  HistBin_t *_shmHist;
  key_t _key;
  std::string _hfname;
  sem_t *_hist_fill_mutex;

 private:
  ShmHist3d(){}
  void GetHistIntegral(double &, double &) const;

};

#endif
