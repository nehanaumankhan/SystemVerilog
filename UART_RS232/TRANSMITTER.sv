module Transmitter #(
    parameter integer DATA_BITS = 8,
    parameter integer CLK_FREQ = 50, // Hz
    parameter integer BAUD_RATE = 10,
    parameter integer BAUD_RATE_DIV = CLK_FREQ / BAUD_RATE
)(
    input logic clk,
    input logic reset,
    input logic [DATA_BITS-1:0] tx_data_in,
    input logic tx_start,
    output logic tx_done,
    output logic tx_serial_out
);
    // State definitions
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    // State variables
    state_t current_state, next_state;

    // Internal signals
    logic [DATA_BITS-1:0] data_buffer;
    logic [$clog2(DATA_BITS):0] bit_count;
    logic [$clog2(BAUD_RATE_DIV):0] baud_counter;
    logic baud_tick;

    // Baud rate tick generator
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            baud_counter <= 0;
        else if (current_state == IDLE)
            baud_counter <= 0;
        else if (baud_counter == BAUD_RATE_DIV - 1)
            baud_counter <= 0;
        else
            baud_counter <= baud_counter + 1;
    end

    assign baud_tick = (baud_counter == BAUD_RATE_DIV - 1);

    // State machine
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            tx_serial_out <= 1; // Idle line high
            tx_done <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    tx_done <= 0;
                    if (tx_start) begin
                        data_buffer <= tx_data_in;
                        current_state <= START;
                    end
                end

                START: if (baud_tick) begin
                    tx_serial_out <= 0; // Start bit
                    bit_count <= 0;
                    current_state <= DATA;
                end

                DATA: if (baud_tick) begin
                    tx_serial_out <= data_buffer[bit_count];
                    if (bit_count == DATA_BITS - 1)
                        current_state <= STOP;
                    else
                        bit_count <= bit_count + 1;
                end

                STOP: if (baud_tick) begin
                    tx_serial_out <= 1; // Stop bit
                    tx_done <= 1;
                    current_state <= IDLE;
                end

                default: current_state <= IDLE;
            endcase
        end
    end

endmodule
