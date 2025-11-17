#!/bin/bash 

#stop on fail
set -e 

# Get the absolute path of the script
SCRIPT_PATH="$(readlink -f "$0")"
# Get the directory of the script
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

TOP_MODULE=$(grep 'set TOP_MODULE' synthesis.tcl  | awk '{print $3}')
echo "Running on TOP_MODULE: ${TOP_MODULE}"

GDS_PATH=${SCRIPT_DIR}/${TOP_MODULE}.gds.gz
if ! [ -e "$GDS_PATH" ]; then
  echo "ERROR:  ${GDS_PATH} does not exist."
  exit 1
fi



if ! [ -e cds.lib ]; then
    echo "generating CDS.LIB"
    echo "" > cds.lib
    echo "SOFTINCLUDE /nfs/nfs5-insecure/home/insecure-ro/software/rhel7_x86_64/cadence/installs/IC618/share/cdssetup/dfII/cds.lib" >> cds.lib
    echo "SOFTINCLUDE /nfs/nfs5-insecure/home/insecure-ro/software/rhel7_x86_64/cadence/installs/IC618/share/cdssetup/hdl/cds.lib" >> cds.lib
    echo "SOFTINCLUDE /nfs/nfs5-insecure/home/insecure-ro/software/rhel7_x86_64/cadence/installs/IC618/share/cdssetup/pic/cds.lib" >> cds.lib
    echo "SOFTINCLUDE /nfs/nfs5-insecure/home/insecure-ro/software/rhel7_x86_64/cadence/installs/IC618/share/cdssetup/sg/cds.lib" >> cds.lib
    echo "DEFINE sky130_fd_pr_main /l/sky130_release_0.1.0/libs/sky130_fd_pr_main" >> cds.lib
fi

echo "streaming in gds"
strmin \
    -library  "${TOP_MODULE}_virtuoso_library"\
    -strmFile "${GDS_PATH}"\
    -attachTechFileOfLib 'sky130_fd_pr_main' \
    -logFile "./strmIn.log"

