// ALU codes for all possible ALU operations
// 4-bits wide
// Based off of the returned funct3/7 of the RISCV compiler
// https://riscvasm.lucasteske.dev/#
// both inputs will always be 32-bits
// input switching performed by decoder
// decoding immediates done via decoder switching

// --- Base R32I code functions ---

// ADD, code used for ADD and ADDI ins
// Adds two operands
`define ADD     5'd0

// SLT, set-less-than, used for STLI and STL
// result is 1 if operand1 < operand2 signed comparison, else 0
`define SLT     5'd2

// SLTU, set-less-than-unsigned, used for STLIU and STLU
// result is 1 if operand1 < operand2 unsigned comparison, else 0
`define SLTU    5'd3

// AND, logical and, used for AND and ANDI
// logically ANDs two operands together
`define AND     5'd7

// OR, logical or, used for OR and ORI
// logically ORs two operands together
`define OR      5'd6

// XOR, logical xor, used for XOR and XORI
// logically XORs two operands together
`define XOR     5'd4

// SLL, shift-left-logical, used for SLL and SLLI
// logically shifts first operand left by second
// (zeros shifted into lower bits)
// Will only use lower 5 bits of second operand
`define SLL     5'd1

// SRL, shift-right-logical, used for SRL and SRLI
// logically shifts first operand right by second
// (zeros shifted into upper bits)
// Will only use lower 5 bits of second operand
`define SRL     5'd5

// SRA, shift-right-arithemetic, used for SRA and SRAI
// arithemetically shifts first operand right by second
// (sign bit is shifted into upper bits)
// Will only use lower 5 bits of second operand
`define SRA     5'd13
// NOTE: on immediate opcode, shares a funct3 with SRL, system will include rawIns[30] as MSB of opcode

// SUB, subtract, used for SUB
// subtracts the first operand from the second
// only exists as an R-type instruction
`define SUB     5'd8

// CPY, repeats the value in operand 2, used for LUI
`define CPY     5'b11111

// --- M extension codes ---

// MUL, multiply signed x signed, used for MUL
// multplies two input numbers as signed integers
// outputs lower 32 bits of result
`define MUL     5'd16

// MULH, multiply signed xs igned upper, used for MULH
// multplies two input numbers as signed integers
// outputs upper 32 bits of result
`define MULH    5'd17

// MULHSU, multiply signed x unsigned upper, used for MULHSU
// multplies two input numbers as signed and unsigned in turn
// outputs upper 32 bits of result
`define MULHSU  5'd18

// MULHU, multiply unsigned x unsigned upper, used for MULHU
// multplies two input numbers as unsigned integers
// outputs upper 32 bits of result
`define MULHU   5'd19

// DIV, division signed, used for DIV
// divides A / B as signed integers
// returns quotient of result
`define DIV     5'd20

// DIVU, division unsigned, used for DIVU
// divides A / B as unsigned integers
// returns quotient of result
`define DIVU    5'd21

// REM, remainder signed, used for REM
// divides A / B as signed integers
// returns remainder of result
// Note: Will 'ignore' negative dividends (e.g: 18 % -4 = 2 = 18 % 4)
`define REM     5'd22

// REMU, remainder unsigned, used for REMU
// divides A / B as unsigned integers
// returns remainder of result
`define REMU    5'd23