#!/bin/bash
#-------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#-------------------------------------------------------------
if [ "$(basename $PWD)" != "perftest" ];
then
  echo "Please execute scripts from directory 'perftest'"
  exit 1;
fi

COMMAND=$1
BASE=$2/dimensionreduction
MAXMEM=$3

FILENAME=$0
err_report() {
  echo "Error in $FILENAME on line $1"
}
trap 'err_report $LINENO' ERR

DATA=()
if [ $MAXMEM -ge 80 ]; then DATA+=("5k_2k_dense"); fi
if [ $MAXMEM -ge 800 ]; then DATA+=("50k_2k_dense"); fi
if [ $MAXMEM -ge 8000 ]; then DATA+=("500k_2k_dense"); fi
if [ $MAXMEM -ge 80000 ]; then DATA+=("5M_2k_dense"); fi
if [ $MAXMEM -ge 800000 ]; then DATA+=("50M_2k_dense"); fi

echo "RUN DIMENSION REDUCTION EXPERIMENTS: " $(date) >> results/times.txt;

# run all dimension reduction algorithms on all datasets
for d in ${DATA[@]}
do 
   echo "-- Running Dimension Reduction on "$d >> results/times.txt;
   ./runPCA.sh ${BASE}/pcaData${d} ${BASE} ${COMMAND} &> logs/runPCA_${d}.out;

done
