module ID_Mem (d_out, d_in, address, R_en, W_en, IorD, clk);

output reg [15:0] d_out;
input [15:0] address, d_in;
input R_en, W_en, IorD, clk;
reg [7:0] mem [0:64*1024-1];

initial
begin
	if(IorD)
    	$readmemh("data_mem.dat", mem); // IorD=1 means Data address from ALUOut
	if(~IorD)
		$readmemh("instr_mem.dat", mem); // IorD=0 means Instruction address obtd from PC
end

always @(negedge clk)
begin
	if(R_en)
		d_out <= {mem[address+1],mem[address]};
	else
		d_out <= 16'bz;
    if(W_en)
	begin
		{mem[address+1], mem[address]} <= d_in;
		$writememh("data_mem.dat", mem);
	end
end

endmodule