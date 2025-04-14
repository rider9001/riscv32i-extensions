// Defines codes for all unique opcodes
// Values derived from examining RISCV compilation
// https://riscvasm.lucasteske.dev/#
// Some opcodes are added to by forwarding funct3 (and sometimes funct7) to the ALU
// This saves some decoding time
// LS 2 bits have to be 11 to follow standard
// bits [4:2] cannot be 111
// Standard enforces unique codes for many instructions

// Used for all ALU register-immediate operations that write back to a register
`define OPPI    7'b001_0011

// Used for all ALU register-register operations that write back to a register
`define OPPR    7'b011_0011

// LUI, special code for load upper
`define LUI     7'b011_0111

// AUPIPC, add upper immediate to PC
`define AUIPC   7'b001_0111

// JAL, jump and link
`define JAL     7'b110_1111

// JALR, jump and link register
`define JALR    7'b110_0111

// Branch, used for branching instructions
`define BRANCH  7'b110_0011

// Load, load from memory
`define LOAD    7'b000_0011

// Store, store to memory
`define STORE   7'b010_0011