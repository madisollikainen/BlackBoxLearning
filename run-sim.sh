#!/bin/bash

# Get the number of simulations to run
N=$1

# Set directories etc.
OutDir="./data"
SRC_DIR="./simulation"
SEED_FILE="${SRC_DIR}/seeds"
EXEC_DIR="${SRC_DIR}/build"
EXEC="${EXEC_DIR}/run-black-box-learning"

# Set some variables for the simulation;
# currently set to the values which were
# used for the simulations for Heinrich
P0=100
F=0.01
TM=1000
aB=10.0
aS=1.0

# If need be, make the data dir
mkdir -p ${OutDir}

# Read the seed file
mapfile -n $N -t SEEDS < $SEED_FILE

for ((i=1; i<=${N}; i++ ))
# for i in "${SEEDS[@]}"
do
	seed=${SEEDS[$(($i-1))]}

	./${EXEC} -TM ${TM} -TP 1 -P0 ${P0} -F ${F} -aB ${aB} -aS ${aS} -R 0.4 -seed ${seed}

	mv payoffs.dat ${OutDir}/payoffs_R0.4_S${seed}_nr${i}.dat
	mv strategies.dat ${OutDir}/strategies_R0.4_S${seed}_nr${i}.dat

	./${EXEC} -TM ${TM} -TP 1 -P0 ${P0} -F ${F} -aB ${aB} -aS ${aS} -R 1.6 -seed ${seed}

	mv payoffs.dat ${OutDir}/payoffs_R1.6_S${seed}_nr${i}.dat
	mv strategies.dat ${OutDir}/strategies_R1.6_S${seed}_nr${i}.dat


	echo "Completed the ${i}-th simulation run for both R={0.4, 1.6} (RNG seed $seed)"
done
