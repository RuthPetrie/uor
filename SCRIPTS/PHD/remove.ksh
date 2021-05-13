#!/bin/ksh
for i in a*ps
do
echo $i
rm -f $i
done
