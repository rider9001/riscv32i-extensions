// Combined module for entire processor
module RISCV32IProc #(parameter dataW = 32, parameter RAMAddrSize = 32)
(
    input logic clock, reset,
    input logic [dataW-1:0] InpWord1, InpWord2,
    output logic [dataW-1:0] OutWord1, OutWord2
);


endmodule