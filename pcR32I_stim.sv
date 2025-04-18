// RISCV32I PC module testbench
`include "branchcodes.sv"
module pcR32I_stim;

timeunit 1ns; timeprecision 10ps;

parameter CLOCK_P = 100;

logic reset, clock;
// Intial reset
initial begin reset = 0; #10 reset = 1; #10 reset = 0; end

// Clock signal
always begin clock = 0; #(CLOCK_P/2) clock = 1; #(CLOCK_P/2) clock = 0; end

parameter dataW = 32;

// inputs
logic [2:0] PCBranchType;
logic signed [dataW-1:0] BranchAddr;
logic EQ, NE, LT, LTU, GE, GEU;
logic TestBranch, AlwaysBranch, AbsoluteBranch;

// outputs
logic [dataW-1:0] ProgAddr;

pcR32I pc1
(
    .EQ(EQ),
    .NE(NE),
    .LT(LT),
    .LTU(LTU),
    .GE(GE),
    .GEU(GEU),
    .TestBranch(TestBranch),
    .PCBranchType(PCBranchType),
    .BranchAddr(BranchAddr),
    .AlwaysBranch(AlwaysBranch),
    .AbsoluteBranch(AbsoluteBranch),
    .ProgAddr(ProgAddr),
    .reset(reset),
    .clock(clock)
);

initial
begin
    PCBranchType = `BEQ;
    BranchAddr = 0;
    AbsoluteBranch = 0;
    EQ = 0;
    NE = 0;
    LT = 0;
    LTU = 0;
    GE = 0;
    GEU = 0;
    TestBranch = 0;
    AlwaysBranch = 0;
    #(CLOCK_P*3)
    BranchAddr = 64;
    AlwaysBranch = 1;
    #(CLOCK_P*2)
    AbsoluteBranch = 1;
    #(CLOCK_P*2)
    AlwaysBranch = 0;
    AbsoluteBranch = 0;
    #(CLOCK_P*2)
    TestBranch = 1;
    #(CLOCK_P)
    EQ = 1;
    #CLOCK_P
    PCBranchType = `BNEQ;
    #CLOCK_P
    NE = 1;
    #CLOCK_P
    $finish;$stop;
end

endmodule
