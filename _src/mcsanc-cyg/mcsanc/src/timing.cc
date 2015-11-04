/*!
 *    @file    timing.cc
 *    @brief   The file contains fortran interface
 *             functions for CPU usage measurement
 *    @author  Andrey Sapronov
 *    @date    2013.03.01
 */
#include <cstdlib>
#include <sys/times.h>
#include <unistd.h>

using namespace std;

extern "C" {
  int start_clock_();
  int stop_clock_(double *ttime, double *utime, double *stime);
}

static clock_t clock_start, clock_stop;
static struct tms mcsanc_times_start;
static struct tms mcsanc_times_end;

int start_clock_(){
  clock_start = times(&mcsanc_times_start);
}

int stop_clock_(double *ttime, double *utime, double *stime){
  clock_stop = times(&mcsanc_times_end);
  *ttime = double(clock_stop-clock_start)/sysconf(_SC_CLK_TCK);
  *utime = double(mcsanc_times_end.tms_cutime
                   -mcsanc_times_start.tms_cutime)/sysconf(_SC_CLK_TCK);
  *stime = double(mcsanc_times_end.tms_cstime
                   -mcsanc_times_start.tms_cstime)/sysconf(_SC_CLK_TCK);
}

