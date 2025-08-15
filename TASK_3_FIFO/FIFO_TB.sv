`timescale 1ns/1ns   // Time unit = 1 ns, Time precision = 1 ns

module fifo_tb;

// -----------------------------------------
// DUT (Device Under Test) signal declarations
// -----------------------------------------
logic clk;                   // Clock signal
logic rst_n;                  // Active-low asynchronous reset
logic push, pop;              // Push (write) and Pop (read) control signals
logic [7:0] write_data;       // Data to be pushed into FIFO
logic [7:0] read_data;        // Data read from FIFO
logic fifo_full, fifo_empty;  // FIFO status flags

// -----------------------------------------
// Instantiate the DUT (FIFO module)
// Parameters: WIDTH = 8 bits, DEPTH = 8 entries
// -----------------------------------------
fifo #(.WIDTH(8), .DEPTH(8)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .pop(pop),
    .push(push),
    .write_data(write_data),
    .read_data(read_data),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty)
);

// -----------------------------------------
// Clock generation: Period = 10 ns (100 MHz)
// Toggle clock every 5 ns
// -----------------------------------------
initial clk = 0;
always #5 clk = ~clk;

// -----------------------------------------
// Test sequence
// -----------------------------------------
initial begin
    // Initial values before simulation starts
    rst_n      = 0;         // Keep reset active
    push       = 0;         // No push operation yet
    pop        = 0;         // No pop operation yet
    write_data = 8'h00;     // Initial write data = 0x00

    // ------------------------
    // Reset sequence
    // ------------------------
    #12;                    // Wait for some time before releasing reset
    rst_n = 1;               // Deassert reset, FIFO ready for operations

    // ------------------------
    // Push 3 values into FIFO
    // ------------------------
    @(posedge clk); push = 1; write_data = 8'h01;  // Push first value (0x01)
    @(posedge clk); write_data = 8'h02;            // Push second value (0x02)
    @(posedge clk); write_data = 8'h03;            // Push third value (0x03)
    @(posedge clk); push = 0;                      // Stop pushing

    // ------------------------
    // Pop 2 values from FIFO
    // ------------------------
    @(posedge clk); pop = 1;   // Start popping (first read)
    @(posedge clk);            // Second read
    @(posedge clk); pop = 0;   // Stop popping

    // ------------------------
    // Push more values into FIFO
    // ------------------------
    @(posedge clk); push = 1; write_data = 8'h04;  // Push 0x04
    @(posedge clk); write_data = 8'h05;            // Push 0x05
    @(posedge clk); push = 0;                      // Stop pushing

    // ------------------------
    // Pop remaining values until FIFO is empty
    // ------------------------
    @(posedge clk); pop = 1;                       // Start popping
    repeat (5) @(posedge clk);                     // Pop 5 cycles
    pop = 0;                                       // Stop popping

    // ------------------------
    // End of simulation
    // ------------------------
    #20;       // Wait before finishing
    $finish;   // Terminate simulation
end

endmodule
// End of fifo_tb module
// This testbench simulates a FIFO with 8-bit data width and 8 entries.