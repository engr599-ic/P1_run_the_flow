SHELL := /bin/bash

setup: 
	git submodule update --init

synth:
	genus -batch -files synthesis.tcl

pnr:
	innovus -stylus -batch -files pnr.tcl

clean:
	rm -rf dbs* fv
	rm -rf *.log*
	rm -rf *.cmd*
	rm -rf innovus_temp_*
	rm -rf timingReports
	rm -rf *.vg
