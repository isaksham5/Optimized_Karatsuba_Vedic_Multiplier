set_db use_scan_seqs_for_non_dft false
set_db init_lib_search_path /home/cadence/install/FOUNDRY/digital/90nm/dig/lib/
set_db init_hdl_search_path /home/userdata/25bvd0079/KS128
read_libs slow.lib
read_hdl {./CLA128.v ./CLA64.v ./CLA16.v ./CLA8.v ./CLA4.v ./initialize.v}
elaborate CLA128
read_sdc ./SDC2.sdc
set_db syn_generic_effort low
set_db syn_map_effort low
set_db auto_ungroup none
syn_gen
syn_map
syn_opt
set_db [get_designs CLA128] .preserve true
file mkdir ./netlist
file mkdir ./reports
report_timing 
report_area
report_power
report_qor
report_timing  > ./reports/CLA128_timing.rpt
report_area > ./reports/CLA128_area.rpt
report_power > ./reports/CLA128_power.rpt
report_qor > ./reports/CLA128_qor.rpt
write_netlist CLA128 > ./netlist/CLA128_netlist.v
write_sdc > ./netlist/CLA128_netlist.sdc

