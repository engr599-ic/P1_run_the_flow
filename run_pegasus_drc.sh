#!/bin/bash 

#fail on error
set -e

NUM_CPUS=4

# Get the absolute path of the script
SCRIPT_PATH="$(readlink -f "$0")"
# Get the directory of the script
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
WORK_DIR=${SCRIPT_DIR}/pegasus_drc

TOP_MODULE=$(grep 'set TOP_MODULE' synthesis.tcl  | awk '{print $3}')
echo "Running on TOP_MODULE: ${TOP_MODULE}"

GDS_PATH=${SCRIPT_DIR}/${TOP_MODULE}.gds.gz
if ! [ -e "$GDS_PATH" ]; then
  echo "ERROR:  ${GDS_PATH} does not exist."
  exit 1
fi

mkdir -p ${WORK_DIR}
pushd ${WORK_DIR}

echo "Generating Control File"
CTRL_FILE=${WORK_DIR}/pegasusdrcctl
REPORT_FILE=${WORK_DIR}/${TOP_MODULE}.drc_errors.ascii
SUM_FILE=${WORK_DIR}/${TOP_MODULE}.sum

echo "" > $CTRL_FILE
echo "report_summary -drc \"${TOP_MODULE}.sum\" -replace;" >> $CTRL_FILE
echo "max_results -drc 1000;" >> $CTRL_FILE
echo "results_db -drc \"${REPORT_FILE}\" -ascii;" >> $CTRL_FILE
echo "abort_on_layout_error yes;" >> $CTRL_FILE
echo "layout_format gdsii;" >> $CTRL_FILE
echo "layout_path \"${GDS_PATH}\";" >> $CTRL_FILE
# Disable Density Checks
echo "#DEFINE NODEN" >> ${CTRL_FILE}
#Disable Guidline Rules
echo "#DEFINE NOGLR" >> ${CTRL_FILE}
# Disable Warnings
echo "#DEFINE NOWARN" >> ${CTRL_FILE}


echo "Surpressing warnings"
unset which
unset ml
unset module
unset switchml
unset _module_raw

PEGASUS_DRC=/l/sky130_release_0.1.0/Sky130_DRC

echo "Running PEGASUS DRC on ${GDS_PATH}"
#/l/cadence/installs/PEGASUS213/bin/pegasus \
pegasus  \
	-top_cell ${TOP_MODULE}\
	-ui_data \
	--control ${CTRL_FILE} \
	-dp ${NUM_CPUS}  \
	/l/sky130_release_0.1.0/Sky130_DRC/sky130_rev_0.0_2.12.drc.pvl

	#/l/sky130_release_0.0.1/Sky130_DRC/sky130_rev_0.0_1.0.drc.pvl
popd

if ! [ -e "$REPORT_FILE" ]; then
  echo "ERROR:  ${REPORT_FILE} does not exist."
  exit 1
fi
if ! [ -e "$SUM_FILE" ]; then
  echo "ERROR:  ${SUM_FILE} does not exist."
  exit 1
fi

echo "Checking DRC Results"
grep 'Total DRC Results' ${WORK_DIR}/${TOP_MODULE}.sum


CLEAN=$(grep 'Total DRC Results' ${WORK_DIR}/${TOP_MODULE}.sum  | awk '{print $5 != 0}')

if [ ${CLEAN} -ne 0 ]; then
    echo "DRC FAIL"
    exit 1
fi

echo "DRC PASS"

