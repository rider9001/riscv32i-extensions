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

logic [(2*dataW)-1:0] signedMul, unsignedMul, signedUnsignedMul;

assign signedMul = (M * Q);
assign unsignedMul = (UM * UQ);
assign signedUnsignedMul = (UM * Q);

always_comb
begin
    case (mulCode)
        `MULC:      out = signedMul[dataW-1:0];

        `MULHC:     out = signedMul[(2*dataW)-1:dataW];

        `MULHUC:    out = unsignedMul[(dataW*2)-1:dataW];

        `MULHSUC:   out = signedUnsignedMul[(dataW*2)-1:dataW];
    endcase
end

endmodule
