#include "ShmHist.h"

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/unistd.h>

#include <iostream>
#include <fstream>
#include <limits>
#include <iomanip>
#include <cmath>
#include <cstdlib>

using namespace std;

extern struct mcsanc_flags {
  int iborn,iqed,iew,iqcd,gfscheme,ilin,ifgg,its,irun;
} flags_;


// for fixed bin histogram
ShmHist::ShmHist(const std::string &hname, const int flag, const double low, const double up, const double step)
{
  _hasVariableBins = false;
  _flag = flag;
  _histName = hname;
  _xlow = low;
  _xup = up;
  _step = step;
  _nbins = int((_xup-_xlow)/_step+0.5);
  _bins = new double[_nbins+1];
  _val = new double[_nbins+1];
  _sig = new double[_nbins+1];
  for(int ib = 0; ib<_nbins+1; ib++){
    _bins[ib] = _xlow+ib*_step;
    _val[ib] = 0.;
    _sig[ib] = 0.;
  }
  _shmid = -1;
}

// for variable bin histogram
ShmHist::ShmHist(const std::string &hname, const int flag, const int nbins, const double *bins)
{
  _hasVariableBins = true;
  _flag = flag;
  _histName = hname;
  _xlow = bins[0];
  _xup = bins[nbins];
  _nbins = nbins;
  _step = -1.;
  _bins = new double[_nbins+1];
  _val = new double[_nbins+1];
  _sig = new double[_nbins+1];
  for(int ib = 0; ib<_nbins+1; ib++){
    _bins[ib] = bins[ib];
    _val[ib] = 0.;
    _sig[ib] = 0.;
  }
  _shmid = -1;
}


ShmHist::ShmHist(const ShmHist &rh)
{
  _hasVariableBins = rh._hasVariableBins;
  _flag = rh._flag;
  _histName = rh._histName;
  _xlow = rh._xlow;
  _xup = rh._xup;
  _nbins = rh._nbins;
  _bins = new double[_nbins+1];
  for(int ib = 0; ib<_nbins+1; ib++){
    _bins[ib] = rh._bins[ib];
    _val[ib] = rh._val[ib];
    _sig[ib] = rh._sig[ib];
  }

  _shmid = rh._shmid;
  _shmHist = rh._shmHist;
  _key = rh._key;

}

// called in singleprocess state
int ShmHist::InitShmHist()
{
  _key = IPC_PRIVATE;
  if((_shmid = shmget(IPC_PRIVATE, _nbins*sizeof(HistBin_t), IPC_CREAT | 0666)) <0 ){
    cerr << "Error creating shared memory, key = " << _key << endl;
    exit(1);
  }

  if((_shmHist  = (HistBin_t*)shmat(_shmid,NULL,0)) == (HistBin_t*)-1){
    cerr << "Error attaching to shared memory, key = " << _key << endl;
    exit(1);
  }

  return _shmid;
}

int ShmHist::DeleteShm(int detach_only)
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

  return 0;
}



int ShmHist::Fill(const double x, const double val, const double wgt)
{
  int thebin(0);
  if ( x < _xlow || x > _xup ) return -1;
  if(false == _hasVariableBins){
    thebin = int((x-_xlow)/_step);
  } else {
    for ( int ib=0; ib<_nbins; ib++) {
      if (x>=_bins[ib] && x<_bins[ib+1] ) thebin = ib;
    }
  }
  
  if (thebin < 0 || thebin >= _nbins ) return -1;
  _shmHist[thebin].vw+=val*wgt;
  _shmHist[thebin].vw2+=pow(val*wgt,2);
  _shmHist[thebin].nentr++;
  
  return thebin;
}

int ShmHist::Add(const ShmHist& cumnt)
{
  // check that we add same histograms
  if (_nbins != cumnt._nbins || 
      fabs(_xlow-cumnt._xlow) > std::numeric_limits<double>::epsilon() ||
      fabs(_xup-cumnt._xup) > std::numeric_limits<double>::epsilon() ) {
    cerr << "Error: adding different histograms." << endl;
  }

  for ( int ib=0; ib<_nbins; ib++){
    if (fabs(_bins[ib]-cumnt._bins[ib]) > std::numeric_limits<double>::epsilon()){
      cerr << "Error: adding different histograms." << endl;
    }
  }
  
  for (int ib=0; ib<_nbins; ib++){
    _val[ib] += cumnt._val[ib];
    _sig[ib] = sqrt(pow(_sig[ib],2) + pow(cumnt._sig[ib],2));
  }
}

void ShmHist::ReadHistFromFile(ifstream &fout, int restored)
{
  fout.read((char*)_shmHist, _nbins*sizeof(HistBin_t)); 
  if ( 0 != restored){
    for (int ib=0; ib<_nbins; ib++){
      _shmHist[ib].niter--;
    }
  }
}

void ShmHist::WriteHistToFile(ofstream &fout)
{
  for (int ib=0; ib<_nbins; ib++){
    _shmHist[ib].niter++;
  }
  fout.write((char*)_shmHist, _nbins*sizeof(HistBin_t)); 
}

void ShmHist::PrintHistIntegralTable(const ShmHist* htot, ofstream &fout)
{
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
}


void ShmHist::PrintHist(ofstream &fout)
{

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
      //      fout << _bins[ib] << "\t" << setw(10) << _bins[ib+1] << "\t" 
      fout << _bins[ib] << "\t" << setw(10)
           << setw(16) << setprecision(10) << scientific
           << val << "\t" << setw(16) << sig << endl;
    }
    fout << "\n\n";
  }
}


void ShmHist::PrintToTxtFile(const ShmHist* htot, const string& run_tag)
{
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
    //    fborn << _bins[ib] << "\t" << setw(10) << _bins[ib+1] << "\t" 
    fborn << _bins[ib] << "\t" << setw(10)
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
    //    ftot << _bins[ib] << "\t" << setw(10) << _bins[ib+1] << "\t" 
    ftot << _bins[ib] << "\t" << setw(10)
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
}

void ShmHist::GetHistIntegral(double &hi, double &hie) const
{
  hi = 0.; hie = 0.;
  for (int ib=0; ib<_nbins; ib++){
    hi += _val[ib];
    hie += pow(_sig[ib],2);
  }
  hie = sqrt(hie);
}

void ShmHist::BinQuadVegas()
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

void ShmHist::Clear()
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
