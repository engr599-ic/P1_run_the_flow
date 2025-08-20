
set_units -time ns
create_clock -name clk -period 100 -waveform {0 50} [get_ports {clk}]
