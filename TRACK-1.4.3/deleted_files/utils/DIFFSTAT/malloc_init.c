#include <stdlib.h>
#include <string.h>

/* function to call malloc and initialize the memory allocated */

void *malloc_init(int size)

{

    void *p;

    p = (void *)malloc(size);

    memset(p, NULL, size);

    return p;

}
