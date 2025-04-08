// RISCV32I condition flag generator module
// compares two dataW inputs for:
// equality, inequality, less than, greater than or equal
// A high on the relevant signal indicates a branch should be taken
module conditionalR32I #(parameter dataW = 32)
(
    input logic [dataW-1:0] rs1, rs2,
    output logic EQ, NE, LT, LTU, GE, UGE     // condition signals, U indicates unsigned comparison
);

timeunit 1ns; timeprecision 10ps;

logic signed [dataW-1:0] rs1Signed, rs2Signed;

// Create signed versions to get synthesized to infer correct logic
assign rs1Signed = rs1;
assign rs2Signed = rs2;

// Comparison assignments

// Equality/inequality
assign EQ = (rs1 == rs2);
assign NE = !EQ;

// Signed less than/greater or equal
assign LT = (rs1Signed < rs2Signed);
assign GE = !LT;

// Unsigned less than/greater or equal
assign ULT = (rs1 < rs2);
assign UGE = !ULT;

endmodule