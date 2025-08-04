// `timescale 1ns/1ns

// module equation_tb;
// //SIGNALS OF THE MODULE
// 	logic clk;
// 	logic rst;
// 	logic [7:0] A, B, C;
// 	logic [15:0] E;

// //INSTANTIATION OF DUT
// equation dut(
// 	.clk(clk),
//     .rst(rst),
//     .A(A),
//     .B(B),
//     .C(C),
//     .E(E)
// );

// //CLOCK GENERATION
// initial clk = 0;
// always #5 clk = ~clk; //Time Period = 10ns; Assuming the critical path < 10ns

// //TEST SEQUENCE
// initial begin
// 	clk = 1;
// 	rst = 0;
// 	#20;
// 	rst = 1;

// 	//TEST CASE 1:
// 	A = 21; //My Age
// 	B = 52; //My mother's age
// 	C = 90; //My grandmother's age
// 	#10
// 	//TEST CASE 2:
// 	A = 1;
// 	B = 1;
// 	C = 1;
// 	#10
// 	//TEST CASE 3
// 	A = 0;
// 	B = 0;
// 	C = 0;
// 	#10
// 	//TEST CASE 4
// 	A = 2;
// 	B = 1;
// 	C = 1;
// 	#50

// 	$finish;

// end
// endmodule : equation_tb

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
	clk = 1;
	rst = 0;
	stall = 0;
	A = 0; B = 0; C = 0;
	#20;
	rst = 1;

	// TEST CASE 1: A = 21, B = 52, C = 90
	A = 21;
	B = 52;
	C = 90;
	#20; // Wait 4 clocks (40ns) for output E to stabilize
	stall = 1;
	#40;
	stall = 0;
	// TEST CASE 2: A = 1, B = 1, C = 1
	A = 1;
	B = 1;
	C = 1;
	#20; // Wait 4 clocks

	// TEST CASE 3: A = 0, B = 0, C = 0
	A = 0;
	B = 0;
	C = 0;
	#20; // Wait 4 clocks

	// TEST CASE 4: A = 2, B = 1, C = 1
	A = 2;
	B = 1;
	C = 1;
	#200; // Wait 4 clocks

	$finish;
end

endmodule : stall_tb
