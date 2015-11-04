/*!
 *    @file    hist_interface.cc
 *    @brief   The file contains interface functions to control
 *             histogramming from fortran routines in mcsanc
 *    @author  Andrey Sapronov
 *    @date    2013.03.01
 */

#include "ShmHist.h"

#include <iostream>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
//#include <sys/sem.h>
#include <cstdlib>
#include <cmath>
#include <semaphore.h>
#include <vector>
#include <unistd.h>

using namespace std;

extern "C" {
  int fill_hists_(const double *val, const double *wgt, const int *iter, 
    const double *p3, const double *p4, const double *p5);
  int set_fbh_(const char *hname, const int *flag, const double *low, const double *up, const double *step);
  int set_vbh_(const char *hname, const int *flag, const int *nbins, const double *bins);
  int init_shmhist_();
  int init_semaphores_();
  int add_hist_();
  int read_hist_(const int *restored);
  int read_born_hist_(const int *restored);
  int write_hist_();
  int print_all_hist_(const char *run_tag);
  int set_hfname_(const char *hfname);
//  int accum_hist_();
  int clear_all_hist_();
  int release_shmem_abnormal_();
  int release_shmem_();
}

/*
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
*/

extern struct mcsanc_kin_pars {
  double hist_val[100];
  int nhist;
} hval_;

vector<ShmHist*> vsh;
vector<ShmHist*> vshcum;
vector<ShmHist*> vshborn;

sem_t *mcsanc_persistency_mutex;
sem_t *mcsanc_persistency_barrier;
sem_t *mcsanc_hist_fill_mutex;
int *mcsanc_process_cnt;
string mcsanc_histstate_fname;
int *mcsanc_shmid;

/**
 * The histogram filling function called from fortran check_cuts
 * procedure. Calls the filling method for the list of histograms
 * in allocated in shared memory.
 * @param *val pointer to the array with histogrammed values
 * @param *wgt weight of this histogram entry
 * @param *iter vegas iteration number
 * @param *p3, *p4, *p4 the four-vectors of final particles, not used in histogramming, to be removed
 */
int fill_hists_(const double *val, const double *wgt, const int *iter, 
    const double *p3, const double *p4, const double *p5)
{
  static int curr_iter = 1;
  
  // reset iteration counter at the end of integration
  if ( 0 == *iter ) {
    curr_iter = 1;
    return 1;
  }

  if ( curr_iter != *iter ) {
    char *env = getenv("CUBACORES");
    int ncores = env ? atoi(env) : sysconf(_SC_NPROCESSORS_ONLN);

    if ( 0 != ncores ){
    // In a multiprocess environment
    // all process should wait for the last one to store and clean histograms
    // this piece is total black magick. I won't be able to decifer it in a month
    sem_wait(mcsanc_persistency_mutex);
      (*mcsanc_process_cnt)++;
      // have to reset barrier to 0 (probably there is a better way..)
      int barrier_val;
      sem_getvalue(mcsanc_persistency_barrier,&barrier_val);
      if ( 0 != barrier_val ) sem_wait(mcsanc_persistency_barrier);
    sem_post(mcsanc_persistency_mutex);

    sem_wait(mcsanc_persistency_mutex);
      if ( ncores == *mcsanc_process_cnt ) {
        *mcsanc_process_cnt = -1;
        sem_post(mcsanc_persistency_barrier);
      }
    sem_post(mcsanc_persistency_mutex);
    sem_wait(mcsanc_persistency_barrier);
      // using process counter variable to accumulate and save histograms only once
      // very dirty
      if ( 0 != *mcsanc_process_cnt ){
	write_hist_();
    
        *mcsanc_process_cnt=0;
      }
    sem_post(mcsanc_persistency_barrier);
    } else {
      write_hist_();
    }

    curr_iter = *iter;
  }

  ////////
  // Fill the histograms
  if (*val != *val || *wgt != *wgt ) return -1;
  if ( hval_.nhist != vsh.size() ) {
    cerr << "Number of filled histograms does not "
         << "equal to number of booked ones. Exit" << endl;
    exit(1);
  }
  
  sem_wait(mcsanc_hist_fill_mutex);
  for ( int ih=0; ih<vsh.size(); ih++){
    if ( hval_.hist_val[ih] != hval_.hist_val[ih] ) continue;
    vsh.at(ih)->Fill(hval_.hist_val[ih], *val, *wgt);
  }
  sem_post(mcsanc_hist_fill_mutex);
}

/**
 * Set the string with histogram name used for the output
 * @param *hfname the histogram name
 */
int set_hfname_(const char *hfname)
{
  mcsanc_histstate_fname = string(hfname);
}

/**
 * Print all the histograms.
 * @param *run_tag the run tag string
 */
