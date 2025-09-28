`timescale 1ns/1ns

module ByPass_FIFO_tb;
	// Parameter
	localparam int DEPTH = 4;
    localparam int WIDTH = 4;

	// DUT signals
	logic 							clk;
	logic 							rst;
	logic							write_en;
	logic [WIDTH-1:0]  		        data_in;
	logic [WIDTH*DEPTH-1:0]	        data_out;

	// DUT instance
	beat_shift_register #(
		.DEPTH(DEPTH),
        .WIDTH(WIDTH)
	) dut (
		.clk       	(clk),
		.rst       	(rst),
		.write_en	(write_en),
		.data_out 	(data_out),
		.data_in	(data_in)
	 );

	// -------------------------------
    // Clock generation (10 ns period)
    // -------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // -------------------------------
    // Stimulus
    // -------------------------------
	initial begin
		// Initialize
    	rst = 0; write_en = 0; data_in = 0; 
		@(posedge clk);	    // Hold reset for 1 cycles
	    rst = 1; write_en = 1; data_in = 1;
	    @(posedge clk); data_in = 2; 
	    @(posedge clk); data_in = 3; 
	    @(posedge clk); data_in = 4; 
	    @(posedge clk); data_in = 5;
	    @(posedge clk); data_in = 6;
	    @(posedge clk); data_in = 7;
	    @(posedge clk); data_in = 8;
	    @(posedge clk); 
	    write_en = 0;
	    @(posedge clk);
	    @(posedge clk);
	    @(posedge clk);
		$stop;
	end

endmodule : ByPass_FIFO_tb