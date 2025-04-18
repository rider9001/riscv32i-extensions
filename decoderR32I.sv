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
    input logic [dataW-1:0] rawIns,                                         // Complete instruction
    // Register control
    output logic [$clog2(dataW)-1:0] RegData1, RegData2, RegWriteAddr       // Register addresses
    output logic RegWriteControl,                                           // Register write enable
    output logic LinkAddrWrite,                                             // +4 Offset write to create return addresses
    // PC control logic
    output logic [2:0] BranchType,                                          // Controls the type of conditional branch
    output logic TestBranch,                                                // PC should branch conditionally based on input from conditional generator
    output logic AlwaysBranch,                                              // PC should always branch when high
    output logic AbsoluteBranch,                                            // PC should adopt input BranchAddr when high, add to existing PC when low
    // ALU control logic
    output logic UseImm,                                                    // ALU input 2 should be switched from reg2 to ImmOut
    output logic UsePC,                                                     // ALU input 1 should be switched from reg1 to ProgAddr
    output logic [3:0] ALUCode,                                             // ALU control code to select operation
    output logic [dataW-1:0] ImmOut                                         // Decoded immediate
    // RAM control logic
    output logic RAMWrite,                                                  // Flag to indicate to RAM to write incoming value
    output logic RAMRead                                                    // Flag to switch ALU output into RAMBus
);

timeunit 1ns; timeprecision 10ps;

// Extracted opcode parts
logic [6:0] opcode;
assign opcode = rawIns[6:0];

logic [2:0] funct3;
assign funct3 = rawIns[14:12];

logic [6:0] funct7;
assign funct7 = rawIns[31:25];

// Extracted register addresses
assign RegData1 = rawIns[19:15];
assign RegData2 = rawIns[24:20];
assign RegWriteAddr = rawIns[11:7];

// Branch type is encoded in funct3
assign BranchType = funct3;

// Wiring to decode different immediate types
logic [dataW-1:0] immTypeI, immtypeS, immtypeB, immtypeU, immtypeJ;

// sign extender hardware
logic [19:0] IStypeSign;
logic [18:0] BTypeSign;
logic [10:0] JTypeSign;
signExtender s1
(
    .sign(rawIns[31]),
    .IStypeSign(IStypeSign),
    .BTypeSign(BTypeSign),
    .JTypeSign(JTypeSign)
);

// I type immediate
assign immTypeI = {>>{IStypeSign, rawIns[31:20]}};

// S (store) - type immediate
assign immtypeS = {>>{IStypeSign, rawIns[31:25], rawIns[11:7]}};

// B (Branch) - type immediate
assign immtypeB = {>>{BTypeSign, rawIns[31], rawIns[7], rawIns[30:25], rawIns[11:8], 1'd0}};

// U (load upper) - type immediate
assign immtypeU = {>>{rawIns[31:12], 12'd0}};

// J (jump) - type immediate
assign immtypeJ = {>>{JTypeSign, rawIns[31], rawIns[19:12], rawIns[20], rawIns[30:21], 1'd0}};

always_comb
begin
    // Default assignments
    RegWriteControl = 0;
    LinkAddrWrite = 0;
    TestBranch = 0;
    AlwaysBranch = 0;
    AbsoluteBranch = 0;
    UseImm = 0;
    UsePC = 0;
    ALUCode = 0;
    ImmOut = immTypeI;
    RAMWrite = 0;
    RAMRead = 0;

    case (opcode)
        `OPPI:
            begin
                ImmOut = immTypeI;
                case (funct3)
                    5: ALUCode = {>>{rawIns[30], funct3}};
                    default: ALUCode = {>>{'b0, funct3}};
                endcase
                RegWriteControl = 1;
                UseImm = 1;
            end

        `OPPR:
            begin
                ALUCode = {>>{rawIns[30], funct3}};
                RegWriteControl = 1;
            end

        `LUI:
            begin
                ImmOut = immtypeU;
                UseImm = 1;
                RegWriteControl = 1;
                ALUCode = `CPY;
            end

        `AUIPC:
            begin
                ImmOut = immtypeU;
                UseImm = 1;
                UsePC = 1;
                RegWriteControl = 1;
                ALUCode = `ADD;
            end

        `JAL:
            begin
                AlwaysBranch = 1;
                ImmOut = immtypeJ;
                UseImm = 1;
                ALUCode = `CPY;
                LinkAddrWrite = 1;
                RegWriteControl = 1;
            end

        `JALR:
            begin
                AlwaysBranch = 1;
                AbsoluteBranch = 1;
                ImmOut = immTypeI;
                UseImm = 1;
                ALUCode = `ADD;
                LinkAddrWrite = 1;
                RegWriteControl = 1;
            end

        `BRANCH:
            begin
                TestBranch = 1;
                ImmOut = immtypeB;
                UsePC = 1;
                UseImm = 1;
                ALUCode = `ADD;
            end

        `LOAD:
            begin
                RegWriteControl = 1;
                ImmOut = immTypeI;
                ALUCode = `ADD;
                UseImm = 1;
                RAMRead = 1;
            end

        `STORE:
            begin
                ImmOut = immTypeS;
                ALUCode = `ADD;
                UseImm = 1;
                RAMWrite = 1;
                RAMRead = 1;
            end
    endcase
end

endmodule