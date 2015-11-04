/*!
 *    @file    ShmHist3d.cc
 *    @brief   The file contains implementation of methods
 *             for shared memory 3d histograms
 *    @author  Andrey Sapronov, modified Uskov Filipp
 *    @date    2014.11.27
 */
#include "ShmHist3d.h"

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/unistd.h>

#include <iostream>
using std::cerr;
using std::endl;
#include <fstream>
using std::ifstream;
using std::ofstream;
#include <limits>
#include <iomanip>
#include <cmath>
#include <cstdlib>
#include <algorithm>
using std::lower_bound;

//using namespace std;

/*
typedef struct {
  double vw;
  double vw2;
  long int nentr;
  int niter;
} HistBin_t;

 private:
  int _flag;
  std::string _histName0, _histName1, _histName2;
  int _n0bins, _n1bins, _n2bins;
  int index0, index1, index2;
  double _x0low, _x1low, _x2low, _x0high, _x1high, _x2high;
  double *_bins0, *_bins1, *_bins2;
  double *_val;
  double *_sig;
  int _shmid, _sem_shmid;
  HistBin_t *_shmHist;
  key_t _key;
  std::string _hfname;
  sem_t *_hist_fill_mutex;
*/

extern struct mcsanc_flags {
  int iborn,iqed,iew,iqcd,gfscheme,ilin,ifgg,its,irun;
} flags_;

#define INDEX3(a,b,c) _n1bins*_n2bins*a+_n2bins*b+c
#define _nbins _n0bins*_n1bins*_n2bins
#define ifnot(expr) if(!(expr))

// for variable bin histogram
ShmHist3d::ShmHist3d(const char * hname0, const char * hname1, const char * hname2,
	int flag, int n0bins, int n1bins, int n2bins,
	double *bins0, double *bins1, double *bins2)
{
  _flag = flag;

  _histName0 = hname0;
  _histName1 = hname1;
  _histName2 = hname2;
  string hval_name[]={"m34","mtr","pt34","pt3","pt4","eta34","eta3","eta4","phistar","incl","forw","back"};
  for(int i=0; i<sizeof(hval_name); i++)
    if(_histName0 == hval_name[i]){
      index0=i;
      goto cont0;
    }
  cerr<<"Error: unrecognized histogram3d name: "<<_histName0;
  exit(1);
 cont0:
  for(int i=0; i<sizeof(hval_name); i++)
    if(_histName1 == hval_name[i]){
      index1=i;
      goto cont1;
    }
  cerr<<"Error: unrecognized histogram3d name: "<<_histName1;
  exit(1);
 cont1:
  for(int i=0; i<sizeof(hval_name); i++)
    if(_histName2 == hval_name[i]){
      index2=i;
      goto cont2;
    }
  cerr<<"Error: unrecognized histogram3d name: "<<_histName2;
  exit(1);
 cont2:

  _n0bins = n0bins;
  _n1bins = n1bins;
  _n2bins = n2bins;
  _x0low = bins0[0];
  _x0up  = bins0[n0bins];
  _x1low = bins1[1];
  _x1up  = bins1[n1bins];
  _x2low = bins2[2];
  _x2up  = bins2[n2bins];

  _bins0 = new double[_n0bins+1];
  _bins1 = new double[_n1bins+1];
  _bins2 = new double[_n2bins+1];
  _bins0[0]=bins0[0];
  for(int ib = 1; ib<_n0bins+1; ib++){
    if(bins0[ib-1]>=bins0[ib]) cerr<<"Error: irregular bin0 "<<ib<<" in "<<_histName0;
    _bins0[ib] = bins0[ib];
  }
  for(int ib = 1; ib<_n1bins+1; ib++){
    if(bins1[ib-1]>=bins1[ib]) cerr<<"Error: irregular bin1 "<<ib<<" in "<<_histName1;
    _bins1[ib] = bins1[ib];
  }
  for(int ib = 1; ib<_n2bins+1; ib++){
    if(bins2[ib-1]>=bins2[ib]) cerr<<"Error: irregular bin2 "<<ib<<" in "<<_histName2;
    _bins2[ib] = bins2[ib];
  }

  _val = new double[_nbins];
  _sig = new double[_nbins];
  for(int i=0; i<_nbins; i++){
    _val[i] = 0.;
    _sig[i] = 0.;
  }
  _sem_shmid=_shmid = -1;
}

