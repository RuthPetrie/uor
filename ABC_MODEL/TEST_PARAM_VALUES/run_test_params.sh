#/usr/bin/ksh

# run the code with all different values of the parameters

cd /home/wx019276/ABC_MODEL/TEST_PARAM_VALUES

# initialisation
setup studio12
export NAG_KUSARI_FILE=/opt/compilers/NAG/license.dat
export LD_LIBRARY_PATH=$LIBRARY_PATH:/opt/graphics/64/lib

for i in {1..6}; do
 
  cd  expt_a${i}
  make clean
  make
  Main.out

done


for i in {1..6}; do
 
  cd  expt_b${i}
  make clean
  make
  Main.out

done

for i in {1..6}; do
 
  cd  expt_c${i}
  make clean
  make
  Main.out

done

for i in {1..6}; do
 
  cd  expt_d${i}
  make clean
  make
  Main.out

done

for i in {1..6}; do
 
  cd  expt_e${i}
  make clean
  make
  Main.out

done

