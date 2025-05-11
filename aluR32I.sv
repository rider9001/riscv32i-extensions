// RISCV32I ALU module
// Doesnt make distinctions based on immediate/register nature of inputs
`include "alucodesR32I.sv" // Baseline set, opcodes[0-9]
`include "mul_modes.sv"    // codes for multiplier
`include "div_codes.sv"    // codes for divider
module aluR32I #(parameter dataW = 32)
(
    input logic signed [dataW-1:0] A, B,    // Two input operands
    input logic [4:0] ALUCode,              // alucode function selector
    output logic [dataW-1:0] result         // result of operation
);

timeunit 1ns; timeprecision 10ps;

// Create unsigned versions of inputs for synthesis
logic [dataW-1:0] UA, UB;
assign UA = A;
assign UB = B;

// control signals for multiplier and divider
logic [1:0] mulCode, divCode;

// multipler and divider output
logic [dataW-1:0] mulRes, divRes;

// multiplier module, in ISA rs1 is multiplicand, rs2 is multiplier
smulR32M smul1
(
    .M(B),
    .Q(A),
    .UM(UB),
    .UQ(UA),
    .mulCode(mulCode),
    .out(mulRes)
);

// divider module, in ISA rs1 is dividend and rs2 is divisor (rs1 / rs2)
sdivR32M sdiv1
(
    .DivD(A),
    .DivI(B),
    .UDivD(UA),
    .UDivI(UB),
    .divCode(divCode),
    .out(divRes)
);

always_comb
begin
    mulCode = 0;
    divCode = 0;

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

        `MUL:
            begin
                result = mulRes;
                mulCode = `MULC;
            end

        `MULH:
            begin
                result = mulRes;
                mulCode = `MULHC;
            end

        `MULHU:
            begin
                result = mulRes;
                mulCode = `MULHUC;
            end

        `MULHSU:
            begin
                result = mulRes;
                mulCode = `MULHSUC;
            end

        `DIV:
            begin
                result = divRes;
                divCode = `DIVC;
            end

        `DIVU:
            begin
                result = divRes;
                divCode = `DIVUC;
            end

        `REM:
            begin
                result = divRes;
                divCode = `REMC;
            end

        `REMU:
            begin
                result = divRes;
                divCode = `REMUC;
            end

        default:    out = 32'bx;
    endcase
end

endmodule
