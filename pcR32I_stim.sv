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
logic signed [dataW-1:0] BranchOffset;
logic EQ, NE, LT, LTU, GE, GEU;
logic BranchControl;

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
    .BranchControl(BranchControl),
    .PCBranchType(PCBranchType),
    .BranchOffset(BranchOffset),
    .ProgAddr(ProgAddr),
    .reset(reset),
    .clock(clock)
);

initial
begin
    PCBranchType = `BEQ;
    BranchOffset = 0;
    EQ = 0;
    NE = 0;
    LT = 0;
    LTU = 0;
    GE = 0;
    GEU = 0;
    BranchControl = 0;
    #(CLOCK_P*3)
    BranchOffset = 40;
    BranchControl = 1;
    #CLOCK_P
    EQ = 1;
    #CLOCK_P
    $finish;$stop;
end

endmodule
