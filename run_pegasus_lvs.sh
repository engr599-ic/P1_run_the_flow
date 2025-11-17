#!/bin/bash 

#fail on error
set -e

NUM_CPUS=4

STDCELL_HOME=/l/skywater-pdk/libraries/sky130_fd_sc_ms/latest

# Get the absolute path of the script
SCRIPT_PATH="$(readlink -f "$0")"
# Get the directory of the script
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
WORK_DIR=${SCRIPT_DIR}/pegasus_lvs

TOP_MODULE=$(grep 'set TOP_MODULE' synthesis.tcl  | awk '{print $3}')
echo "Running on TOP_MODULE: ${TOP_MODULE}"

GDS_PATH=${SCRIPT_DIR}/${TOP_MODULE}.gds.gz
if ! [ -e "$GDS_PATH" ]; then
  echo "ERROR:  ${GDS_PATH} does not exist."
  exit 1
fi

NETLIST_FILE=${SCRIPT_DIR}/${TOP_MODULE}_post_pnr_lvs.vg
if ! [ -e "$NETLIST_FILE" ]; then
  echo "ERROR:  ${NETLIST_FILE} does not exist."
  exit 1
fi

mkdir -p ${WORK_DIR}
pushd ${WORK_DIR}

CTRL_FILE=${WORK_DIR}/pegasuslvsctl
INCLUDE_FILE=${WORK_DIR}/include.cdl
MYRULES_FILE=${WORK_DIR}/myrules.pvl

ERC_REPORT_FILE=${WORK_DIR}/${TOP_MODULE}.erc_errors.ascii
SUM_FILE=${WORK_DIR}/${TOP_MODULE}.sum

echo "Generating Include File"
echo "" > ${INCLUDE_FILE}
echo ".OPTION SCALE 1e-6" >> ${INCLUDE_FILE}
for CDL in ${STDCELL_HOME}/cells/*/*.cdl ; do
    echo ".include \"${CDL}\" " >> ${INCLUDE_FILE}
done

echo "Generating MYRULES File"
echo "" > ${MYRULES_FILE}
echo "lvs_write_netlist -layout netlist.lay " >> ${MYRULES_FILE}
echo "lvs_write_netlist -source netlist.sch " >> ${MYRULES_FILE}
echo "lvs_write_netlist_reduced -layout netlist.reduced.lay " >> ${MYRULES_FILE}
echo "lvs_write_netlist_reduced -source netlist.reduced.sch " >> ${MYRULES_FILE}

echo "Generating Control File"
echo "" > $CTRL_FILE
echo "text_depth -primary; " >> ${CTRL_FILE}
echo "virtual_connect -colon yes; " >> ${CTRL_FILE}
echo "virtual_connect -semicolon_as_colon yes; " >> ${CTRL_FILE}
echo "virtual_connect -noname; " >> ${CTRL_FILE}
echo "virtual_connect -report yes; " >> ${CTRL_FILE}
echo "virtual_connect -depth -primary; " >> ${CTRL_FILE}
echo "lvs_ignore_ports no; " >> ${CTRL_FILE}
echo "lvs_expand_cell_on_error no; " >> ${CTRL_FILE}
echo "lvs_break_ambig_max 32; " >> ${CTRL_FILE}
echo "lvs_abort -softchk no; " >> ${CTRL_FILE}
echo "lvs_abort -supply_error no; " >> ${CTRL_FILE}
echo "lvs_power_name \"VPWR\"; " >> ${CTRL_FILE}
echo "lvs_ground_name \"VGND\"; " >> ${CTRL_FILE}
echo "lvs_find_shorts no; " >> ${CTRL_FILE}
echo "sconnect_upper_shape_count no; " >> ${CTRL_FILE}
echo "lvs_report_file \"${TOP_MODULES}.rep\"; " >> ${CTRL_FILE}
echo "lvs_report_max 50 -mismatched_net_limit 100; " >> ${CTRL_FILE}
echo "lvs_run_erc_checks yes; " >> ${CTRL_FILE}
echo "lvs_report_opt -none; " >> ${CTRL_FILE}
echo "report_summary -erc \"${TOP_MODULE}.sum\" -replace; " >> ${CTRL_FILE}
echo "max_results -erc 1000; " >> ${CTRL_FILE}
echo "results_db -erc \"${ERC_REPORT_FILE}\" -ascii; " >> ${CTRL_FILE}
echo "abort_on_layout_error yes; " >> ${CTRL_FILE}
echo "layout_format gdsii; " >> ${CTRL_FILE}
echo "layout_path \"${GDS_PATH}\";" >> $CTRL_FILE
echo "schematic_path \"${NETLIST_FILE}\" verilog; " >> ${CTRL_FILE}
echo "schematic_path \"${INCLUDE_FILE}\" cdl; " >> ${CTRL_FILE}

echo "Generating run script"
cat > run.sh << EOF
    #!/bin/bash 

    unset which
    unset ml
    unset module
    unset switchml
    unset _module_raw

    PEGASUS_LVS=/l/sky130_release_0.1.0/Sky130_LVS

    echo "Running PEGASUS LVS on ${GDS_PATH}"
    pegasus \\
        -lvs \\
        -top_cell ${TOP_MODULE} \\
        -source_top_cell ${TOP_MODULE} \\
        -spice ${WORK_DIR}/${TOP_MODULE}.spi \\
        --control ${CTRL_FILE} \\
        -automatch \\
        -ui_data \\
        -gdb_data \\
        -dp ${NUM_CPUS}  \\
        ${MYRULES_FILE} \\
        /l/sky130_release_0.0.1/Sky130_LVS/Sky130_rev_0.0_0.1.lvs.pvl
EOF

#make sure old mismatch file doesn't exist
rm -rf mismatch

chmod +x run.sh

./run.sh

popd

if ! [ -e "$ERC_REPORT_FILE" ]; then
  echo "ERROR:  ${ERC_REPORT_FILE} does not exist."
  exit 1
fi
if ! [ -e "$SUM_FILE" ]; then
  echo "ERROR:  ${SUM_FILE} does not exist."
  exit 1
fi

echo "Checking ERC Results"
grep 'Total ERC Results' ${WORK_DIR}/${TOP_MODULE}.sum


CLEAN=$(grep 'Total ERC Results' ${WORK_DIR}/${TOP_MODULE}.sum  | awk '{print $5 != 0}')

if [ ${CLEAN} -ne 0 ]; then
    echo "ERC FAIL"
    exit 1
fi

echo "Checking LVS Results"
MISMATCH=${WORK_DIR}/mismatched
if [ -e "${MISMATCH}" ]; then
    grep 'Run Result' ${MISMATCH}
    echo "LVS FAIL"
    exit 1
else
    echo "No mismatches found"
    echo "     .-\"\"\"\"\"\"-."
    echo "   .'          '.    "
    echo "  /   O      O   \\  "
    echo " :                :  "
    echo " |                |  "
    echo " : ',          ,' :  "
    echo "  \\  '-......-'  /  "
    echo "   '.          .'    "
    echo "     '-......-'      "
fi

echo "LVS PASS"

