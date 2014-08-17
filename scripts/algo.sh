#!/bin/bash

if [ $# -ne 2 ] ; then
 echo "uses /tmp/incoming{1,2,3}... usage: ./algo.sh <max_size_of_a_file> <total_#_of_files>" && exit 1
fi

export MAX_NUM=10000000000
export MAX_SIZE=$1
export TOT_FILES=$2

mkfile() {
	EXT=$1
	i=$2
	for j in `seq 1 $(($RANDOM % $MAX_NUM))|tail -n 1`; do
		BYTES=$(($j%$MAX_SIZE))
		echo "Writing $BYTES to /tmp/incoming$EXT/$i"
		head -c $BYTES /dev/zero > /tmp/incoming$EXT/$i.mov
	done
}

for i in `seq 1 $TOT_FILES`; do

	mkfile 1 $i
	mkfile 2 $i
	mkfile 3 $i

done
