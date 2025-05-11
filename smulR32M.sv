// RISCV32M multiplication module
// Performs all signed and unsigned integer multiplications outlined in the M extension
`include "mul_codes.sv"
module smulR32M #(parameter dataW = 32)
(
    input logic signed [dataW-1:0] M, Q,        // Signed number inputs, M = multiplier, Q = multiplicand
    input logic [dataW-1:0] UM, UQ,             // Unsigned number inputs
    input logic [1:0] mulCode,                  // Multiplication type code
    output logic [dataW-1:0] out                // Output result
);

timeunit 1ns; timeprecision 10ps;

always_comb
begin
    case (mulCode)
        `MULC:       out = (M * Q)[dataW-1:0];

        `MULHC:      out = (M * Q)[(dataW*2)-1:dataW];

        `MULHUC:     out = (UM * UQ)[(dataW*2)-1:dataW];

        `MULHSUC:    out = (UM * Q)[(dataW*2)-1:dataW];
    endcase
end

endmodule
