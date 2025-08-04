//======================================================
// Flip-Flop Based Storage Unit - RTL Reference Model
// This is a synthesizable behavioral model of memory
// typically used in RTL design flow to simulate the 
// behavior of actual ASIC memory macros (SRAM, etc.).
//======================================================

module storage_unit #(
    parameter WIDTH = 8,   // Width of each memory word
    parameter DEPTH = 16   // Number of memory locations
)(
    input  logic                 clk,        // Clock signal
    input  logic                 rst_n,      // Active-low reset
    input  logic [$clog2(DEPTH)-1:0] addr,   // Address bus
    input  logic [WIDTH-1:0]     data_in,    // Data to be written
    input  logic                 write_en,   // Write enable
    input  logic                 read_en,    // Read enable
    output logic [WIDTH-1:0]     data_out    // Data being read
);

    // Memory array implemented using flip-flops
    logic [WIDTH-1:0] mem [DEPTH-1:0];

    // Synchronous Write Operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory to 0 on reset (optional)
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= '0;
            end
        end
        else if (write_en) begin
            // Write data to specified address
            mem[addr] <= data_in;
        end
    end

    // Synchronous Read Operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= '0;
        end
        else if (read_en) begin
            // Read data from specified address
            data_out <= mem[addr];
        end
    end

endmodule
