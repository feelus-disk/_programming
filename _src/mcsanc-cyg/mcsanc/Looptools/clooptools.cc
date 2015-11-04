/* -*- C++ -*-
  clooptools.cc
  the C++ file with the definitions for fortran IO redirection
  Output redirected to log file. 2007-07-18 dgrell
*/
#ifdef HAVE_CONFIG_H
# include <config.h>
#endif

#include <cstdio>

#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif

#include <string>

extern "C" {
  void ffini_();
  void ffexi_();
}


namespace {
  struct RedirectionInfo {
    RedirectionInfo(int fdin = 0, fpos_t posin = fpos_t()) 
      : fd(fdin), pos(posin) {}
    int fd;
    fpos_t pos;
  };

#ifdef HAVE_UNISTD_H
  RedirectionInfo start_redirection(std::string logfilename) {
    // redirect C stdout --- unix specific solution,
    // see C FAQ: http://c-faq.com/stdio/undofreopen.html
    int    fd;
    fpos_t pos;
    fflush(stdout);
    fgetpos(stdout, &pos);
    fd = dup(fileno(stdout));
    freopen(logfilename.c_str(), "a", stdout);
    return RedirectionInfo(fd,pos);
  }
  
  void stop_redirection(RedirectionInfo rdinfo) {
    fflush(stdout);
    dup2(rdinfo.fd, fileno(stdout));
    close(rdinfo.fd);
    clearerr(stdout);
    fsetpos(stdout, &rdinfo.pos);
  }
#else
  RedirectionInfo start_redirection(std::string) {
    return RedirectionInfo();
  }
  
  void stop_redirection(RedirectionInfo) {}
#endif

} // namespace

//namespace Herwig {
  namespace Looptools {
    void ffini(std::string logfilename) {
      RedirectionInfo rd = start_redirection(logfilename);
      ffini_();
      stop_redirection(rd);
    }

    void ffexi(std::string logfilename) {
      RedirectionInfo rd = start_redirection(logfilename);
      ffexi_();
      stop_redirection(rd);
    }

  } // namespace Looptools
//} // namespace Herwig
