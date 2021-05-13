#include <stdio.h>


#define ATIME  6

long int new_time(long int tim)

{

    int days[]={31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    long int ntim=tim;
    long int tim_hr, tim_day, tim_month;
    int hour, day, month, year;

    year = (int)(tim / 1000000);

    days[1] = (year % 4) ? 28 : 29;

    ntim += ATIME;

    tim_hr = ((ntim / 100) * 100);

    hour = ntim % tim_hr;

    if(hour >= 24){

      ntim -= 24;
      ntim += 100;
      tim_hr += 100;


      tim_day = ((tim_hr / 10000) * 10000);
      day = (tim_hr % tim_day) / 100;

      tim_month = ((tim_day / 1000000) * 1000000);
      month = (tim_day % tim_month) / 10000;



      if(day > days[month - 1]) {

         ntim -= days[month - 1] * 100;
         ntim += 10000;

         tim_day += 10000;

         month = (tim_day % tim_month) / 10000;


         if(month > 12){

            ntim -= 120000;
            ntim += 1000000;


         }        

      }

    }


    return ntim;


}
