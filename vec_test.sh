#!/bin/bash
nvcc vec-add.cu -o vec

for i in 1 2 3 4 5 6 7 8; do /usr/bin/time -f %e ./vec $((($i-1)*1000000+1));done 