//а нужен ли он? + не хватает деструктора
ShmHist3d::ShmHist3d(const ShmHist3d &rh)
{
  _flag = rh._flag;
  _histName0 = rh._histName0;
  _histName1 = rh._histName1;
  _histName2 = rh._histName2;
//  _xlow = rh._xlow;
//  _xup = rh._xup;
  _n0bins = rh._n0bins;
  _n1bins = rh._n1bins;
  _n2bins = rh._n2bins;
  _bins0 = new double[_n0bins+1];
  _bins1 = new double[_n1bins+1];
  _bins2 = new double[_n2bins+1];
  for(int ib = 0; ib<_n0bins+1; ib++)
    _bins0[ib] = rh._bins0[ib];
  for(int ib = 0; ib<_n1bins+1; ib++)
    _bins1[ib] = rh._bins1[ib];
  for(int ib = 0; ib<_n2bins+1; ib++)
    _bins2[ib] = rh._bins2[ib];
  
  for(int i=0; i<_nbins; i++){
    _val[i] = 0.;
    _sig[i] = 0.;
  }

  _shmid = rh._shmid;
  _sem_shmid = rh._sem_shmid;
  _shmHist = rh._shmHist;
  _key = rh._key;

}

// called in singleprocess state
int ShmHist3d::InitShmHist()
{
  _key = IPC_PRIVATE;
  if((_shmid = shmget(IPC_PRIVATE, _n0bins*_n1bins*_n2bins*sizeof(HistBin_t), IPC_CREAT | 0666)) <0 ){
    cerr << "Error creating shared memory, key = " << _key << endl;
    exit(1);
  }
  if((_shmHist  = (HistBin_t*)shmat(_shmid,NULL,0)) == (HistBin_t*)-1){
    cerr << "Error attaching to shared memory, key = " << _key << endl;
    exit(1);
  }

  if((_sem_shmid = shmget(IPC_PRIVATE, sizeof(sem_t), IPC_CREAT | 0666)) <0 ){
    cerr << "Error creating shared memory, key = " << _key << endl;
    exit(1);
  }
  if((_hist_fill_mutex  = (sem_t*)shmat(_sem_shmid,NULL,0)) == (sem_t*)-1){
    cerr << "Error attaching to shared memory, key = " << _key << endl;
    exit(1);
  }
  if (sem_init(_hist_fill_mutex, 1, 1) == -1) {
    cerr<< "Failed to initialize persistency mutex semaphore." << endl;
    exit(1);
  } 

  return _shmid;
}

int ShmHist3d::DeleteShm(int detach_only)
{

  if ( shmdt(_shmHist) == -1 ){
    cerr<<"Error: ShmHist failed to detach from shared memory segment, shm_id = "
        <<_shmid << endl;
  } else if(detach_only == 0) {
    if ((shmctl(_shmid,IPC_RMID,0))==-1){
      cerr<<"Error: ShmHist is unable to delete shared memory segment, shm_id = "
          <<_shmid<<endl;
      return -1;
    }
  }

  if ( shmdt(_hist_fill_mutex) == -1 ){
    cerr<<"Error: ShmHist failed to detach from shared memory segment, shm_id = "
        <<_sem_shmid << endl;
  } else if(detach_only == 0) {
    if ((shmctl(_sem_shmid,IPC_RMID,0))==-1){
      cerr<<"Error: ShmHist is unable to delete shared memory segment, shm_id = "
          <<_sem_shmid<<endl;
      return -1;
    }
  }

  return 0;
}



