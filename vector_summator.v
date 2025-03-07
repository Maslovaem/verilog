module vector_summator #(parameter DATA_W = 10, parameter POS_W = my_log2(DATA_W))(
	input wire [DATA_W - 1:0]data,
	output wire [POS_W - 1:0]sum
);

function integer my_log2;
	input integer DATA_W;
	begin
		my_log2 = 0;
		while (DATA_W > 0) begin
			my_log2 = my_log2 + 1;
			DATA_W = DATA_W >> 1;	
		end
	end
endfunction

integer i;
reg [POS_W - 1:0]temp_reg;

always @(*) begin
	temp_reg = 'b0;
	for (i = 0; i < DATA_W; i = i + 1) begin
		temp_reg = temp_reg + data[i];
	end	
end

assign sum = temp_reg;

endmodule
