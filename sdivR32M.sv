// RISCV32M division module
// Performs all signed and unsigned integer divisions outlined in the M extension
`include "div_codes.sv"
module smdivR32M #(parameter dataW = 32)
(
    input logic signed [dataW-1:0] DivD, DivI,  // Signed number inputs, DivD = Dividend, DivI = Divisor
    input logic [dataW-1:0] UDivD, UDivI,       // Unsigned number inputs
    input logic [1:0] divCode,                  // Multiplication type code
    output logic [dataW-1:0] out                // Output result
);

timeunit 1ns; timeprecision 10ps;

// All divisions are Dividend(DivD) / Divisor(DivI)

always_comb
begin
    case (divCode)
        `DIVC:      out = DivD / DivI;

        `REMC:      out = DivD % DivI;

        `DIVUC:     out = UDivD / UDivI;

        `REMUC:     out = UDivD % UDivI;
    endcase
end

endmodule