int ShmHist3d::Fill(const double * hist_val, double val, double wgt)
{
  double x0=hist_val[index0], x1=hist_val[index1], x2=hist_val[index2]; 
  if ( x0!=x0 || x0 < _x0low || x0 > _x0up ) return -1;
  if ( x1!=x1 || x1 < _x1low || x1 > _x1up ) return -1;
  if ( x2!=x2 || x2 < _x2low || x2 > _x2up ) return -1;
  
  int thebin0=upper_bound(_bins0,_bins0+_n0bins,x0)-_bins0-1;
  int thebin1=upper_bound(_bins1,_bins1+_n1bins,x1)-_bins1-1;
  int thebin2=upper_bound(_bins2,_bins2+_n2bins,x2)-_bins2-1;
  int thebin=INDEX3(thebin0,thebin1,thebin2);
sem_wait(_hist_fill_mutex);
  _shmHist[thebin].vw+=val*wgt;
  _shmHist[thebin].vw2+=pow(val*wgt,2);
  _shmHist[thebin].nentr++;
sem_post(_hist_fill_mutex);
  
  return thebin;
}

int ShmHist3d::Add(const ShmHist3d& cumnt)
{
  // check that we add same histograms
  if (_n0bins != cumnt._n0bins || 
      fabs(_x0low-cumnt._x0low) > std::numeric_limits<double>::epsilon() ||
      fabs(_x0up-cumnt._x0up) > std::numeric_limits<double>::epsilon() ) {
    cerr << "Error: adding different histograms." << endl;
  }
  if (_n1bins != cumnt._n1bins || 
      fabs(_x1low-cumnt._x1low) > std::numeric_limits<double>::epsilon() ||
      fabs(_x1up-cumnt._x1up) > std::numeric_limits<double>::epsilon() ) {
    cerr << "Error: adding different histograms." << endl;
  }
  if (_n2bins != cumnt._n2bins || 
      fabs(_x2low-cumnt._x2low) > std::numeric_limits<double>::epsilon() ||
      fabs(_x2up-cumnt._x2up) > std::numeric_limits<double>::epsilon() ) {
    cerr << "Error: adding different histograms." << endl;
  }

  for ( int ib=0; ib<_n0bins; ib++){
    if (fabs(_bins0[ib]-cumnt._bins0[ib]) > std::numeric_limits<double>::epsilon()){
      cerr << "Error: adding different histograms." << endl;
    }
  }
  for ( int ib=0; ib<_n1bins; ib++){
    if (fabs(_bins1[ib]-cumnt._bins1[ib]) > std::numeric_limits<double>::epsilon()){
      cerr << "Error: adding different histograms." << endl;
    }
  }
  for ( int ib=0; ib<_n2bins; ib++){
    if (fabs(_bins2[ib]-cumnt._bins2[ib]) > std::numeric_limits<double>::epsilon()){
      cerr << "Error: adding different histograms." << endl;
    }
  }
  
  for (int ib=0; ib<_nbins; ib++){
    _val[ib] += cumnt._val[ib];
    _sig[ib] = sqrt(pow(_sig[ib],2) + pow(cumnt._sig[ib],2));
  }
}

void ShmHist3d::ReadHistFromFile(ifstream &fout, int restored)
{
  fout.read((char*)_shmHist, _nbins*sizeof(HistBin_t)); 
  if (restored){
    for (int ib=0; ib<_nbins; ib++){
      _shmHist[ib].niter--;
    }
  }
}

void ShmHist3d::WriteHistToFile(ofstream &fout)
{
  for (int ib=0; ib<_nbins; ib++){
    _shmHist[ib].niter++;
  }
  fout.write((char*)_shmHist, _nbins*sizeof(HistBin_t)); 
}

