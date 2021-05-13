/* header for file handing function prototypes */

#define   APPS    "_"      /* file name append character */

#define  ORIGIN  1        /* random file access from current file position */
#define  FSTART  0        /* random file access from start of file         */


FILE *open_file(char * , char * );
void close_file(FILE * , char * );
char *file_exist(char *, char * , char * );
int fexist(char *, char * );
