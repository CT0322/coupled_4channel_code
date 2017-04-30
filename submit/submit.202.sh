#!/bin/bash

#PBS -N contrac_conf.202
#PBS -l walltime=48:00:00,mem=50gb
#PBS -l nodes=1:ppn=4
#PBS -j oe
run_dir="/hiskp2/tingchen/DDscattering/DDcode/coupled_4channel/submit"
out="$run_dir/out202"

echo "job starts at" `date` > $out
export OMP_NUM_THREADS=1
cat $PBS_NODEFILE >> $out

contrac_dir="/hiskp2/tingchen/DDscattering/DDcode/coupled_4channel/main"
data_dir="/hiskp2/tingchen/DDscattering/data/A40.32/charm_225_4channels"

if [ ! -d $data_dir/sum ]; then
  mkdir $data_dir/sum
fi

  $run_dir/LapHs.sh 202 > $run_dir/contrac.202.in
  $contrac_dir/LapHs -i $run_dir/contrac.202.in &> $run_dir/contrac.202.out

cd $data_dir
tar cvf 202.tar ./*.conf202.dat
rm *.conf202.dat

echo "202 job ends at" `date` >> $out


