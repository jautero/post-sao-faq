#include <stdio.h>
#include <stdlib.h>

typedef unsigned long long octa;

int main(int argc, char * argv[])
{
  FILE * rfp;
  octa val;
  int res;

  if (argc == 0) 
    {
      fprintf(stderr, "What is my name?\n");
      exit(EXIT_FAILURE);
    }

  rfp = fopen("/dev/urandom", "r");
  if (rfp == NULL)
    {
      perror(argv[0]);
      exit(EXIT_FAILURE);
    }
  
  res = fread(&val, sizeof(val), 1, rfp);
  if (res != 1)
    {
      if (ferror(rfp))
	{
	  perror(argv[0]);
	  exit(EXIT_FAILURE);
	}
    }
  
  printf("%llX\n", val);
  return 0;
}
