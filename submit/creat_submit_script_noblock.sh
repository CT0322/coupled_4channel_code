#!/bin/bash

#determine available nodes
declare -a nodes
nodes+=(lnode{01..12} lcpunode01 lcpunode01 lcpunode01 lcpunode01 lcpunode01 lcpunode01 lcpunode01 lcpunode01)

declare -a availnodes
for node in ${nodes[*]}; do
  nodestate=$(pbsnodes | grep -A1 ^${node} | grep state | awk '{print $3}')
  if [ ! ${nodestate} = "offline" -a ! ${nodestate} = "down" ]; then
    availnodes+=(${node})
    echo "available node: $node"
  fi
done

#submit jobs
data_dir=/hiskp2/tingchen/DDscattering/data/A40.32/charm_225
conf=962
# Set start value of node number
nodenum=0
jobnum=1
declare -a jobids

while [ $conf -le 1198 ]
 do
   if [ ! -e $data_dir/$conf.tar ] || [ ! -e $data_dir/sum/DDstar_DDstar_corr_T1_TP3_55.0.conf$conf.dat ]; then

# set node
  node=${availnodes[$nodenum]}

# =NODE= in submit.script is replaced by the name of the destination node
  sed "s/=CONF=/$conf/g" submit.script.node2-4 | sed "s/=NODE=/${node}/g" > submit.$conf.sh
  chmod +x submit.$conf.sh
# generate dependency
  oldjobnum=$(($jobnum-${#availnodes[*]}))
  dep=""
  if [ $oldjobnum -ge 1 ]; then
    dep="-W depend=afterok:${jobids[$oldjobnum]}"
  fi
#  jobids[$jobnum]=$jobnum
#  echo qsub $dep submit.$conf.sh $node
  jobids[$jobnum]=$(qsub $dep submit.$conf.sh)
#   echo $conf
  jobnum=$((${jobnum}+1))
# Increase node number
  nodenum=$((${nodenum}+1))
  if [ ${nodenum} -ge ${#availnodes[*]} ]; then
    nodenum=0
  fi
   fi
 let  "conf = $conf + 4"
 done



