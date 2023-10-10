vlib work
vlog ram.v RAM_TB.sv golden_ref.sv package.sv RAM_SVA.sv +cover 
vsim -voptargs=+acc work.RAM_TB -cover 
add wave *
coverage save RAM_TB.ucdb -du work.ram -onexit
run -all