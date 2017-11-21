#!/bin/bash

# (C) 2017 University of Bristol. See License.txt

HERE=$(cd `dirname $0`; pwd)
SPDZROOT=/home/akannan/spdz2/SPDZ-2-master/Scripts/..

NTrials=100
i=0

rm outputTime.txt
rm TimeVals.txt

bits=${2:-512}
g=${3:-0}
mem=${4:-empty}

#. $HERE/run-common.sh
#run_player Player-Online.x ${1:-test_all} -lgp ${bits} -lg2 ${g} -m ${mem} || exit 1 | tail -32 | head -1 > output.txt 

while [ $NTrials -gt 0 ]
do
	. $HERE/run-common.sh
	run_player Player-Online.x ${1:-test_all} -lgp ${bits} -lg2 ${g} -m ${mem} | tail -32 | head -1 >> outputTime.txt
	NTrials=`expr $NTrials - 1`
	i=`expr $i + 1`
done

#To get the time values after 'Finish timer'
cat outputTime.txt | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' > TimeVals.txt

#To compute sum of time taken for NTrials 
SUM=$(python -c "import sys; print sum((float(l) for l in sys.stdin))" < TimeVals.txt)

#To compute average time
RESULT=$(echo "scale=10; $SUM/$i" | bc)
echo The average time for $i iterations is $RESULT
