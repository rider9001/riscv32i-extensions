// RISCV32I PC module testbench
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
logic PCBranch;
logic [dataW-1:0] BranchOffset;

// outputs
logic [dataW-1:0] ProgAddr;

pcR32I pc1
(
    .PCBranch(PCBranch),
    .BranchOffset(BranchOffset),
    .ProgAddr(ProgAddr),
    .reset(reset),
    .clock(clock)
);

initial
begin
    PCBranch = 0;
    BranchOffset = 0;
    #(CLOCK_P*3)
    BranchOffset = 89;
    PCBranch = 1;
    #CLOCK_P
    BranchOffset = 0;
    #(CLOCK_P*2)
    PCBranch = 0;
    #CLOCK_P
    // Test signed rollover behavoiur
    BranchOffset = 32'b0111_1111_1111_1111_1111_1111_1111_1111;
    PCBranch = 1;
    #CLOCK_P
    PCBranch = 0;
    #CLOCK_P
    // Test unsigned rollover behavoiur
    PCBranch = 1;
    #CLOCK_P
    PCBranch = 0;
    #(CLOCK_P*2)
    $finish;$stop;
end

endmodule