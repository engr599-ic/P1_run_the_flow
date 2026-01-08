set_multi_cpu_usage -remote_host 4 -local_cpu 4
read_db dbs/syn_opt.db/

create_net -physical -name VPWR -power
create_net -physical -name VGND -ground

# Enable OCV (On Chip Variation)
# This takes into account process variation
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both

# Don't allow the tool to route on the two topmost metal layers
set_db design_top_routing_layer met4
set_db design_bottom_routing_layer met1

# shoot for 50% utilization
create_floorplan -stdcell_density_size {1.0 0.5 2 2 2 2}

# If you have presaved a floorplan replace the above command with this
#read_floorplan top.fp


# Ensure power pins are connected to power nets
connect_global_net VPWR -type pg_pin -pin_base_name VPWR -all
connect_global_net VPWR -type net -net_base_name VPWR -all

connect_global_net VPWR -type pg_pin -pin_base_name VPB -all
connect_global_net VPWR -type pg_pin -pin_base_name VCCD -all

connect_global_net VGND -type pg_pin -pin_base_name VGND -all
connect_global_net VGND -type net -net_base_name VGND -all

connect_global_net VGND -type pg_pin -pin_base_name VNB -all
connect_global_net VGND -type pg_pin -pin_base_name VSSD -all

add_well_taps -cell sky130_fd_sc_ms__tapvpwrvgnd_1 -cell_interval 60 -in_row_offset 30

## Add vertical and horizontal power straps

#follow pins
route_special -connect core_pin -layer_change_range { li1(1) rdl(7) } -block_pin_target nearest_target -core_pin_target none -allow_jogging 1 -crossover_via_layer_range { li1(1) rdl(7) } -nets { VPWR VGND } -allow_layer_change 1 -target_via_layer_range { li1(1) rdl(7) }

add_stripes -nets {VPWR VGND} -layer met5 -direction horizontal -width 12 -spacing 12 -number_of_sets 3 -create_pins 1 -start_from left -start_offset 12 -stop_offset 12 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit rdl -pad_core_ring_bottom_layer_limit li1 -block_ring_top_layer_limit rdl -block_ring_bottom_layer_limit li1 -use_wire_group 0 -snap_wire_center_to_grid none

add_stripes -nets {VPWR VGND} -layer met4 -direction vertical -width 12 -spacing 12 -number_of_sets 3  -create_pins 1 -start_from left -start_offset 12 -stop_offset 12 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit rdl -pad_core_ring_bottom_layer_limit li1 -block_ring_top_layer_limit rdl -block_ring_bottom_layer_limit li1 -use_wire_group 0 -snap_wire_center_to_grid none

add_rings -nets {vddio vssio} -type core_rings -follow core -layer {top met1 bottom met1 left met1 right met1} -width {top 1 bottom 1 left 1 right 1} -spacing {top 0.14 bottom 0.14 left 0.14 right 0.14} -offset {top 10 bottom 10 left 10 right 10} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

# general PG route
route_special -connect {block_pin pad_pin pad_ring floating_stripe} -layer_change_range { li1(1) rdl(7) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { li1(1) rdl(7) } -nets { VPWR VGND } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { li1(1) rdl(7) }

# general PG route (again, focused on IO Power cells)
route_special -connect {pad_pin} -layer_change_range { li1(1) rdl(7) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -allow_jogging 1 -crossover_via_layer_range { li1(1) rdl(7) } -nets { VPWR VGND } -allow_layer_change 1 -target_via_layer_range { li1(1) rdl(7) }

route_special -connect {pad_pin} -layer_change_range { li1(1) rdl(7) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {stripe} -allow_jogging 1 -crossover_via_layer_range { li1(1) rdl(7) } -nets { VPWR } -allow_layer_change 1 -target_via_layer_range { li1(1) rdl(7) }

# Route the power and ground nets, the tool treats power and ground routes as special and seperate from signal routes
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { li1(1) rdl(7) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {none} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { li1(1) rdl(7) } -nets { vddio vssio } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { li1(1) rdl(7) }


set_db place_global_place_io_pins true

write_floorplan top.fp

# Save a database
write_db -common dbs/floorplan.db
