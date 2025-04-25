// RISCV32I ALU module
// Doesnt make distinctions based on immediate/register nature of inputs
`include "alucodesR32I.sv" // Baseline set, opcodes[0-9]
module aluR32I #(parameter dataW = 32)
(
    input logic signed [dataW-1:0] A, B,    // Two input operands
    input logic [3:0] ALUCode,              // alucode function selector
    output logic [dataW-1:0] result         // result of operation
);

timeunit 1ns; timeprecision 10ps;

// Create unsigned versions of inputs for synthesis
logic [dataW-1:0] UA, UB;
assign UA = A;
assign UB = B;

always_comb
begin
    case (ALUCode)
        `ADD: result = A + B;

        `SLT: result = (A < B);

        `SLTU: result = (UA < UB);

        `AND: result = A & B;

        `OR: result = A | B;

        `XOR: result = A ^ B;

        `SLL: result = A << UB[4:0];

        `SRL: result = A >> UB[4:0];

        `SRA: result = A >>> UB[4:0];

        `CPY: result = B;

        `SUB: result = A - B;
    endcase
end

endmodule
