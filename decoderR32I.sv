// RISCV32I decoder module
// Supports only 32 bit length instructions
// RSICV opcodes are broken across the instruction to speed decoding
// Opcodes are more for determining the instruction type, decoders job is then
// figuring out immdiates and wether to include funct7 to funct3 for ALU
`include "opcodesR23I.sv"
`include "alucodesR23I.sv"
`include "branchcodes.sv"
module decoderR32I #(parameter dataW = 32)
(
    input logic [dataW-1:0] rawIns,                 // Complete instruction
    // incomplete, add in interconnect switches
);

// Extracted opcode parts
wire [6:0] opcode;
assign opcode = rawIns[6:0];

wire [2:0] funct3;
assign funct3 = rawIns[14:12];

wire [6:0] funct7;
assign funct7 = rawIns[31:25];

// Extracted register addresses
wire [4:0] rs1, rs2, rd;
assign rs1 = rawIns[19:15];
assign rs2 = rawIns[24:20];
assign rd = rawIns[11:7];

// Wiring to decode different immediate types
wire [dataW-1:0] immTypeI, immtypeS, immtypeB, immtypeU, immtypeJ;

// I type immediate
assign immTypeI = {20'd0, rawIns[31:20]};

// S (store) - type immediate
assign immtypeS = {20'd0, rawIns[31:25], rawIns[11:7]};

// B (Branch) - type immediate
assign immtypeB = {19'd0, rawIns[31], rawIns[7], rawIns[30:25], rawIns[11:8], 1'd0};

// U (load upper) - type immediate
assign immtypeU = {rawIns[31:12], 12'd0};

// J (jump) - type immediate
assign immtypeJ = {11'd0, rawIns[31], rawIns[19:12], rawIns[20], rawIns[30:21], 1'd0};

endmodule