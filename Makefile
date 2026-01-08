SHELL := /bin/bash

setup: 
	git submodule update --init

synth:
	genus -batch -files synthesis.tcl -log "logs/synth.log logs/synth.cmd"

floorplan:
	innovus -stylus -batch -files floorplan.tcl -no_logv -log "logs/floorplan.log logs/floorplan.cmd"

pnr:
	innovus -stylus -batch -files pnr.tcl -no_logv -log "logs/pnr.log logs/pnr.cmd"

run_checks:
	./run_virtuoso_import.sh
	./run_pegasus_drc.sh
	./run_pegasus_lvs.sh
	./run_checks.sh

all: synth floorplan pnr run_checks

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
