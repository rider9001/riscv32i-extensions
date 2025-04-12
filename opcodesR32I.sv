// Defines codes for all unique opcodes
// Some opcodes are added to by forwarding funct3 (and sometimes funct7) to the ALU
// This saves some decoding time
// LS 2 bits have to be 11 to follow standard
// bits [4:2] cannot be 111
// Standard enforces unique codes for many instructions

// Used for all ALU register-immediate operations that write back to a register
`define OPPI    7'b00000_11

// Used for all ALU register-register operations that write back to a register
`define OPPR    7'b00001_11

// LUI, special code for load upper
`define LUI     7'b00010_11

// AUPIPC, add upper immediate to PC
`define AUIPC   7'b00011_11

// JAL, jump and link
`define JAL     7'b00100_11

// JALR, jump and link register
`define JALR    7'b00101_11

// Branch, used for branching instructions
`define BRANCH  7'b00110_11

// Load, load from memory
`define LOAD    7'b01000_11

// Store, store to memory
`define STORE   7'b01001_11