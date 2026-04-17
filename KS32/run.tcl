
set_db use_scan_seqs_for_non_dft false
set_db init_lib_search_path /home/cadence/install/FOUNDRY/digital/90nm/dig/lib/
set_db init_hdl_search_path /home/userdata/25bvd0079/KS16
read_libs slow.lib
read_hdl {./KS32.v ./initialize ./grey_cell.v ./black_cell.v}
elaborate KS32
read_sdc ./SDC2.sdc


create_clock -name clk -period 2
set_input_delay 0.2 -clock clk [all_inputs]
set_output_delay 0.2 -clock clk [all_outputs]

syn_gen
syn_map
syn_opt

report_timing
report area

report_timing > ./reports/KS32_timing.rpt
report_area > ./reports/KS32_area.rpt
report_power > ./reports/KS32_power.rpt
report_qor > ./reports/KS32_qor.rpt

write_hdl >  ./netlist/KS32_netlist.v
write_sdc >  ./netlist/KS32_netlist.sdc

# Reduce optimization
set_db syn_generic_effort low
set_db syn_map_effort low

# Preserve structure
set_db auto_ungroup none
set_db preserve true [get_designs *]

# Optional strict control
# set_dont_touch [get_cells *]

