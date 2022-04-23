module IR (out1, out2, out3, out4, out5, out6, out7, in, IRWrite, clk);

output reg [11:0] out1;
output reg [3:0] out2, out6, out7;
output reg [1:0] out3, out4;
output reg [7:0] out5;
input [15:0] in;
input IRWrite, clk;

always @(negedge clk)
begin
	if(IRWrite)
		out1 <= in[11:0];
        out2 <= in[11:8];
        out3 <= in[11:10];
        out4 <= in[9:8];
        out5 <= in[7:0];
        out6 <= in[7:4];
        out7 <= in[3:0];
end

endmodule









output reg [11:0] dout1;
output reg [11:8] dout2;
output reg [11:10] dout3;
output reg [9:8] dout4;
output reg [7:0] dout5;
output reg [7:4] dout6;
output reg [3:0] dout7;

input wen, clk;
reg [15:0] register [0:15];

