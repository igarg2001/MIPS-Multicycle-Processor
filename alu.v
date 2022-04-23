module alu (inA, inB, ALUOp, ALUOut, Zero);
	input [15:0] inA;
	input [15:0] inB;
	input [2:0] ALUOp;
	output reg [15:0] ALUOut;
	output reg Zero;
	
	reg [3:0] shift_amt;
	reg [3:0] func_field;
	reg [15:0] temp;
	reg [3:0] i;
	
	always @(*) begin
		func_field = inB[3:0];
		shift_amt = inB[7:4];
		i = 4'b0000;
		case (ALUOp)
			3'b000: ALUOut = inA + inB; // Addition
			3'b001: ALUOut = inA - inB; // Subtraction
			3'b010: ALUOut = ~(inA & inB); // Nand Operation
			3'b011: ALUOut = inA | inB; // Or Operation
			3'b100: begin // Shifting Operations
				temp = inA;
				case (func_field)
					4'b0001: begin
						for (i=0; i<shift_amt; i=i+1)
							temp = {temp[14:0], 1'b0};
					end
					4'b0010: begin
						for (i=0; i<shift_amt; i=i+1)
							temp = {1'b0, temp[15:1]};
					end
					4'b0011: begin
						for (i=0; i<shift_amt; i=i+1)
							temp = {temp[15], temp[15:1]};
					end
				endcase
			end
			default: ALUOut = 16'bz;
		endcase
		
		if (inA==inB) Zero = 1'b1;
		else Zero = 1'b0;
	end
endmodule