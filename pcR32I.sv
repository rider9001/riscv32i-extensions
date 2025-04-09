// RISCV32I PC module
// RISCV only supports relative jumps
// Currently only supports 32-bit instruction increments
module pcR32I #(parameter dataW = 32)
(
    input logic clock, reset,
    input logic PCBranch,                          // goes high if PC should add BranchOffset to the PC, increment +4 if low
    input logic signed [dataW-1:0] BranchOffset,   // offset to add to the PC if PCBranch is high
    output logic signed [dataW-1:0] ProgAddr       // output program address
);

timeunit 1ns; timeprecision 10ps;

always_ff @( posedge clock, posedge reset )
begin
    if (reset) ProgAddr <= 0;
    else
    begin
        if (PCBranch) ProgAddr <= ProgAddr + BranchOffset;
        else ProgAddr <= ProgAddr + 4;
    end
end

endmodule