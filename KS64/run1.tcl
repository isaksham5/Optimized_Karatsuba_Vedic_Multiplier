
set_db use_scan_seqs_for_non_dft false
set_db init_lib_search_path /home/cadence/install/FOUNDRY/digital/90nm/dig/lib/
set_db init_hdl_search_path /home/userdata/25bvd0079/KS64
read_libs slow.lib
read_hdl ./RCA64.v ./full_adder.v
elaborate RCA64
read_sdc ./SDC2.sdc

# Reduce optimization
set_db syn_generic_effort low
set_db syn_map_effort low

# Preserve structure
set_db auto_ungroup none
# Optional strict control
# set_dont_touch [get_cells *]


create_clock -name clk -period 2
set_input_delay 0.2 -clock clk [all_inputs]
set_output_delay 0.2 -clock clk [all_outputs]

syn_gen
syn_map
syn_opt

report_timing
report area

report_timing > ./reports/RCA64_timing.rpt
report_area > ./reports/RCA64_area.rpt
report_power > ./reports/RCA64_power.rpt
report_qor > ./reports/RCA64_qor.rpt

write_hdl >  RCA64_netlist.v
write_sdc >  RCA64_netlist.sdc

