
#include "csignal"

typedef void (*sighandler_t)(int);

/**
 * A fortran interface to C signal function to catch signals
 */
void signal_( int* signum, sighandler_t handler)
{
  signal(*signum, handler);
}

