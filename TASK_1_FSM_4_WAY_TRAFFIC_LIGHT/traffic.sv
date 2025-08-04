module traffic (
    input clk,
    input rst_n,

    input logic switch_to_a,
    input logic switch_to_b,
    input logic switch_to_c,
    input logic switch_to_d,
    output logic [7:0] counter_out,
    output logic [3:0] light_en
);

// State encoding
localparam STATE_A = 2'd0;
localparam STATE_B = 2'd1;
localparam STATE_C = 2'd2;
localparam STATE_D = 2'd3;

// State and counter registers
logic [1:0] current_state, next_state;
logic [7:0] counter;

// Time for each state
localparam time_a = 8'd2, time_b = 8'd4, time_c = 8'd6, time_d = 8'd8;

// Next State Logic
always_comb begin
    next_state = current_state;
    case (current_state)
        STATE_A: if (counter >= (time_a-1)) begin
            if (switch_to_b) next_state = STATE_B;
            else if (switch_to_c) next_state = STATE_C;
            else if (switch_to_d) next_state = STATE_D;
        end
        STATE_B: if (counter >= (time_b-1)) begin
            if (switch_to_a) next_state = STATE_A;
            else if (switch_to_c) next_state = STATE_C;
            else if (switch_to_d) next_state = STATE_D;
        end
        STATE_C: if (counter >= (time_c-1)) begin
            if (switch_to_a) next_state = STATE_A;
            else if (switch_to_b) next_state = STATE_B;
            else if (switch_to_d) next_state = STATE_D;
        end
        STATE_D: if (counter >= (time_d-1)) begin
            if (switch_to_a) next_state = STATE_A;
            else if (switch_to_b) next_state = STATE_B;
            else if (switch_to_c) next_state = STATE_C;
        end
    endcase
end

// Counter logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 8'd0;
    else if (next_state != current_state) //counter will get initialized to zero if i have make transition to some other state
        counter <= 8'd0;
    else
        counter <= counter + 1;
end

// State register update
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= STATE_A;
    else
        current_state <= next_state;
end

// Output logic
always_comb begin
    counter_out = counter;
    case (current_state)
        STATE_A: light_en = 4'b1000;
        STATE_B: light_en = 4'b0100;
        STATE_C: light_en = 4'b0010;
        STATE_D: light_en = 4'b0001;
        default: light_en = 4'b0000;
    endcase
end

endmodule
