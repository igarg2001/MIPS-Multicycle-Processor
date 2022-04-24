module processor (
    cont_out, ALUOut_out, regA_out, regB_out, regC_out, PC_out, instr_out, rst, clk, PC_rst
);
output [15:0] ALUOut_out, regA_out, regB_out, regC_out, PC_out, instr_out;
output [13:0] cont_out;
input clk, rst, PC_rst;
wire [15:0] instruction, data;
wire [15:0] output_from_PC, reg_in, input_to_mem, output_from_ALUOut, input_to_write_data, input_to_regA, input_to_regB, input_to_regC, output_from_ALU, input_to_ALUSrcA, input_to_ALUSrcB;
wire [15:0] extended_imm_data;
wire [15:0] input_to_PC_from_ALU;
wire[3:0]  input_to_read_reg1, input_to_read_reg3, input_to_write_reg;
wire IorD, MemRead, MemWrite, IRWrite, RegDst, RegWrite, ALUSrcA, PCSrc, PCWrite;
wire ALUZero;
wire PCControl;
wire [1:0] ALUSrcB;
wire [2:0] ALUOp;
wire[1:0] MUX_Control_To_Read_Reg1;
wire[3:0] opcode;
wire [1:0] select_to_imm_data;

reg[15:0] IR, MDR, reg_A, reg_B, reg_C, ALUOut;

// initial begin
// 	#5; $display("-----------------rst = %b, clk = %b PC_rst = %b------------------\n", rst, clk, PC_rst);
// end


