#!/bin/bash

script=`mktemp maratXXX`

cat > $script << EOF
parm liquid.prmtop
atominfo
EOF

cpptraj < $script

