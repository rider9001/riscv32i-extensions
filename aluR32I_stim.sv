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
logic [4:0] alucode;

// outputs
logic signed [dataW-1:0] result;

aluR32I alu1
(
    .A(A),
    .B(B),
    .ALUCode(alucode),
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
    alucode = `SLTU;
    #CLOCK_P
    A = 9;
    #CLOCK_P
    A = -2;
    #CLOCK_P
    B = -1;
    #CLOCK_P
    A = 9;
    B = 5;
    alucode = `AND;
    #CLOCK_P
    alucode = `OR;
    #CLOCK_P
    alucode = `XOR;
    #CLOCK_P
    B = 1;
    alucode = `SLL;
    #CLOCK_P
    B = 3;
    #CLOCK_P
    alucode = `SRL;
    #CLOCK_P
    alucode = `SRA;
    #CLOCK_P
    A = -9;
    #CLOCK_P
    alucode = `CPY;
    #CLOCK_P
    A = 9;
    alucode = `SUB;
    #CLOCK_P
    B = 10;
    #CLOCK_P
    A = -78;
    B = -901;
    #CLOCK_P
    // Multiplication test uses 85123(0x00014C83) x -95312 (0xFFFE8BB0)
    A = 32'h00014C83;
    B = 32'hFFFE8BB0;
    // Expected result = 0x1C69BB10
    alucode = `MUL;
    #CLOCK_P
    alucode = `MULH;
    // Expected result = 0xFFFFFFFE
    #CLOCK_P
    alucode = `MULHU;
    // Expected result = 0x00014C81
    #CLOCK_P
    alucode = `MULHSU;
    // Expected result = 0x00000001
    #CLOCK_P
    A = 32'hFFFEB37D; // (-85123)
    // Expected result = 0xFFFD3F2E
    #CLOCK_P
    A = 18;
    B = 4;
    alucode = `DIV;
    // Expected result = 4
    #CLOCK_P
    alucode = `REM;
    // Expected result = 2
    #CLOCK_P
    B = -4;
    alucode = `DIV;
    // Expected result = -4
    #CLOCK_P
    alucode = `REM;
    // Expected result = -2
    #CLOCK_P
    B = 4;
    A = -18;
    #CLOCK_P
    $finish;$stop;
end

endmodule
