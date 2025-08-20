SHELL := /bin/bash

setup: 
	git submodule update --init

synth:
	genus -batch -files synthesis.tcl
pnr:
	innovus -stylus -batch -files pnr.tcl
clean:
	rm -rf dbs/*
	rm *.log*
	rm *.cmd*
