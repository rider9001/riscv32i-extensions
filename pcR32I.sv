// RISCV32I PC module
// RISCV only supports relavtive jumps (JAL) and absolute jumps (JALR)
// Currently only supports 32-bit instruction increments
module pcR32I #(parameter dataW = 32)
(
    input logic clock, reset,
    input logic EQ, NE, LT, LTU, GE, GEU,          // Conditional input flags
    input logic TestBranch,                        // High if PC should be testing for branch using BranchType
    input logic AlwaysBranch,                      // High if PC should unconditionally branch
    input logic AbsoluteBranch,                    // High if BranchAddr should be treated as an absolute jump
    input logic [2:0] PCBranchType,                // indicates type of branch to take, see branchcodes.sv
    input logic signed [dataW-1:0] BranchAddr,     // address to add/set to the PC when branching
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
        if ((BranchStatus[PCBranchType] && TestBranch) || AlwaysBranch)
        begin
            if (AbsoluteBranch) ProgAddr <= BranchOffset;
            else ProgAddr <= ProgAddr + BranchOffset;
        end
        else ProgAddr <= ProgAddr + 4;
    end
end

endmodule