void ShmHist3d::PrintHistIntegralTable(const ShmHist3d* htot, ofstream &fout)
{
  /*
  double hitot(0.), hitote(0.);
  double hiborn(0.), hiborne(0.);
  double hidelta(0.), hideltae(0.);
  if ( 0 != (_flag&1) ) {
    htot->GetHistIntegral(hitot, hitote);
    this->GetHistIntegral(hiborn, hiborne);

    if (hiborn != 0 && 1 != flags_.iborn) {
      hidelta=(hitot/hiborn-1)*1e2;
      hideltae = sqrt(pow(hitote/hiborn,2)+pow(hiborne*hitot/pow(hiborn,2),2))*1e2;
    }

    fout << resetiosflags(ios::right);
    fout << setw(15) << setiosflags(ios::left) 
         << _histName << "| " ;
    fout << setiosflags(ios::right) << setiosflags(ios::fixed) 
         << setprecision(4) << scientific << setw(10)
         << hiborn << " +- " << setw(10) << hiborne << " | "
	 << setw(10) << hitot  << " +- " << setw(10) << hitote << " | "
         << setw(10) << hidelta<< " +- " << setw(10) << hideltae << "\n";
  }
  */
}


void ShmHist3d::PrintHist(ofstream &fout)
{
  /*
  if ( 0 != (_flag&1) ) {
    fout << _histName << endl;
    for (int ib=0; ib<_nbins; ib++){
      double val(_val[ib]);
      double sig(_sig[ib]);
      // normalize to bin width
      if ( 0 != (_flag&2) ){
        if ( 0.== _bins[ib+1] - _bins[ib]) 
          cerr << "Histogram " << _histName 
               << ", attempt to normalize to 0 size bin #" << ib << endl;
        val/=(_bins[ib+1] - _bins[ib]);
        sig/=(_bins[ib+1] - _bins[ib]);
      }
      fout << setiosflags(ios::fixed) << setiosflags(ios::right)
           << setw(10) << setprecision(3) << fixed;
      fout << _bins[ib] << "\t" << setw(10) << _bins[ib+1] << "\t" 
           << setw(16) << setprecision(10) << scientific
           << val << "\t" << setw(16) << sig << endl;
    }
    fout << "\n\n";
  }
  */
}


