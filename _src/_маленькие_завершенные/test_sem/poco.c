/* Compile: gcc -o poco_ne poco_ne.c
*/
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

/* Error handling. */
void FatalError(const char* const pmsg)
{
	fprintf(stderr, "%s\n", pmsg);
	exit(1);
}

int main()
{
	/* Create a file. */
	const char* const pfilename = "try.txt";
	int fd = open(pfilename, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd == -1)
		FatalError("open() failed.");
	close(fd);

	/* Generate a key, using the file we just created. */
	key_t key = ftok(pfilename, 'a');
	if (key == -1)
		FatalError("ftok() failed.");

	/* Get the semaphore set identifier */
	fprintf(stderr, "Trying semget()\n");
	fprintf(stderr, "This causes 'Bad system call (core dumped)' in Cygwin.\n");
	int semid = semget(key, 1, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH | IPC_CREAT | IPC_EXCL);
	fprintf(stderr, "OK - that worked. semget() returned %i\n", semid);
	return 0;
}