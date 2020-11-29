#!/bin/bash
echo "Starting eagle ${eagle_ver} ..."


#xeyes &
#P2=$!

xterm &
P1=$!

/opt/eagle-${eagle_ver}/eagle
P3=$!

wait $P1 $P2 $P3