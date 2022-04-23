module control (clk, rst, opcode, PCWrite, PCSrc, IorD, MemRead, MemWrite, IRWrite, ALUSrcA, ALUSrcB, ALUOp, RegDst, RegWrite);
	input clk;
	input rst;
	input [3:0] opcode;
	output reg PCWrite;
	output reg PCSrc;
	output reg IorD;
	output reg MemRead;
	output reg MemWrite;
	output reg IRWrite;
	output reg ALUSrcA;
	output reg [1:0] ALUSrcB;
	output reg [2:0] ALUOp;
	output reg RegDst;
	output reg RegWrite;
	
	parameter add = 4'b1000;
	parameter addi_se = 4'b1001;
	parameter addi_ze = 4'b1010;
	parameter sub = 4'b1100;
	parameter subi_se = 4'b1101;
	parameter subi_ze = 4'b1110;
	parameter shift = 4'b0000;
	parameter op_nand = 4'b1011;
	parameter op_nandi = 4'b0111;
	parameter op_or = 4'b1111;
	parameter op_ori = 4'b0110;
	parameter beq = 4'b0100;
	parameter bne = 4'b0101;
	parameter jump = 4'b0011;
	parameter lw = 4'b0001;
	parameter sw = 4'b0010;
	
	reg [3:0] present_state;
	reg [3:0] next_state;
	
	always @(posedge clk) begin
		if (rst)
			present_state <= 4'b0;
		else
			present_state <= next_state;
	end
	
	always @(*) begin
		case (present_state)
			4'd0: next_state = 4'd1;
			4'd1: begin
				if (opcode==jump)
					next_state = 4'd2;
				else if (opcode==beq)
					next_state = 4'd3;
				else if (opcode==bne)
					next_state = 4'd4;
				else if (opcode==add || opcode==sub || opcode==op_nand || opcode==op_or)
					next_state = 4'd5;
				else if (opcode==lw || opcode==sw)
					next_state = 4'd7;
				else
					next_state = 4'd11;
			end
			4'd2: next_state = 4'd0;
			4'd3: next_state = 4'd0;
			4'd4: next_state = 4'd0;
			4'd5: next_state = 4'd6;
			4'd6: next_state = 4'd0;
			4'd7: begin
				if (opcode==sw)
					next_state = 4'd8;
				else
					next_state = 4'd9;
			end
			4'd8: next_state = 4'd0;
			4'd9: next_state = 4'd10;
			4'd10: next_state = 4'd0;
			4'd11: next_state = 4'd12;
			4'd12: next_state = 4'd13;
			default: next_state = 4'd0;
		endcase
	end
	
	always @(*) begin
		case (present_state)
			// IF Phase
			4'd0: begin
				PCWrite = 1'b1; PCSrc = 1'b0; IorD = 1'b0;
				MemRead = 1'b1; MemWrite = 1'b0; IRWrite = 1'b1;
				ALUSrcA = 1'b0; ALUSrcB = 2'b01; ALUOp = 3'b000;
				RegDst = 1'b0; RegWrite = 1'b0;
			end
			// ID Phase
			4'd1: begin
				PCWrite = 1'b0; PCSrc = 1'b0; IorD = 1'b0;
				MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				// ALUSrcA = 1'b1; ALUSrcB = 2'b00; ALUOp = 3'b000;
				// RegDst = 1'b0; RegWrite = 1'b0;
			end
			// EX Phase for Jump
			4'd2: begin
				PCWrite = 1'b1; PCSrc = 1'b0; //IorD = 1'b0;
				//MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				ALUSrcA = 1'b0; ALUSrcB = 2'b10; ALUOp = 3'b000;
				//RegDst = 1'b0; RegWrite = 1'b0;
			end
			// EX Phase for BEQ
			4'd3: begin
				PCWrite = 1'b1; PCSrc = 1'b1; //IorD = 1'b0;
				//MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				ALUSrcA = 1'b1; ALUSrcB = 2'b00; ALUOp = 3'b001;
				//RegDst = 1'b0; RegWrite = 1'b0;
			end
			// EX Phase for BNE
			4'd4: begin
				PCWrite = 1'b1; PCSrc = 1'b1; //IorD = 1'b0;
				//MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				ALUSrcA = 1'b1; ALUSrcB = 2'b00; ALUOp = 3'b001;
				//RegDst = 1'b0; RegWrite = 1'b0;
			end
			// EX Phase for R-Type instructions
			4'd5: begin
				// PCWrite = 1'b0; PCSrc = 1'b0; IorD = 1'b0;
				// MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				ALUSrcA = 1'b1; ALUSrcB = 2'b00; 
				if (opcode==add) ALUOp = 3'b000;
				else if (opcode==sub) ALUOp = 3'b001;
				else if (opcode==op_nand) ALUOp = 3'b010;
				else ALUOp = 3'b011;
				// RegDst = 1'b0; RegWrite = 1'b0;
			end
			// MEM Phase for R-Type instructions
			4'd6: begin
				// PCWrite = 1'b0; PCSrc = 1'b0; IorD = 1'b0;
				// MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				// ALUSrcA = 1'b1; ALUSrcB = 2'b00; ALUOp = 3'b000;
				RegDst = 1'b0; RegWrite = 1'b1;
			end
			// EX Phase for lw and sw
			4'd7: begin
				// PCWrite = 1'b0; PCSrc = 1'b0; IorD = 1'b0;
				// MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				ALUSrcA = 1'b1; ALUSrcB = 2'b11; ALUOp = 3'b000;
				// RegDst = 1'b0; RegWrite = 1'b0;
			end
			// MEM Phase for sw
			4'd8: begin
				MemWrite = 1'b1;
				IorD = 1'b1;
			end
			// MEM Phase for lw
			4'd9: begin
				MemRead = 1'b1;
				IorD = 1'b1;
			end
			// WB Phase for lw
			4'd10: begin
				// PCWrite = 1'b0; PCSrc = 1'b0; 
				IorD = 1'b0;
				MemRead = 1'b0; MemWrite = 1'b0; //IRWrite = 1'b0;
				// ALUSrcA = 1'b1; ALUSrcB = 2'b00; ALUOp = 3'b000;
				RegDst = 1'b1; RegWrite = 1'b1;
			end
			// EX Phase for I-Type instructions
			4'd11: begin
				// PCWrite = 1'b0; PCSrc = 1'b0; IorD = 1'b0;
				// MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				ALUSrcA = 1'b1; ALUSrcB = 2'b10; 
				if (opcode==addi_se || opcode==addi_ze) ALUOp = 3'b000;
				else if (opcode==subi_se || opcode==subi_ze) ALUOp = 3'b001;
				else if (opcode==op_nandi) ALUOp = 3'b010;
				else if (opcode==op_ori) ALUOp = 3'b011;
				else ALUOp = 3'b100;
				// RegDst = 1'b0; RegWrite = 1'b0;
			end
			// MEM Phase for I-Type instructions
			4'd12: begin
				// PCWrite = 1'b0; PCSrc = 1'b0; IorD = 1'b0;
				// MemRead = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
				// ALUSrcA = 1'b1; ALUSrcB = 2'b00; ALUOp = 3'b000;
				RegDst = 1'b0; RegWrite = 1'b1;
			end
			default: begin
				PCWrite = 1'b1; PCSrc = 1'b0; IorD = 1'b0;
				MemRead = 1'b1; MemWrite = 1'b0; IRWrite = 1'b1;
				ALUSrcA = 1'b0; ALUSrcB = 2'b01; ALUOp = 3'b000;
				RegDst = 1'b0; RegWrite = 1'b0;
			end
		endcase
	end
endmodule