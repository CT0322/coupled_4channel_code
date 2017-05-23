#!/bin/bash
data_dir=/hiskp2/tingchen/DDscattering/data/A40.32/charm_225
conf=550
# Set start value of node number
nodenum=2
while [ $conf -le 1198 ]
 do
   while [ `qstat -u tingchen | grep tingchen | wc -l` -gt 11 ]; do echo "queue is full"; sleep 30; done
   if [ ! -e $data_dir/$conf.tar ] || [ ! -e $data_dir/sum/DDstar_DDstar_corr_T1_TP3_55.0.conf$conf.dat ]; then
# =NODE= in submit.script is replaced by the name of the destination node
  sed "s/=CONF=/$conf/g" submit.script.node2-4 | sed "s/=NODE=/lnode0${nodenum}/g" > submit.$conf.sh
  chmod +x submit.$conf.sh
  qsub submit.$conf.sh
#   echo $conf
# Increase node number
  nodenum=$((${nodenum}+1))
# Only submit to lnode02 lnode03 and lnode04. Therefore reset node number to 2
  if [ ${nodenum} -gt 12 ]; then
    nodenum=2
  fi
   fi
 let  "conf = $conf + 4"
 done