void ShmHist3d::PrintToTxtFile(const ShmHist3d* htot, const string& run_tag)
{
  /*
  if ( 0 == (_flag&1) ) return;
  string hist_fname;
  // print born
  hist_fname = run_tag+"_"+_histName+"-born";
  ofstream fborn(hist_fname.c_str());
  for (int ib=0; ib<_nbins; ib++){
    double val(_val[ib]);
    double sig(_sig[ib]);
    // normalize to bin width
    if ( 0 != (_flag&2) ) {
      if ( 0.== _bins[ib+1] - _bins[ib]) {
        cerr << "Histogram " << _histName 
           << ", attempt to normalize to 0 size bin #" << ib << endl;
      }
      val/=(_bins[ib+1] - _bins[ib]);
      sig/=(_bins[ib+1] - _bins[ib]);
    }
    fborn << setiosflags(ios::fixed) << setiosflags(ios::right)
          << setw(10) << setprecision(3) << fixed;
    fborn << _bins[ib] << "\t" << setw(10) << _bins[ib+1] << "\t" 
          << setprecision(10) << scientific
          << setw(16) << val << "\t" << setw(16) << sig << endl;
  }
  fborn.close();

  if (flags_.iborn == 1 ) return;

  // print total
  hist_fname = run_tag+"_"+_histName+"-tota";
  ofstream ftot(hist_fname.c_str());
  for (int ib=0; ib<_nbins; ib++){
    double val(htot->_val[ib]);
    double sig(htot->_sig[ib]);
    // normalize to bin width
    if ( 0 != (htot->_flag&2) ) {
      if ( 0.== _bins[ib+1] - _bins[ib]) {
        cerr << "Histogram " << _histName 
             << ", attempt to normalize to 0 size bin #" << ib << endl;
      }
      val/=(htot->_bins[ib+1] - htot->_bins[ib]);
      sig/=(htot->_bins[ib+1] - htot->_bins[ib]);
    }
    ftot << setiosflags(ios::fixed) << setiosflags(ios::right)
         << setw(10) << setprecision(3) << fixed;
    ftot << _bins[ib] << "\t" << setw(10) << _bins[ib+1] << "\t" 
         << setw(16) << setprecision(10) << scientific
         << val << "\t" << setw(16) << sig << endl;
  }
  ftot.close();

  // print delta
  hist_fname = run_tag+"_"+_histName+"-delt";
  ofstream fdelt(hist_fname.c_str());
  for (int ib=0; ib<_nbins; ib++){
    double delt(0.);
    if ( 0. != _val[ib] ) {
      delt = (htot->_val[ib]/_val[ib] - 1.)*1e2;
    }
    double sigborn(0.), sigtota(0.);
    sigborn=_sig[ib];
    sigtota=htot->_sig[ib];
    double sig(0);
    if ( 0. != _val[ib] ) {
      sig = sqrt(pow(sigtota/_val[ib],2)+
        pow(sigborn*htot->_val[ib]/pow(_val[ib],2),2))*1e2;
    }
    // Delta is not normalized to bin width
    fdelt << setiosflags(ios::fixed) << setiosflags(ios::right)
          << setw(10) << setprecision(3) << fixed;
    fdelt << _bins[ib] << "\t" << setw(10) << _bins[ib+1] << "\t" 
          << setw(16) << setprecision(10) << scientific
          << delt << "\t" << setw(16) << sig << endl;
  }
  fdelt.close();
  */
}

void ShmHist3d::GetHistIntegral(double &hi, double &hie) const
{
  hi = 0.; hie = 0.;
  for (int ib=0; ib<_nbins; ib++){
    hi += _val[ib];
    hie += pow(_sig[ib],2);
  }
  hie = sqrt(hie);
}

void ShmHist3d::BinQuadVegas()
{
  for (int ib=0; ib<_nbins; ib++){
    double invvar2(0.); // inverse variance squared
    if (_shmHist[ib].vw != 0.  ) {
      if ( _shmHist[ib].nentr !=1 )
        invvar2 = (_shmHist[ib].nentr-1)/
          (_shmHist[ib].vw2*_shmHist[ib].nentr-pow(_shmHist[ib].vw,2));
      else invvar2 = 1./_shmHist[ib].vw2;
    }
    _val[ib]=_shmHist[ib].vw/_shmHist[ib].niter;
    if ( 0. != invvar2 ) {
      _sig[ib]=1./sqrt(fabs(invvar2))/_shmHist[ib].niter;
    }
    //cout << ib << "\t" << _shmHist[ib].vw << "\t" << 1./_shmHist[ib].isig << endl;
  }

}

void ShmHist3d::Clear()
{
  for (int ib=0; ib<_nbins; ib++){
    _shmHist[ib].vw=0.;
    _shmHist[ib].vw2=0.;
    _shmHist[ib].nentr=0;
    _shmHist[ib].niter=-1;
    _val[ib] = 0.;
    _sig[ib] = 0.;
  }
}

// Getters
/*
  bool ShmHist3d::get_hasVariableBins() { return _hasVariableBins; }
  int ShmHist3d::get_flag() { return _flag; }
  int ShmHist::get_nbins() { return _nbins; }
  double ShmHist::get_step(){  return _step; }
  double ShmHist::get_xlow() { return _xlow; }
  double ShmHist::get_xup() { return _xup; }
  double *ShmHist::get_bins() { return _bins; }
  double *ShmHist::get_vals() { return _val; }
  double *ShmHist::get_sigs() { return _sig; }
  std::string ShmHist::get_histName() { return _histName;}
*/