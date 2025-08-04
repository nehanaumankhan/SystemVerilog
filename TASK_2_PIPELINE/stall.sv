//I have followed Method 1 for this RTL; E = 5A+5B-4C+5D
//Comments have been added by ChatGpt

module stall (
    input logic clk,
    input logic rst,
    input logic stall,
    input logic [7:0] A, B, C,
    //Adding outputs at each stage for debugging
    output logic [15:0] s1, s2, s3, 
    output logic [15:0] E
);
    logic [9:0] D = 10'b1100000000;//768

    // Stage registers with corrected bit widths
    logic [36:0] s1_reg; // 11 (5A) + 8 (B) + 8 (C) + 10 (D)
    logic [29:0] s2_reg; // 12 (5A+5B) + 8 (C) + 10 (D)
    logic [20:0] s3_reg; // 11 (5A+5B−4C) + 10 (D)

    // Internal signals
    logic [15:0] x, y, z;


    // Stage 1
    always_ff @(posedge clk or negedge rst) begin
        if (~rst) begin
            s1_reg <= 37'b0;
        end
        else begin
            if (~stall) begin
                x = (A << 2) + A;              // 5A
                s1_reg[36:26] <= x;            // 5A (11 bits)
                s1_reg[25:18] <= B;            // B
                s1_reg[17:10] <= C;            // C
                s1_reg[9:0]   <= D;            // D
            end            
        end
    end

    // Stage 2
    always_ff @(posedge clk or negedge rst) begin
        if (~rst) begin
            s2_reg <= 30'b0;
        end
        else begin
            if(~stall) begin
                y = (s1_reg[25:18] << 2) + s1_reg[25:18]; // 5B
                s2_reg[29:18] <= s1_reg[36:26] + y;       // 5A + 5B
                s2_reg[17:10] <= s1_reg[17:10];           // C
                s2_reg[9:0]   <= s1_reg[9:0];             // D    
            end
        end
    end

    // Stage 3
    always_ff @(posedge clk or negedge rst) begin
        if (~rst) begin
            s3_reg <= 30'b0;
        end
        else begin
            if (~stall) begin
               z = s2_reg[17:10] << 2;                   // 4C
                s3_reg[20:10] <= s2_reg[29:18] - z;       // 5A + 5B - 4C
                s3_reg[9:0]   <= s2_reg[9:0];             // D 
            end
        end
    end

    
    // Final combinational stage
    assign E = s3_reg[20:10] + ((s3_reg[9:0] << 1) + s3_reg[9:0]); // +3D

    //Stages output
    always_comb begin
        s1 <= s1_reg[36:26];
        s2 <= s2_reg[29:18]; 
        s3 <= s3_reg[20:10];
     end 
endmodule: stall

