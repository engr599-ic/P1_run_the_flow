SHELL := /bin/bash

setup: 
	git submodule update --init

synth:
	genus -batch -files synthesis.tcl

floorplan:
	innovus -stylus -batch -files floorplan.tcl

pnr:
	innovus -stylus -batch -files pnr.tcl

check_timing:
	./check_timing.sh

all: synth floorplan pnr check_timing

clean:
	rm -rf dbs* fv
	rm -rf *.log*
	rm -rf *.cmd*
	rm -rf innovus_temp_*
	rm -rf timingReports
	rm -rf timing_report
	rm -rf *.vg
	rm -rf RPT_final*
	rm -rf client_log
	rm -f *.vg
	rm -f *.rpt*
