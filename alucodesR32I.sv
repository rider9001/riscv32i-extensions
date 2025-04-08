// ALU codes for all possible ALU operations
// 4-bits wide
// both inputs will always be 32-bits
// input switching performed by decoder
// decoding immediates done via decoder switching

// ADD, code used for ADD and ADDI ins
// Adds two operands
`define ADD     4'd0

// SLT, set-less-than, used for STLI and STL
// result is 1 if operand1 < operand2 signed comparison, else 0
`define SLT     4'd1

// SLTU, set-less-than-unsigned, used for STLIU and STLU
// result is 1 if operand1 < operand2 unsigned comparison, else 0
`define SLTU    4'd2

// AND, logical and, used for AND and ANDI
// logically ANDs two operands together
`define AND     4'd3

// OR, logical or, used for OR and ORI
// logically ORs two operands together
`define OR      4'd4

// XOR, logical xor, used for XOR and XORI
// logically XORs two operands together
`define XOR     4'd5

// SSL, shift-left-logical, used for SSL and SSLI
// logically shifts first operand left by second
// (zeros shifted into lower bits)
// Will only use lower 5 bits of second operand
`define SSL     4'd6

// SSR, shift-right-logical, used for SSR and SSRI
// logically shifts first operand right by second
// (zeros shifted into upper bits)
// Will only use lower 5 bits of second operand
`define SSR     4'd7

// SSR, shift-right-arithemetic, used for SRA and SRAI
// arithemetically shifts first operand right by second
// (sign bit is shifted into upper bits)
// Will only use lower 5 bits of second operand
`define SRA     4'd8

// CPY, repeats the value in operand 2, used for LUI
`define CPY     4'd9

// Note that implementation of AUIPC is implemented by the decoder
// switching in the PC into the first operand, then using ADD
