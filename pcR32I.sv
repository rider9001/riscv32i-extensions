// RISCV32I PC module
// RISCV only supports relative jumps
// Currently only supports 32-bit instruction increments
module pcR32I #(parameter dataW = 32)
(
    input logic clock, reset,
    input logic EQ, NE, LT, LTU, GE, GEU,          // Conditional input flags
    input logic BranchControl,                     // High if PC should be branching
    input logic [2:0] PCBranchType,                // indicates type of branch to take, see branchcodes.sv
    input logic signed [dataW-1:0] BranchOffset,   // offset to add to the PC if PCBranch is high
    output logic signed [dataW-1:0] ProgAddr       // output program address
);

timeunit 1ns; timeprecision 10ps;

wire [5:0] BranchStatus;
assign BranchStatus = {GEU, GE, LTU, LT, NE, EQ};

always_ff @( posedge clock, posedge reset )
begin
    if (reset) ProgAddr <= 0;
    else
    begin
        if (BranchStatus[PCBranchType] && BranchControl) ProgAddr <= ProgAddr + BranchOffset;
        else ProgAddr <= ProgAddr + 4;
    end
end

endmodule