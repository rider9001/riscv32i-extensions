// Combined module for entire processor
module RISCV32IProc
#(
parameter dataW = 32,
parameter RAMAddrSize = 32,
parameter CachedIns = 32,
parameter ROMFile = "no_file_loaded.hex"
)
(
    input logic clock, reset,
    input logic [dataW-1:0] InpWord1, InpWord2,
    output logic [dataW-1:0] OutWord1, OutWord2
);

timeunit 1ns; timeprecision 10ps;

// Conditional generator output wires
wire EQ, NE, LT, LTU, GE, GEU;

// Decoder -> PC wires
wire AbsoluteBranch, TestBranch, AlwaysBranch;
wire [2:0] BranchType;

// Cache -> PC wire
wire InsCacheStall;

// PC -> Cache address
wire [dataW-1:0] ProgAddr;

// Cache read address wire
wire [RAMAddrSize-1:0] InsCacheReadAddr;

// Cache -> Decoder instruction wire
wire [dataW-1:0] OutputIns;

// ALU result wire
wire [dataW-1:0] ALUResult;

// ALU -> PC branch address
wire [dataW-1:0] BranchAddr;
assign BranchAddr = {>>{ALUResult[dataW-1:1], 'b0}};

// RAM output wire
wire [dataW-1:0] RAMOut;

// Decoder -> register wires
wire RegWriteControl;
wire [4:0] RegData1, RegData2, RegWriteAddr;

// Decoder -> register input switching logic
wire [dataW-1:0] RegDataIn;
wire LinkAddrWrite, RAMRegRead;

// Register output wires
wire [dataW-1:0] RegDataOut1, RegDataOut2;

// Decoder -> RAM control wire
wire RAMWriteControl;

// Decoder -> ALU input switching logic
wire UseImm, UsePC;

// Decoder -> ALU code
wire [3:0] ALUCode;

// Decoder -> ALU immdiate wire
wire [dataW-1:0] ImmOut;

// ALU input wires, attached to switching logic
wire [dataW-1:0] ALUIn1, ALUIn2;
assign ALUIn1 = UsePC ? ProgAddr : RegDataOut1;
assign ALUIn2 = UseImm ? ImmOut : RegDataOut2;

// RAM address wire and steering logic
wire [RAMAddrSize-1:0] RAMAddr;
assign RAMAddr = InsCacheStall ? InsCacheReadAddr : ALUResult;

// Register input steering logic
wire [dataW-1:0] RegDataInPre;
// +4 is to create the return address on link instructions
assign RegDataIn = LinkAddrWrite ? (ProgAddr+4) : RegDataInPre;
assign RegDataInPre = RAMRegRead ? RAMOut : ALUResult;

// Decoder definintion
decoderR32I #(dataW) dec1
(
    .rawIns(OutputIns),
    .RegData1(RegData1),
    .RegData2(RegData2),
    .RegWriteAddr(RegWriteAddr),
    .RegWriteControl(RegWriteControl),
    .LinkAddrWrite(LinkAddrWrite),
    .BranchType(BranchType),
    .TestBranch(TestBranch),
    .AlwaysBranch(AlwaysBranch),
    .AbsoluteBranch(AbsoluteBranch),
    .UseImm(UseImm),
    .UsePC(UsePC),
    .ALUCode(ALUCode),
    .ImmOut(ImmOut),
    .RAMWriteControl(RAMWriteControl),
    .RAMRead(RAMRead)
);

// PC definition
pcR32I #(dataW) pc1
(
    .clock(clock),
    .reset(reset),
    .EQ(EQ),
    .NE(NE),
    .LT(LT),
    .LTU(LTU),
    .GE(GE),
    .GEU(GEU),
    .TestBranch(TestBranch),
    .AlwaysBranch(AlwaysBranch),
    .AbsoluteBranch(AbsoluteBranch),
    .InsCacheStall(InsCacheStall),
    .BranchType(BranchType),
    .BranchAddr(BranchAddr),
    .ProgAddr(ProgAddr)
);

// Ins cache definition
InsCacheR32I #(dataW, CachedIns) InsC1
(
    .clock(clock),
    .reset(reset),
    .ProgAddr(ProgAddr),
    .InsReadInp(InsReadInp),
    .InsCacheStall(InsCacheStall),
    .InsCacheReadAddr(InsCacheReadAddr),
    .OutputIns(OutputIns)
);

// Conditional generator definition
conditionalR32I #(dataW) cond1
(
    .rs1(RegData1),
    .rs2(RegData2),
    .EQ(EQ),
    .NE(NE),
    .LT(LT),
    .LTU(LTU),
    .GE(GE),
    .GEU(GEU)
);

// Register file definition
registerR32I #(dataW) reg1
(
    .clock(clock),
    .reset(reset),
    .RegWriteControl(RegWriteControl),
    .RegDataIn(RegDataIn),
    .RegData1(RegData1),
    .RegData2(RegData2),
    .RegWriteAddr(RegWriteAddr),
    .RegDataOut1(RegDataOut1),
    .RegDataOut2(RegDataOut2)
);

// ALU definition
aluR32I #(dataW) alu1
(
    .A(ALUIn1),
    .B(ALUIn2),
    .ALUCode(ALUCode),
    .result(ALUResult)
);

// RAM definition
zeroDelayRAM #(dataW, RAMAddrSize, ROMFile) ram1
(
    .clock(clock),
    .reset(reset),
    .RAMAddr(RAMAddr),
    .DataIn(RegData2),
    .RAMWriteControl(RAMWriteControl),
    .InpWord1(InpWord1),
    .InpWord2(InpWord2),
    .RAMOut(RAMOut),
    .OutWord1(OutWord1),
    .OutWord2(OutWord2)
);

endmodule