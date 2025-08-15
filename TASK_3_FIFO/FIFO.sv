module fifo #(parameter WIDTH = 8, DEPTH = 8) (
    input  logic                 clk,         // Clock signal
    input  logic                 rst_n,       // Active-low asynchronous reset
    input  logic                 pop,         // Read request signal (remove data from FIFO)
    input  logic                 push,        // Write request signal (insert data into FIFO)
    input  logic [WIDTH-1:0]     write_data,  // Data to be written into FIFO
    output logic [WIDTH-1:0]     read_data,   // Data output from FIFO (First Word Fall-Through)
    output logic                 fifo_full,   // FIFO full status flag
    output logic                 fifo_empty   // FIFO empty status flag
);

// -------------------------------
// First-Word Fall-Through FIFO
// Data is available on read_data without waiting for pop
// -------------------------------

// FIFO memory buffer
logic [WIDTH-1:0] buffer [0:DEPTH-1];               // Storage array for FIFO data
logic [$clog2(DEPTH)-1:0] read_pointer, write_pointer; // Pointers for reading and writing
logic [$clog2(DEPTH):0]   count;                     // Tracks number of stored elements

// -------------------------------
// FIFO status flag assignments
// -------------------------------
assign fifo_empty = (count == 0);     // Empty when count is 0
assign fifo_full  = (count == DEPTH); // Full when count equals DEPTH
assign read_data  = buffer[read_pointer]; // Output current read pointer data (FWFT behavior)

// -------------------------------
// FIFO count update logic
// -------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 0; // Reset count to zero
    else if (push && !fifo_full && !(pop && !fifo_empty))
        count <= count + 1; // Increment count if only push occurs
    else if (pop && !fifo_empty && !(push && !fifo_full))
        count <= count - 1; // Decrement count if only pop occurs
    // When both push and pop happen simultaneously, count remains unchanged
end

// -------------------------------
// FIFO write logic
// -------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_pointer <= 0; // Reset write pointer
        // Initialize buffer contents to zero
        for (int k = 0; k < DEPTH; k++)
            buffer[k] <= 0;
    end 
    else if (push && !fifo_full) begin
        buffer[write_pointer] <= write_data; // Store input data at write pointer
        // Increment and wrap-around write pointer
        if (write_pointer == DEPTH-1)
            write_pointer <= 0;
        else
            write_pointer <= write_pointer + 1;
    end
end

// -------------------------------
// FIFO read logic
// -------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_pointer <= 0; // Reset read pointer
    end
    else if (pop && !fifo_empty) begin
        // Increment and wrap-around read pointer
        if (read_pointer == DEPTH-1)
            read_pointer <= 0;
        else
            read_pointer <= read_pointer + 1;
    end
end

endmodule
// End of FIFO module