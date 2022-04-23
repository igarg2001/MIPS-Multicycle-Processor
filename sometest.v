module test;
   initial begin
      reg[15:0]a;
      reg [15:0] b;
           a=$urandom; 
           #100;
           b=$urandom;
           $display("A %d, B: %d",a,b);    
      $finish;
   end
endmodule