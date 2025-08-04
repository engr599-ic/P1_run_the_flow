create_library_set -name ss_m40_lib\
   -timing\
    [list /pdks/google/skywater-pdk/libraries/sky130_fd_sc_hs/latest/timing/sky130_fd_sc_hs__ss_n40C_1v60.lib]
create_library_set -name tt_25_lib\
   -timing\
    [list /pdks/google/skywater-pdk/libraries/sky130_fd_sc_hs/latest/timing/sky130_fd_sc_hs__tt_025C_1v80.lib]
create_library_set -name ff_150_lib\
   -timing\
    [list /pdks/google/skywater-pdk/libraries/sky130_fd_sc_hs/latest/timing/sky130_fd_sc_hs__ff_150C_1v95.lib]
create_library_set -name ff_m40_lib\
   -timing\
    [list /pdks/google/skywater-pdk/libraries/sky130_fd_sc_hs/latest/timing/sky130_fd_sc_hs__ff_n40C_1v95.lib] 
create_library_set -name ss_150_lib\
   -timing\
    [list /pdks/google/skywater-pdk/libraries/sky130_fd_sc_hs/latest/timing/sky130_fd_sc_hs__ss_150C_1v60.lib] 
create_timing_condition -name ff_150_cond\
   -library_sets [list ff_150_lib]
create_timing_condition -name ss_m40_cond\
   -library_sets [list ss_m40_lib]
create_timing_condition -name ss_150_cond\
   -library_sets [list ss_150_lib]
create_timing_condition -name tt_25_cond\
   -library_sets [list tt_25_lib]
create_timing_condition -name ff_m40_cond\
   -library_sets [list ff_m40_lib]
create_rc_corner -name ff_150_rc\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -post_route_clock_cap {1 1 1}\
   -post_route_clock_res {1 1 1}\
   -post_route_clock_cross_cap {1 1 1}\
   -temperature 150
create_rc_corner -name ff_m40_rc\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -post_route_clock_cap {1 1 1}\
   -post_route_clock_res {1 1 1}\
   -post_route_clock_cross_cap {1 1 1}\
   -temperature -40
create_rc_corner -name ss_150_rc\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -post_route_clock_cap {1 1 1}\
   -post_route_clock_res {1 1 1}\
   -post_route_clock_cross_cap {1 1 1}\
   -temperature 150
create_rc_corner -name ss_m40_rc\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -post_route_clock_cap {1 1 1}\
   -post_route_clock_res {1 1 1}\
   -post_route_clock_cross_cap {1 1 1}\
   -temperature -40
create_rc_corner -name tt_25_rc\
   -pre_route_res 1\
   -post_route_res {1 1 1}\
   -pre_route_cap 1\
   -post_route_cap {1 1 1}\
   -post_route_cross_cap {1 1 1}\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -post_route_clock_cap {1 1 1}\
   -post_route_clock_res {1 1 1}\
   -post_route_clock_cross_cap {1 1 1}\
   -temperature 25
create_delay_corner -name ff_150_delay\
   -early_timing_condition {ff_150_cond}\
   -late_timing_condition {ff_150_cond}\
   -rc_corner ff_150_rc
create_delay_corner -name tt_25_delay\
   -early_timing_condition {tt_25_cond}\
   -late_timing_condition {tt_25_cond}\
   -rc_corner tt_25_rc
create_delay_corner -name ss_m40_delay\
   -early_timing_condition {ss_m40_cond}\
   -late_timing_condition {ss_m40_cond}\
   -rc_corner ss_m40_rc
create_delay_corner -name ss_150_delay\
   -early_timing_condition {ss_150_cond}\
   -late_timing_condition {ss_150_cond}\
   -rc_corner ss_150_rc
create_delay_corner -name ff_m40_delay\
   -early_timing_condition {ff_m40_cond}\
   -late_timing_condition {ff_m40_cond}\
   -rc_corner ff_m40_rc
create_constraint_mode -name func\
   -sdc_files\
    [list functional.sdc]
create_analysis_view -name ss_150_view -constraint_mode func -delay_corner ss_150_delay -latency_file /home/jackclar/git/riscv-s130/flowtool_setup/PnR/picorv32.module/dbs/postroute.enc_2/mmmc/views/ss_150_view/latency.sdc.gz
create_analysis_view -name tt_25_view -constraint_mode func -delay_corner tt_25_delay -latency_file /home/jackclar/git/riscv-s130/flowtool_setup/PnR/picorv32.module/dbs/postroute.enc_2/mmmc/views/tt_25_view/latency.sdc.gz
create_analysis_view -name ff_m40_view -constraint_mode func -delay_corner ff_m40_delay -latency_file /home/jackclar/git/riscv-s130/flowtool_setup/PnR/picorv32.module/dbs/postroute.enc_2/mmmc/views/ff_m40_view/latency.sdc.gz
create_analysis_view -name ff_150_view -constraint_mode func -delay_corner ff_150_delay -latency_file /home/jackclar/git/riscv-s130/flowtool_setup/PnR/picorv32.module/dbs/postroute.enc_2/mmmc/views/ff_150_view/latency.sdc.gz
create_analysis_view -name ss_m40_view -constraint_mode func -delay_corner ss_m40_delay -latency_file /home/jackclar/git/riscv-s130/flowtool_setup/PnR/picorv32.module/dbs/postroute.enc_2/mmmc/views/ss_m40_view/latency.sdc.gz
set_analysis_view -setup [list tt_25_view ss_m40_view ss_150_view] -hold [list tt_25_view ff_150_view ff_m40_view]
