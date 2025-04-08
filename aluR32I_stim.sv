// RSICV32I ALU testbench
`include "alucodesR32I.sv"
module aluR32I_stim;

timeunit 1ns; timeprecision 10ps;

parameter CLOCK_P = 100;

logic reset, clock;
// Intial reset
initial begin reset = 0; #10 reset = 1; #10 reset = 0; end

// Clock signal
always begin clock = 0; #(CLOCK_P/2) clock = 1; #(CLOCK_P/2) clock = 0; end

parameter dataW = 32;

// inputs
logic signed [dataW-1:0] A,B;
logic [3:0] alucode;

// outputs
logic [dataW-1:0] result;

aluR32I alu1
(
    .A(A),
    .B(B),
    .result(result)
);

initial
begin
    A = 9;
    B = 4;
    alucode = `ADD;
    #CLOCK_P
    alucode = `SLT;
    #CLOCK_P
    A = 2;
    #CLOCK_P
    A = 9;
    alucode = `SLTU;
    #CLOCK_P
    A = -1;
    #CLOCK_P
    A = 9;
    alucode = `AND;
    #CLOCK_P
    alucode = `OR;
    #CLOCK_P
    alucode = `XOR;
    #CLOCK_P
    B = 1;
    alucode = `SSL;
    #CLOCK_P
    B = 3;
    #CLOCK_P
    alucode = `SSR;
    #CLOCK_P
    alucode = `SRA;
    #CLOCK_P
    A = -9;
    #CLOCK_P
    alucode = `CPY;
    #CLOCK_P
    $finish;$stop;
end

endmodule