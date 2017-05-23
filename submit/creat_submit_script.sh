#!/bin/bash
peram_dir=/hiskp2/perambulators/A40.32_second-run_sorted/charm_2250
data_dir=/hiskp2/tingchen/DDscattering/data/A40.32/charm_225_4channels
conf=210
while [ $conf -le 210 ]
 do
#   if [ -d $peram_dir/cnfg$conf ] && [ ! -e $data_dir/sum/DDstar_DDstar_corr_T1_TP3_55.0.conf$conf.dat ]; then
   sed "s/=CONF=/$conf/g" submit.script > submit.$conf.sh
   chmod +x submit.$conf.sh
   qsub submit.$conf.sh
   echo $conf
#   fi
 let  "conf = $conf + 4"
 done




