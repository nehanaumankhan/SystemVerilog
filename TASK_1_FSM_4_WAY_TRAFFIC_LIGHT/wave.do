onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /traffic_tb/clk
add wave -noupdate /traffic_tb/rst_n
add wave -noupdate /traffic_tb/switch_to_a
add wave -noupdate /traffic_tb/switch_to_b
add wave -noupdate /traffic_tb/switch_to_c
add wave -noupdate /traffic_tb/switch_to_d
add wave -noupdate -radix decimal /traffic_tb/counter_out
add wave -noupdate /traffic_tb/light_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 159
configure wave -valuecolwidth 51
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {383 ns}