always @(negedge clk) begin
    if(IRWrite==1'b1) begin
         IR <= instruction;
    end
    MDR <= data;
    ALUOut <= output_from_ALU;
    reg_A <= input_to_regA;
    reg_B <= input_to_regB;
    reg_C <= input_to_regC;
end



// mux_2x1 module1 (input_to_mem, IorD, output_from_PC, output_from_ALUOut);
// ID_Mem module2 (instruction, reg_C ,input_to_mem, MemRead, MemWrite, IorD, clk);
IM module2 (instruction, output_from_PC, MemRead, clk);
DM module15 (data, input_to_regC, output_from_ALU, MemWrite, MemRead, clk);

assign MUX_Control_To_Read_Reg1 = (IR[15:12]==4'b0000 || IR[15:12]==4'b1001 || IR[15:12]==4'b1010 || IR[15:12]==4'b1101 || IR[15:12]==4'b1110 || IR[15:12]==4'b0110 || IR[15:12]==4'b0111 || IR[15:12]==4'b0011) ? 2'b00 : 
                                  (IR[15:12]==4'b0001 || IR[15:12]==4'b0010) ? 2'b01 : 2'b10;
mux_3x1 module3 (input_to_read_reg1, MUX_Control_To_Read_Reg1, IR[11:8], IR[9:8], IR[7:4]);
mux_2x1_type1 module4 (input_to_read_reg3, ~IR[14], IR[11:8], IR[11:10]);
mux_2x1_type1 module5 (input_to_write_reg, RegDst, IR[11:8], IR[11:10]);
mux_2x1 module6 (input_to_write_data, RegDst, ALUOut, MDR);
reg_file module7 (input_to_regA, input_to_regB, input_to_regC, input_to_read_reg1, IR[3:0], input_to_read_reg3, input_to_write_reg, input_to_write_data, RegWrite, clk);
mux_2x1 module8 (input_to_ALUSrcA, ALUSrcA, output_from_PC, reg_A);
assign select_to_imm_data = ((IR[15:12] == 4'b1010) || (IR[15:12]==4'b1110)) ? 2'b00 : (IR[15:12]==4'b0011 ? 2'b10 : 2'b01);
imm_data_extend module9 (extended_imm_data, select_to_imm_data ,IR[7:0], IR[7:0], IR[11:0]);
mux_4x1 module10 (input_to_ALUSrcB, ALUSrcB, reg_B, extended_imm_data, extended_imm_data);
alu module11 (input_to_ALUSrcA, input_to_ALUSrcB, ALUOp, output_from_ALU, ALUZero);
mux_2x1 module12 (input_to_PC_from_ALU, PCSrc, output_from_ALU, reg_C);
// PC module13 (output_from_PC, input_to_PC_from_ALU, )
assign PCControl = (IR[15:12] == 4'b0100) ? PCWrite & ALUZero : 
                   (IR[15:12] == 4'b0101) ? PCWrite & ~ALUZero :
                   PCWrite;
PC module13 (output_from_PC, input_to_PC_from_ALU, PCControl, clk, PC_rst);
control module14 (clk, rst, IR[15:12], PCWrite, PCSrc, IorD, MemRead, MemWrite, IRWrite, ALUSrcA, ALUSrcB, ALUOp, RegDst, RegWrite);

assign cont_out = {PCWrite, PCSrc, IorD, MemRead, MemWrite, IRWrite, ALUSrcA, ALUSrcB, ALUOp, RegDst,RegWrite};
assign ALUOut_out = ALUOut;
assign instr_out = IR;
assign PC_out = output_from_PC;
assign regA_out = reg_A;
assign regB_out = reg_B;
assign regC_out = reg_C;

endmodule


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
if (opcode==4'b0000 || opcode==4'b1001 || opcode==4'b1010 || opcode==4'b1101 || opcode==4'b1110 || opcode==4'b0110 || opcode==4'b0111 || opcode==4'b0011)
	s = 2'b00;
else if (opcode==4'b0001 || opcode==4'b0010)
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

// module ID_Mem (d_out, d_in, address, R_en, W_en, IorD, clk);

// output reg [15:0] d_out;
// input [15:0] address, d_in;
// input R_en, W_en, IorD, clk;
// reg [7:0] mem [0:64*1024-1];

// initial
// // 	#5; $display("---------------Value of IorD = %b", IorD);
// // 	if(IorD)
// //     	$readmemh("data_mem.dat", mem); // IorD=1 means Data address from ALUOut
// // 	if(~IorD) begin
// // 		#5; $display("---------------------------Reading from instr_mem.dat-------------------------------\n");
// // 		$readmemh("instr_mem.dat", mem); // IorD=0 means Instruction address obtd from PC
// // end
// $readmemh("instr_mem.dat", mem);
		

// always @(negedge clk)
// begin
// 	if(R_en)
// 		d_out <= {mem[address+1],mem[address]};
// 	else
// 		d_out <= 16'bz;
//     if(W_en)
// 	begin
// 		{mem[address+1], mem[address]} <= d_in;
// 		$writememh("data_mem.dat", mem);
// 	end
// end
// endmodule
module IM (dout, address, ren, clk);

output reg [15:0] dout;
input [15:0] address;
input ren, clk;
reg [7:0] mem [0:64*1024-1];

 
initial
	$readmemh("instr_mem.dat", mem);
 
always @(negedge clk)
begin
	if(ren)
		dout <= {mem[address+1],mem[address]};
end

endmodule

module DM (dout, din, address, wen, ren, clk);

output reg [15:0] dout;
input [15:0] address, din;
input wen, ren, clk;
reg [7:0] mem [0:64*1024-1];

 
initial
	$readmemh("data_mem.dat", mem);
 
always @(negedge clk)
begin
	if(wen) begin
		{mem[address+1], mem[address]} <= din;
        $writememh("data_mem.dat", mem);
    end
	if(ren) begin
		dout <= {mem[address+1],mem[address]};
	end
	else begin
		dout <= 8'bz;
	end
end

endmodule
module reg_file (rd1, rd2, rd3, read1, read2, read3, rwr, dwr, wen, clk);

output reg [15:0] rd1, rd2, rd3;
input [3:0] read1, read2, read3;
input [3:0] rwr;
input [15:0] dwr;
input wen, clk;

reg [15:0] register [0:15];

initial 
    $readmemh("registers.dat", register);

always @(negedge clk) begin
	// #1;
    rd1 <= register[read1];
    rd2 <= register[read2];
    rd3 <= register[read3];
    if(wen)
        register[rwr] = dwr;
end
always @(negedge clk) begin
    if(wen)
        register[rwr] = dwr;
end

endmodule
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
				ALUOut = temp;
			end
			default: ALUOut = 16'bz;
		endcase
		
		if (inA==inB) Zero = 1'b1;
		else Zero = 1'b0;
	end
endmodule
module PC (PC_out, address, PC_Write, clk, reset);

output reg [15:0] PC_out;
input [15:0] address;
input PC_Write, clk, reset;

always @(negedge clk or reset)
begin
    if(reset)
        PC_out <= 16'h0000;
    if(PC_Write)
        PC_out <= address;
end

endmodule

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

module tb_processor;

wire [15:0] PC_out, regA_out, regB_out, regC_out, ALUOut_out, instr_out; //check
wire [13:0] cont_out; //check
reg clk, rst, PC_rst;

processor first_insta (
     .cont_out(cont_out), .ALUOut_out(ALUOut_out), .regA_out(regA_out), .regB_out(regB_out), .regC_out(regC_out), .PC_out(PC_out), .instr_out(instr_out), .rst(rst), .clk(clk), .PC_rst(PC_rst)
);


initial
begin
	PC_rst = 1'b1;
	#2 PC_rst = 1'b0;
end


initial
begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial
begin
	rst = 1'b1;
	#6 rst = 1'b0;
end

initial
begin
	//1

    $display("-----------------------------------------------------------");
	$display("Addition: register addressing: RD = RS1 + RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //2

    $display("-----------------------------------------------------------");
	$display("Addition: immediate addressing: RD = RD + Sign-Extended-Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //3

    $display("-----------------------------------------------------------");
	$display("Addition: immediate addressing: RD = RD + Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //4

    $display("-----------------------------------------------------------");
	$display("Subtraction: register addressing: RD = RS1 - RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //5

    $display("-----------------------------------------------------------");
	$display("Subtraction: immediate addressing:RD = RD - Sign-Extended-Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //6

    $display("-----------------------------------------------------------");
	$display("Subtraction: immediate addressing: RD = RD - Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //7

$display("-----------------------------------------------------------");
	$display("Shift: Left Logical: RD = shift logical left");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //8

    $display("-----------------------------------------------------------");
	$display("Shift: Right Logical:RD = shift logical right");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //9

$display("-----------------------------------------------------------");
	$display("Shift: Right Arithmetic: RD = shift right");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //10
    $display("-----------------------------------------------------------");
    $display("-----------------------------------------------------------");
	$display("NAND: register addressing: RD = RS1 nand RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
	$display("-----------------------------------------------------------");
	$display("OR: register addressing: RD = RS1 or RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //17
    $display("-----------------------------------------------------------");
	$display("NAND: immediate addressing: RD = RD nand (sign extended immediate data)");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //18
    $display("-----------------------------------------------------------");
	$display("OR: immediate addressing: RD = RD or (sign extended immediate data)");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
	 $display("-----------------------------------------------------------");
	$display("Store");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //12
    $display("-----------------------------------------------------------");
	$display("Load");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 5\tCycle Name: WB\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
	$display("Jump: Jump to PC + sign extended immediate data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //11
    //13
    $display("-----------------------------------------------------------");
	$display("Branch Equal: branch to the address in register RT when RA and RB are equal");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------");
    //14
    $display("-----------------------------------------------------------");
	$display("Branch not Equal: branch to the address in register RT when RA and RB are unequal");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	// #10 $display("-----------------------------------------------------------
	#1 $finish;
end

endmodule
