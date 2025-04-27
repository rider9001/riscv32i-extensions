// Defines all possible branches that can be taken by PC
// Indicates which conditional signal should be obeyed
// High on a signal indicates branch should be taken
// Numbers index a bitpack, do not change without changing BranchStatus as well
// Numbers are pulled from assembly output of https://riscvasm.lucasteske.dev/#

// Branch if equal
`define BEQ     3'd0

// Branch if not equal
`define BNEQ    3'd1

// Branch if less-than signed
`define BLT     3'd4

// Branch if less-than unsigned
`define BLTU    3'd6

// Branch if more-than or equal signed
`define BGE     3'd5

// Branch if more-than or equal unsigned
`define BGEU    3'd7