
set_units -time ns
create_clock -name clk -period 500 -waveform {0 1000} [get_ports {clk}]
