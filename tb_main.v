module tb_custom_mup;

wire [15:0] PC_out, regA_out, regB_out, regC_out, ALUOut_out, instr_out; //check
wire [13:0] cont_out; //check
reg clk, rst, PC_rst;

// custom_MuP first_insta (.cont_out(cont_out),.PC_out(PC_out), .regA_out(regA_out), .regB_out(regB_out), .regC_out(regC_out), .ALUOut_out(ALUOut_out), .instr_out(instr_out), .out_memory(out_memory), .rst(rst), .clk(clk), .PC_rst(PC_rst));
processor first_insta (
     .cont_out(cont_out), .ALUOut_out(ALUOut_out), .regA_out(regA_out), .regB_out(regB_out), .regC_out(regC_out), .PC_out(PC_out), .instr_out(instr_out), .rst(rst), .clk(clk), .PC_rst(PC_rst)
);

initial
begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial
begin
	PC_rst = 1'b1;
	#2 PC_rst = 1'b0;
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
	#14 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //2

    $display("-----------------------------------------------------------");
	$display("Addition: immediate addressing: RD = RD + Sign-Extended-Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //3

    $display("-----------------------------------------------------------");
	$display("Addition: immediate addressing: RD = RD + Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //4

    $display("-----------------------------------------------------------");
	$display("Subtraction: register addressing: RD = RS1 - RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //5

    $display("-----------------------------------------------------------");
	$display("Subtraction: immediate addressing:RD = RD - Sign-Extended-Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //6

    $display("-----------------------------------------------------------");
	$display("Subtraction: immediate addressing: RD = RD - Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //7

$display("-----------------------------------------------------------");
	$display("Shift: Left Logical: RD = shift logical left");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //8

    $display("-----------------------------------------------------------");
	$display("Shift: Right Logical:RD = shift logical right");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //9

$display("-----------------------------------------------------------");
	$display("Shift: Right Arithmetic: RD = shift right");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //10
    $display("-----------------------------------------------------------");

	$display("Jump: Jump to PC + sign extended immediate data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("-----------------------------------------------------------");
    //11
    $display("-----------------------------------------------------------");
	$display("Store");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //12
    $display("-----------------------------------------------------------");
	$display("Load");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("Cycle No: 5\tCycle Name: WB\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //13
    $display("-----------------------------------------------------------");
	$display("Branch Equal: branch to the address in register RT when RA and RB are equal");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("-----------------------------------------------------------");
    //14
    $display("-----------------------------------------------------------");
	$display("Branch not Equal: branch to the address in register RT when RA and RB are unequal");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("-----------------------------------------------------------");
    //15
    $display("-----------------------------------------------------------");
	$display("NAND: register addressing: RD = RS1 nand RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //16
    $display("-----------------------------------------------------------");
	$display("OR: register addressing: RD = RS1 or RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //17
    $display("-----------------------------------------------------------");
	$display("NAND: immediate addressing: RD = RD nand (sign extended immediate data)");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //18
    $display("-----------------------------------------------------------");
	$display("OR: immediate addressing: RD = RD or (sign extended immediate data)");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //19
    $display("-----------------------------------------------------------");
	$display("Addition: register addressing: RD = RS1 + RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //20
    $display("-----------------------------------------------------------");
	$display("Addition: immediate addressing: RD = RD + Sign-Extended-Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //21
    $display("-----------------------------------------------------------");
	$display("Addition: immediate addressing: RD = RD + Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //22
    $display("-----------------------------------------------------------");
	$display("Subtraction: register addressing: RD = RS1 - RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //23
    $display("-----------------------------------------------------------");
	$display("Subtraction: immediate addressing:RD = RD - Sign-Extended-Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //24
    $display("-----------------------------------------------------------");
	$display("Subtraction: immediate addressing: RD = RD - Immediate Data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //25
    $display("-----------------------------------------------------------");
	$display("Shift: Left Logical: RD = shift logical left");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //26
    $display("-----------------------------------------------------------");
	$display("Shift: Right Logical:RD = shift logical right");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //27
    $display("-----------------------------------------------------------");
	$display("Shift: Right Arithmetic: RD = shift right");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10$display("-----------------------------------------------------------");
    //28
    $display("-----------------------------------------------------------");
	$display("Jump: Jump to PC + sign extended immediate data");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("-----------------------------------------------------------");
    //29
    $display("-----------------------------------------------------------");
	$display("Store");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //30
    $display("-----------------------------------------------------------");
	$display("Load");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("Cycle No: 5\tCycle Name: WB\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //31
    $display("-----------------------------------------------------------");
	$display("Branch not Equal: branch to the address in register RT when RA and RB are unequal");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("-----------------------------------------------------------");
    //32
    $display("-----------------------------------------------------------");
	$display("Branch Equal: branch to the address in register RT when RA and RB are equal");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\tPC = %h\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out, regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("-----------------------------------------------------------");
    //33
    $display("-----------------------------------------------------------");
	$display("NAND: register addressing: RD = RS1 nand RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //34
    $display("-----------------------------------------------------------");
	$display("OR: register addressing: RD = RS1 or RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //35
    $display("-----------------------------------------------------------");
	$display("NAND: immediate addressing: RD = RD nand (sign extended immediate data)");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //36
    $display("-----------------------------------------------------------");
	$display("OR: immediate addressing: RD = RD or (sign extended immediate data)");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //37
    $display("-----------------------------------------------------------");
	$display("Addition: register addressing: RD = RS1 + RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //38
    $display("-----------------------------------------------------------");
	$display("Subtraction: register addressing: RD = RS1 - RS2");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //39
    $display("-----------------------------------------------------------");
	$display("Shift: Right Arithmetic: RD = shift right");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("-----------------------------------------------------------");
    //40
    $display("-----------------------------------------------------------");
	$display("Load");
	#10 $display("Cycle No: 1\tCycle Name: IF\tPC = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",PC_out,ALUOut_out, instr_out, cont_out);
	#10 $display("Cycle No: 2\tCycle Name: ID\treg1 = %h\treg2 = %h\treg3 = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out, instr_out,cont_out);
	#10 $display("Cycle No: 3\tCycle Name: EX\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out,cont_out);
	#10 $display("Cycle No: 4\tCycle Name: MEM\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
	#10 $display("Cycle No: 5\tCycle Name: WB\treg1 = %h\treg2 = %h\treg3 = %h\tALU = %h\tinstr = %h\tmem = %h\tcontrol = %b\t",regA_out, regB_out, regC_out,ALUOut_out, instr_out, out_memory,cont_out);
    #10 $display("-----------------------------------------------------------");
	#1 $finish;
end

endmodule
