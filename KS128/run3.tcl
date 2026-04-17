
set_db use_scan_seqs_for_non_dft false
set_db init_lib_search_path /home/cadence/install/FOUNDRY/digital/90nm/dig/lib/
set_db init_hdl_search_path /home/userdata/25bvd0079/KS128
read_libs slow.lib
read_hdl {./RCA128.v ./full_adder.v}
elaborate RCA128
read_sdc ./SDC2.sdc


create_clock -name clk -period 2
set_input_delay 0.2 -clock clk [all_inputs]
set_output_delay 0.2 -clock clk [all_outputs]

syn_gen
syn_map
syn_opt

report_timing
report_area

file mkdir ./reports
file mkdir ./netlist
report_timing > ./reports/RCA128_timing.rpt
report_area > ./reports/RCA128_area.rpt
report_power > ./reports/RCA128_power.rpt
report_qor > ./reports/RCA128_qor.rpt

write_hdl >  ./netlist/RCA128_netlist.v
write_sdc >  ./netlist/RCA128_netlist.sdc

# Reduce optimization
set_db syn_generic_effort low
set_db syn_map_effort low

# Preserve structure
set_db auto_ungroup none
set_db preserve true [get_designs *]

# Optional strict control
# set_dont_touch [get_cells *]

