/* This mux is used at:
1. Mux with select line IorD
2. Mux with select line RegDst (which selects the Write Data in the Reg file)
3. Mux with select line ALUSrcA
4. Mux with select line PCSrc
*/
module mux_2x1 (y, s, d0, d1);
	input [15:0] d0;
	input [15:0] d1;
	input s;
	output reg [15:0] y;
	
	always @(*) begin
		case (s)
			1'b0: y = d0;
			1'b1: y = d1;
		endcase
	end
endmodule

//********************************************************************************

/* This mux is used at:
1. Mux with select line ~instruction[14] (to select Read register 3)
2. Mux with select line RegDst (to select Write register)
*/
module mux_2x1_type1 (y, s, d0, d1);
	input [3:0] d0;
	input [1:0] d1;
	input s;
	output reg [3:0] y;
	
	always @(*) begin
		case (s)
			1'b0: y = d0;
			1'b1: y = {2'b11, d1};
		endcase
	end
endmodule

//********************************************************************************

// This mux is used at the Mux with select line xx (to select Read register 1)
module mux_3x1 (y, s, d0, d1, d2);
	input [3:0] d0;
	input [1:0] d1;
	input [3:0] d2;
	input [1:0]s;
	output reg [3:0] y;
	
	always @(*) begin
		case (s)
			2'b00: y = d0;
			2'b01: y = {2'b10, d1};
			2'b10: y = d2;
		endcase
	end
endmodule
/* For Select line of this mux:
if (opcode==0000 || opcode==1001 || opcode==1010 || opcode==1101 || opcode==1110 || opcode==0110 || opcode==0111 || opcode==0011)
	s = 2'b00;
else if (opcode==0001 || opcode==0010)
	s = 2'b01;
else 
	s = 2'b10;
*/

//*******************************************************************************

// This mux is used at the datapath where data extension and selection is needed
module imm_data_extend (y, s, d0, d1, d2);
	input [7:0] d0;
	input [7:0] d1;
	input [11:0] d2;
	input [1:0]s;
	output reg [15:0] y;
	
	always @(*) begin
		case (s)
			2'b00: y = {8'b0, d0}; // Zero extend
			2'b01: y = {{8{d1[7]}}, d1}; // Sign extend the 8-bit data
			2'b10: y = {{4{d1[11]}}, d2}; // Sign extend the 12-bit data (Jump Instruction)
		endcase
	end
endmodule
/* For Select line of this mux:
if (opcode==1010 || opcode==1110)
	s = 2'b00;
else if (opcode==0011)
	s = 2'b10;
else 
	s = 2'b01;
*/

//********************************************************************************

// This mux is used at the Mux with select line ALUSrcB

module mux_4x1 (y, s, d0, d1, d2);
	input [15:0] d0;
	input [15:0] d1;
	input [15:0] d2;
	input [1:0] s;
	output reg [15:0] y;
	
	always @(*) begin
		case (s)
			2'b00: y = d0; // For R-type instructions
			2'b01: y = 16'd2; // For PC increment
			2'b10: y = d1; // For I-type instructions
			2'b11: y = {d2[14:0], 1'b0}; // For lw/sw instructions (Left-shifted)
		endcase
	end
endmodule