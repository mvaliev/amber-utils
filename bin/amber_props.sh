#!/bin/bash

script=`mktemp maratXXX`

cat > $script << EOF
readdata $1
#writedata etot-vs-time.dat eq4.out[TEMP] eq4.out[Etot]  eq4.out[EPtot] time 0.001
writedata tmp.dat $1[TEMP]  $1[Etot]  $1[EPtot] time 0.001
EOF

cpptraj < $script

