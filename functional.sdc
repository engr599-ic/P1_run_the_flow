
set_units -time ns
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
