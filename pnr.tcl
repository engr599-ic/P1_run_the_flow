
set_multi_cpu_usage -remote_host 4 -local_cpu 4

read_db dbs/floorplan.db/

set DESIGN_NAME [get_db current_design .name]

# Place the standard cells
set_db place_global_place_io_pins true
place_opt_design
add_tieoffs
write_db -common dbs/place.db

# Run Clock Tree Synthesis (CTS)
clock_opt_design
write_db -common dbs/ccopt.db

# Route the signal nets
route_opt_design
time_design -post_route
time_design -post_route -hold
opt_design -post_route
write_db -common dbs/route.db

# add filler cells
add_fillers -base_cells {sky130_fd_sc_ms__fill_8 sky130_fd_sc_ms__fill_4 sky130_fd_sc_ms__fill_2 sky130_fd_sc_ms__fill_1}

# Extract a resistor capacitor model of the chip
extract_rc
opt_signoff -all -report_dir timing_report
report_timing -late
report_timing -early
write_db -common dbs/signoff.db

# Write out a post PnR netlist for simulation and LVS
write_netlist -exclude_leaf_cells -include_pg -omit_floating_ports -update_tie_connections ${DESIGN_NAME}_post_pnr_lvs.vg
write_netlist -remove_power_ground ${DESIGN_NAME}_post_pnr_sim.vg

# Write a DRC report
check_drc -out_file drc.rpt
check_connectivity -out_file connect.rpt -ignore_dangling_wires

get_db current_design .bbox.area > area.rpt

set IO_DIR /l/open_pdks/sky130/custom/sky130_fd_io/
set OTHER_IO_DIR /l/skywater-pdk/libraries/sky130_fd_io/latest/cells/

set IO_GDS [glob -nocomplain -type f $IO_DIR/gds/*.gds]
set OTHER_IO_GDS [glob -nocomplain -type f $OTHER_IO_DIR/**/*.gds]


set PDK_DIR /l/sky130_release_0.1.0

set STDCELL_MS_DIR /l/skywater-pdk/libraries/sky130_fd_sc_ms/latest/cells/
set STDCELL_HS_DIR /l/skywater-pdk/libraries/sky130_fd_sc_hs/latest/cells/

set STDCELL_GDS [glob -nocomplain -type f $STDCELL_MS_DIR/**/*.gds]
lappend STDCELL_GDS [glob -nocomplain -type f $STDCELL_HS_DIR/**/*.gds]

#set SRAM_GDS ./sram-pnr/sram.gds.gz
#set ALL_GDS [list {*}$STDCELL_GDS {*}$SRAM_GDS ]

write_stream ${DESIGN_NAME}.gds.gz \
    -map_file ./sky130_stream.mapFile \
    -lib_name DesignLib \
    -merge $STDCELL_GDS \
    -unit 1000 -mode all
