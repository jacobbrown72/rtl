#!/bin/bash

if [ ! -d "work" ]; then
    echo "Creating work ModelSim work directory"
    vlib work
else
    echo "ModelSim work directory already exists"
fi

echo "Compiling vhdl files"
vcom alu.vhd
vcom databus.vhd
vcom pc.vhd
vcom pswreg.vhd
vcom spreg.vhd
vcom regsel.vhd
vcom iobus.vhd
vcom regfile.vhd
vcom rom.vhd
vcom ram.vhd
vcom datapath.vhd
vcom controller.vhd
vcom avr8.vhd
vcom avr_tb.vhd
