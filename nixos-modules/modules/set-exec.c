#include <linux/securebits.h>
#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>

int
main (int argc, char **argv)
{
  int sb;

  if (argc < 2)
    {
      fprintf (stderr, "usage: %s CMD [ARGS...]\n", argv[0]);
      return 1;
    }
  sb = prctl (PR_GET_SECUREBITS);
  if (sb < 0 || prctl (PR_SET_SECUREBITS, sb | SECBIT_EXEC_RESTRICT_FILE, 0, 0, 0))
    {
      perror ("prctl");
      return 1;
    }
  execvp (argv[1], argv + 1);
  perror ("execvp");
  return 1;
}
