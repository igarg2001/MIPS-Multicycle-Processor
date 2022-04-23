module PC (PC_out, address, PC_Write, clk, reset);

output [15:0] PC_out;
input [15:0] address;
input PC_Write, clk, reset;

always @(negedge_clk or reset)
begin
    if(reset)
        PC_out <= 16'h0000;
    if(PC_Write)
        PC_out <= address;
end

endmodule