int print_all_hist_(const char *run_tag)
{
  string mcsanc_out_fname("mcsanc-"+string(run_tag)+"-output.txt");
  ofstream mfout(mcsanc_out_fname.c_str(), ios_base::app | ios_base::out 
    | ios_base::ate);

  mfout << "\nhistogram integral table:\n";
  mfout << "name\t\t born \t\t\t    tot\t\t\t       delta" << endl;
  for(int ih=0; ih<vshcum.size(); ih++){
    vshborn.at(ih)->PrintHistIntegralTable(vshcum.at(ih), mfout);
  }
  mfout << "\nhistograms:\n";
  for(int ih=0; ih<vshcum.size(); ih++){
    vshcum.at(ih)->PrintHist(mfout);
    vshborn.at(ih)->PrintToTxtFile(vshcum.at(ih), string(run_tag));
  }
  mfout.close();
}

/**
 * Adds up the accumulated histograms.
 */
int add_hist_()
{
  for(int ih=0; ih<vshcum.size(); ih++){
    vshcum.at(ih)->Add(*(vsh.at(ih)));
  }
}

/**
 * Reads the histogram stored in the *.hist file to combine
 * them for printing.
 */
int read_hist_(const int *restored)
{
  ifstream fin(mcsanc_histstate_fname.c_str());
  if (!fin) return -1;
  vector<ShmHist*> ::iterator itsh = vsh.begin();
  for (; itsh!=vsh.end(); itsh++){
    (*itsh)->ReadHistFromFile(fin, *restored);
    if ( 1 != *restored ) (*itsh)->BinQuadVegas();
  }

  fin.close();
}


/**
 * Reads the Born histogram stored in the *.hist file to combine
 * them for printing.
 */
int read_born_hist_(const int *restored)
{
  ifstream fin(mcsanc_histstate_fname.c_str());
  if (!fin) return -1;
  vector<ShmHist*> ::iterator itsh = vshborn.begin();
  for (; itsh!=vshborn.end(); itsh++){
    (*itsh)->ReadHistFromFile(fin, *restored);
    if ( 1 != *restored ) (*itsh)->BinQuadVegas();
  }

  fin.close();
}

/**
 * Writes histograms to *.hist file after the integration for current
 * component is complete
 */
int write_hist_()
{
  ofstream fout(mcsanc_histstate_fname.c_str());
  vector<ShmHist*> ::iterator itsh = vsh.begin();
  for (; itsh!=vsh.end(); itsh++){
    (*itsh)->WriteHistToFile(fout);
  }

  fout.close();
}

/**
 * Sets all histogram bin values and errors to zero
 */
int clear_all_hist_()
{
  vector<ShmHist*> ::iterator itsh = vsh.begin();
  for (; itsh!=vsh.end(); itsh++){
    (*itsh)->Clear();
  }
  
  itsh = vshcum.begin();
  for (; itsh!=vshcum.end(); itsh++){
    (*itsh)->Clear();
  }
  
  itsh = vshborn.begin();
  for (; itsh!=vshborn.end(); itsh++){
    (*itsh)->Clear();
  }
  
}

/**
 * Sets fixed bin histograms parameters.
 * This routine is called upon initialization whil reading input.cfg file
 */
int set_fbh_(const char *hname, const int *flag, const double *low, const double *up, const double *step)
{
  string strhname(hname);
  ShmHist *sh = new ShmHist(strhname, *flag, *low, *up, *step);
  vsh.push_back(sh);
  ShmHist *shc = new ShmHist(strhname, *flag, *low, *up, *step);
  vshcum.push_back(shc);
  ShmHist *shb = new ShmHist(strhname, *flag, *low, *up, *step);
  vshborn.push_back(shb);
}

/**
 * Sets variable bin histograms parameters.
 * This routine is called upon initialization whil reading input.cfg file
 */
int set_vbh_(const char *hname, const int *flag, const int *nbins, const double *bins)
{
  ShmHist *sh = new ShmHist(string(hname), *flag, *nbins, bins);
  vsh.push_back(sh);
  ShmHist *shc = new ShmHist(string(hname), *flag, *nbins, bins);
  vshcum.push_back(shc);
  ShmHist *shb = new ShmHist(string(hname), *flag, *nbins, bins);
  vshborn.push_back(shb);
}

/**
 * Allocates shared memory vectors for variable bin histograms.
 * This routine is called upon initialization whil reading input.cfg file after
 * set_fbh_, set_vbh_ calls.
 */
int init_shmhist_()
{
  if (vsh.size() != vshcum.size() ){
    cerr << "Histogram initialization error: number of cumulative and \
    current histograms differ." << endl;
    return 1;
  }
  for ( int ih = 0; ih < vsh.size(); ih++){
    vsh.at(ih)->InitShmHist();
    vshcum.at(ih)->InitShmHist();
    vshborn.at(ih)->InitShmHist();
  }

}

/**
 * Initializes semaphores used for interprocess coordination
 */
