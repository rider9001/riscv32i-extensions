// RISCV32I PC module
// RISCV only supports relavtive jumps (JAL) and absolute jumps (JALR)
// Branches are implemented as absolute jumps that use the relative result from the ALU
// Currently only supports 32-bit instruction increments
module pcR32I #(parameter dataW = 32)
(
    input logic clock, reset,
    input logic EQ, NE, LT, LTU, GE, GEU,          // Conditional input flags
    input logic TestBranch,                        // High if PC should be testing for branch using BranchType
    input logic AlwaysBranch,                      // High if PC should unconditionally branch
    input logic AbsoluteBranch,                    // High if BranchAddr should be treated as an absolute jump
    input logic InsCacheStall,                     // Signal to stall PC for period of refreshing instruction cache
    input logic [2:0] BranchType,                  // indicates type of branch to take, see branchcodes.sv
    input logic signed [dataW-1:0] BranchAddr,     // address to add/set to the PC when branching
    output logic signed [dataW-1:0] ProgAddr       // output program address
);

timeunit 1ns; timeprecision 10ps;

wire [0:7] BranchStatus;
assign BranchStatus = {EQ, NE, 1'b0, 1'b0, LT, GE, LTU, GEU};

// Branch offset/addr always has the last bit reset
logic signed [dataW-1:0] EvenAddr;
assign EvenAddr = {>>{BranchAddr[31:1], 1'b0}};

always_ff @( posedge clock, posedge reset )
begin
    if (reset) ProgAddr <= 0;
    else
    begin
        if (!InsCacheStall)
        begin
            if ((BranchStatus[BranchType] && TestBranch) || AlwaysBranch)
            begin
                if (AbsoluteBranch) ProgAddr <= EvenAddr;
                else ProgAddr <= ProgAddr + EvenAddr;
            end
            else ProgAddr <= ProgAddr + 4;
        end
    end
end

endmodule
