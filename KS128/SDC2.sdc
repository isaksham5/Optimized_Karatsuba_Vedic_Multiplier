# Clock (assume you add clk port for ASIC flow)
create_clock -name clk -period 2 [get_ports clk]

# Input delays
set_input_delay  0.2 -clock clk [all_inputs]

# Output delays
set_output_delay 0.2 -clock clk [all_outputs]

# Driving cell (optional but good)
set_driving_cell -lib_cell INVX1 [all_inputs]

# Load (optional)
set_load 0.01 [all_outputs]