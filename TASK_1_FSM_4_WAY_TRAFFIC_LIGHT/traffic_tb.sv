`timescale 1ns/1ns

module traffic_tb;

    // Ports
    logic clk;
    logic rst_n;
    logic switch_to_a;
    logic switch_to_b;
    logic switch_to_c;
    logic switch_to_d;
    logic [7:0] counter_out;
    logic [4-1:0] light_en;

    // Instantiate the DUT
    traffic dut (
        .clk(clk),
        .rst_n(rst_n),
        .switch_to_a(switch_to_a),
        .switch_to_b(switch_to_b),
        .switch_to_c(switch_to_c),
        .switch_to_d(switch_to_d),
        .counter_out(counter_out),
        .light_en(light_en)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize inputs
        clk = 1;
        rst_n = 0;
        // Reset pulse
        #10
        rst_n = 1;
        #10
        //switch to b
        switch_to_b = 1;
        #30
        switch_to_b = 0;
        switch_to_d = 1;
        #50
        switch_to_d = 0;
        switch_to_c = 1;
        #90
        switch_to_c = 0;
        #40
        switch_to_a = 1;
        #200
        $finish;
    end

endmodule: traffic_tb
