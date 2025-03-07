module lifo_buffer #(parameter LIFO_SIZE = 6, parameter DATA_W = 10)(
	input write,
	input wire [DATA_W - 1:0]datain,
	input wire read,
	input clock,
	input reset,
	
	output wire [DATA_W - 1:0]dataout,
	output reg val,
	output full 
);

function integer my_log2;
        input integer LIFO_SIZE;
        begin
                my_log2 = 0;
                while (LIFO_SIZE > 0) begin
                        my_log2 = my_log2 + 1;
                        LIFO_SIZE = LIFO_SIZE >> 1;   
                end
        end
endfunction

reg [DATA_W - 1:0] buffer [LIFO_SIZE - 1:0];
reg [my_log2(LIFO_SIZE) - 1:0]top;
reg [DATA_W - 1:0] dataout_reg;
wire empty;

always @(posedge clock or posedge reset) begin
	if (reset) begin
		top <= 'b0;
		val <= 'b0;
		dataout_reg <= 'b0;
	end
		if (read & ~write) begin
			dataout_reg = (empty) ? 'b0 : buffer[top - 1];
			top <= (empty) ? 'b0 : top - 1;
			val <= (empty) ? 'b0 : 'b1;
		end
		
		else if (write & ~read & ~full) begin
                	top <= top + 1;
                	buffer[top] <= datain;
                	val <= 'b1;
        	end

		else if (write & read) begin
			dataout_reg <= (empty) ? datain : buffer[top - 1];
			buffer[top - 1] <= (empty) ? buffer[top - 1] : datain;
			val <= 'b1;
		end
end

assign full = (top == (LIFO_SIZE - 1));
assign empty = (top == 0);
assign dataout = dataout_reg;

endmodule


