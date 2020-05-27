vsim -gui work.processor
mem load -skip 0 -filltype value -filldata 16'h0000 -fillradix hexadecimal /processor/instmem1/ram
mem load -skip 0 -filltype inc -filldata 16'h0000 -fillradix hexadecimal /processor/MEMORY/ram
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/input \
sim:/processor/intr \
sim:/processor/reset \
sim:/processor/output
force -freeze sim:/processor/clk 1 0, 0 {200 ns} -r 400
force -freeze sim:/processor/input 32'h00000000 0
force -freeze sim:/processor/intr 0 0
force -freeze sim:/processor/reset 0 0
add wave -position insertpoint  \
sim:/processor/r0 \
sim:/processor/r1 \
sim:/processor/r2 \
sim:/processor/r3 \
sim:/processor/r4 \
sim:/processor/r5 \
sim:/processor/r6 \
sim:/processor/r7
add wave -position insertpoint  \
sim:/processor/FPC
add wave -position insertpoint  \
sim:/processor/inst
add wave -position insertpoint  \
sim:/processor/npc