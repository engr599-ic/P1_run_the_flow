read_db dbs/syn_opt.db/
set_multi_cpu_usage -remote_host 1 -local_cpu 4
set_db timing_analysis_type ocv
set_db timing_analysis_cppr both


# Ensure power pins are connected to power nets
connect_global_net VPWR -type pg_pin -pin_base_name VPWR -all
connect_global_net VGND -type pg_pin -pin_base_name VGND -all

set_interactive_constraint_modes func
create_clock clk -period 5

set_db place_global_place_io_pins true
place_opt_design
add_fillers -base_cells { sky130_fd_sc_hs__fill_1 sky130_fd_sc_hs__fi l_2 sky130_fd_sc_hs__fill_4 sky130_fd_sc_hs__fill_8 }
write_db -common dbs/place.db

ccopt_design
write_db -common dbs/ccopt.db

route_opt_design
write_db -common dbs/route.db

opt_signoff -all
write_db -common dbs/signoff.db
