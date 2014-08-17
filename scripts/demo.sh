#!/bin/bash

while true; do
 SIZE=$((($RANDOM%1000000)+1))
 TOT=$((($RANDOM%100)+1))
 ./scripts/algo.sh $SIZE $TOT
 sleep 2
done
