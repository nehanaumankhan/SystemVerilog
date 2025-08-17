//stall_tb.sv
// This is the testbench for the stall module

`timescale 1ns/1ns

module stall_tb;

// SIGNALS OF THE MODULE
	logic clk;
	logic rst;
	logic stall;
	logic [7:0] A, B, C;
	logic [15:0] s1, s2, s3;
	logic [15:0] E;

// INSTANTIATION OF DUT
stall dut(
	.clk(clk),
    .rst(rst),
    .stall(stall),
    .A(A),
    .B(B),
    .C(C),
    .s1(s1),
    .s2(s2),
    .s3(s3),
    .E(E)
);

// CLOCK GENERATION
initial clk = 0;
always #5 clk = ~clk; // Time Period = 10ns

// TEST SEQUENCE
initial begin
	clk = 1; rst = 0; stall = 0; 
	#20;
	rst = 1;
	@(posedge clk);

	// TEST CASE 1: A = 21, B = 52, C = 90
	A = 21;	//My Age
	B = 52; //My mother's age
	C = 90; //My grandmother's age
	
	@(posedge clk);
	stall = 1;
	@(posedge clk);
	stall = 0;
	
	// TEST CASE 2: A = 1, B = 1, C = 1
	A = 1;
	B = 1;
	C = 1;

	@(posedge clk);

	// TEST CASE 3: A = 0, B = 0, C = 0
	A = 0;
	B = 0;
	C = 0;

	@(posedge clk);	//output of test 1 should arive; E = 2309

	// TEST CASE 4: A = 2, B = 1, C = 1
	A = 2;
	B = 1;
	C = 1;

	@(posedge clk);	//output of test 2 should arive; E = 2310
	@(posedge clk);	//output of test 3 should arive; E = 2304
	@(posedge clk);	//output of test 4 should arive; E = 2315
	@(posedge clk);
	@(posedge clk);

	$finish;
end

endmodule : stall_tb
