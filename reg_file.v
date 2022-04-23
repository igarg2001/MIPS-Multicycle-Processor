module reg_file (rd1, rd2, rd3, read1, read2, read3, rwr, dwr, wen, clk);

output reg [15:0] rd1, rd2, rd3;
input [3:0] read1, read2, read3;
input [3:0] rwr;
input [15:0] dwr;
input wen, clk;

reg [15:0] register [0:15];

initial 
    $readmemh("data_mem.dat", register);

always @(negedge clk) begin
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