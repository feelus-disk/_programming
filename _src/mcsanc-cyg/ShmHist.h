#ifndef ShmHist_h
#define ShmHist_h 1

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <semaphore.h>
#include <string>
#include <fstream>

typedef struct {
  double vw;
  double vw2;
  long int nentr;
  int niter;
} HistBin_t;

class ShmHist{
 public:
  // create a histogram with fixed binning
  ShmHist(const std::string &hname, const int flag, const double low, const double up, const double step);
  // create a histogram with variable binning
  ShmHist(const std::string &hname, const int flag, const int nbins, const double *bins);
  ShmHist(const ShmHist &);
  ShmHist& operator=(const ShmHist&);
  ~ShmHist();

  int InitShmHist();
  int DeleteShm(int);
  int Fill(const double x, const double val, const double wgt);
  void Clear();
  int Add(const ShmHist&);
  void ReadHistFromFile(std::ifstream &, int);
  void WriteHistToFile(std::ofstream &);
  void IncrIter();
  void PrintHistIntegralTable(const ShmHist*, std::ofstream&);
  void PrintHist(std::ofstream&);
  void PrintToTxtFile(const ShmHist*, const std::string &);
  void SetHistFname(std::string& hfname){ _hfname = hfname;}
  void BinQuadVegas();

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
 
 private:
  bool _hasVariableBins;
  int _flag;
  std::string _histName;
  int _nbins;
  double _step;
  double _xlow;
  double _xup;
  double *_bins;
  double *_val;
  double *_sig;
  int _shmid, _sem_shmid;
  HistBin_t *_shmHist;
  key_t _key;
  std::string _hfname;
  sem_t *_hist_fill_mutex;

 private:
  ShmHist(){}
  void GetHistIntegral(double &, double &) const;

};

#endif