int init_semaphores_()
{
  int id(0);
  sem_t *sem;
  mcsanc_shmid = new int[2];

  if ((mcsanc_shmid[0] = shmget(IPC_PRIVATE, 3*sizeof(sem_t),IPC_CREAT |  0666)) == -1) {
    cerr<< "Failed to create shared memory segment for semaphore." << endl;
    return 1;
  }

  if ((sem = (sem_t *)shmat(mcsanc_shmid[0], NULL, 0)) == (void *)-1) {
    cerr<< "Failed to attach to semaphore shared memory." << endl;
    return 1;
  }
  mcsanc_persistency_mutex = &(sem[0]);
  mcsanc_persistency_barrier = &(sem[1]);
  mcsanc_hist_fill_mutex = &(sem[2]);

  if (sem_init(mcsanc_persistency_mutex, 1, 1) == -1) {
    cerr<< "Failed to initialize persistency mutex semaphore." << endl;
  } 

  if (sem_init(mcsanc_persistency_barrier, 1, 0) == -1) {
    cerr<< "Failed to initialize persistency barrier semaphore." << endl;
  } 
  if (sem_init(mcsanc_hist_fill_mutex, 1, 1) == -1) {
    cerr<< "Failed to initialize histogram filling mutex semaphore." << endl;
  } 

  // create shared memory for process counter
  if ((mcsanc_shmid[1] = shmget(IPC_PRIVATE, sizeof(int), IPC_CREAT |  0666)) == -1) {
    cerr<< "Failed to create shared memory segment process counter." << endl;
    return 1;
  }

  if ((mcsanc_process_cnt = (int *)shmat(mcsanc_shmid[1], NULL, 0)) == (int *)-1) {
    cerr<< "Failed to attach to process counter shared memory." << endl;
    return 1;
  }
  *mcsanc_process_cnt = 0;
}

/**
 * Frees shared memory at the end of run
 */
int release_shmem_()
{
  vector<ShmHist*> ::iterator itsh = vsh.begin();
  for (; itsh!=vsh.end(); itsh++){
    (*itsh)->DeleteShm(0);
  }
  
  itsh = vshcum.begin();
  for (; itsh!=vshcum.end(); itsh++){
    (*itsh)->DeleteShm(0);
  }
  
  itsh = vshborn.begin();
  for (; itsh!=vshborn.end(); itsh++){
    (*itsh)->DeleteShm(0);
  }

  if ( shmdt(mcsanc_persistency_mutex) == -1 ){
  } else {
    if ((shmctl(mcsanc_shmid[0],IPC_RMID,0))==-1){
      cerr<<"Error: unable to delete shared memory segment, shm_id = "
          <<mcsanc_shmid[0]<<endl;
      return -1;
    }
  }
 
  if ( shmdt(mcsanc_process_cnt) == -1 ){
  } else {
    if ((shmctl(mcsanc_shmid[1],IPC_RMID,0))==-1){
      cerr<<"Error: unable to delete shared memory segment, shm_id = "
          <<mcsanc_shmid[1]<<endl;
      return -1;
    }
  }

  return 0;

}

/**
 * Frees shared memory upon program abortion
 */
int release_shmem_abnormal_()
{
  sem_wait(mcsanc_persistency_mutex);
    (*mcsanc_process_cnt)++;
    
    char *env = getenv("CUBACORES");
    int ncores = env ? atoi(env) : sysconf(_SC_NPROCESSORS_ONLN);

	//int detach_only = ncores != *mcsanc_process_cnt;
	int detach_only(1);
    if ( ncores == *mcsanc_process_cnt ) {
      detach_only = 0;
    }
      
    vector<ShmHist*> ::iterator itsh = vsh.begin();
    for (; itsh!=vsh.end(); itsh++){
      (*itsh)->DeleteShm(detach_only);
    }
    
    itsh = vshcum.begin();
    for (; itsh!=vshcum.end(); itsh++){
      (*itsh)->DeleteShm(detach_only);
    }
    
    itsh = vshborn.begin();
    for (; itsh!=vshborn.end(); itsh++){
      (*itsh)->DeleteShm(detach_only);
    }

    if ( detach_only ) {
      sem_post(mcsanc_persistency_mutex);
      exit(1);
    }
    *mcsanc_process_cnt = 0;
  sem_post(mcsanc_persistency_mutex);
    
  if ( shmdt(mcsanc_persistency_mutex) == -1 ){
  } else {
    if ((shmctl(mcsanc_shmid[0],IPC_RMID,0))==-1){
      cerr<<"Error: unable to delete shared memory segment, shm_id = "
          <<mcsanc_shmid[0]<<endl;
      return -1;
    }
  }
 
  if ( shmdt(mcsanc_process_cnt) == -1 ){
  } else {
    if ((shmctl(mcsanc_shmid[1],IPC_RMID,0))==-1){
      cerr<<"Error: unable to delete shared memory segment, shm_id = "
          <<mcsanc_shmid[1]<<endl;
      return -1;
    }
  }

  return 0;

}
