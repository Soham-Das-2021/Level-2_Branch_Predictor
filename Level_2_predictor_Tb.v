//***Checking the Sequence: T NT T T NT ***//
`timescale 1ps/1ps

module level_2_predictor_Tb;

reg clk;
reg [4:0] PC;
reg [4:0] effective_address;

level_2_predictor uut(clk,PC,effective_address);

initial 
begin
    clk=1; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;
    
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;

    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;

    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b01001; #10;
    PC=5'b01100; effective_address=5'b10000; #10;

    PC=5'bxxxxx; effective_address=5'bxxxxx;
end

always 
#5 clk=~clk;

endmodule