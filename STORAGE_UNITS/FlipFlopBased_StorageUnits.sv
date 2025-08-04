module storage #(parameter WIDTH = 1024, DEPTH = 512) (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	
	//READING SIGNALS
	input logic rd_en,
	input logic [$clog2(DEPTH)-1:0] rd_addrs, //non-synthesizable costruct; will be resolved in compilation
	output logic [WIDTH-1:0] rd_data,

	//WRITING SIGNALS
	input logic wr_en,
	input logic [$clog2(DEPTH)-1:0] wr_addrs, //non-synthesizable costruct; will be resolved in compilation
	input logic [WIDTH-1:0] wr_data
	);

logic [DEPTH-1:0][WIDTH-1:0] storage;

//WRITNG IN TO STORAGE
generate
	for (genvar i = 0; i < DEPTH; i++) begin
		//We write any procesdural block in the loop's body
		always_ff @(posedge clk or negedge rst_n) begin 
		 	if(~rst_n) begin
		 		storage[i] <= '0;
		 	end 
		 	else if((wr_addrs == i) && (wr_en)) begin
					storage[i] <= wr_data;
				end
		 	end
		end 	
endgenerate

//READING FROM STORAGE 
always_comb begin //reading logic is combinational
	for (int i = 0; i < DEPTH; i++) begin //This for loop will not replicate in hardware 
		if((i == rd_addrs) && rd_en) begin
			rd_data = storage[i];
		end
	end

end 
endmodule : storage