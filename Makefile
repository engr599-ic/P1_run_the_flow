SHELL := /bin/bash

setup: 
	git submodule update --init

synth:
	genus -batch -files synthesis.tcl

pnr:
	innovus -stylus -batch -files pnr.tcl

all: synth pnr

clean:
	rm -rf dbs/*
	rm -f *.log*
	rm -f *.cmd*
	rm -rf RPT_final*
	rm -rf timingReports
	rm -rf fv
	rm -rf client_log
	rm -f *.vg
