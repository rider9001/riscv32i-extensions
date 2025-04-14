// Zero delay RAM module
// implemented as a test tool for the RSICV32I processor
// Will try implementing a multi-cycle RAM later
// Takes the address of the LSBtye and returns 4 bytes
// Stores all data as bytes, any read lower than 4 is invalid
module zeroDelayRAM #(parameter dataW = 32, parameter RAMAddrSize = 16)
(
    input logic clock, reset,
    input [dataW-1:0] RAMAddr, DataIn,
    input WriteControl,
    output [dataW-1:0] DataOut
);

timeunit 1ns; timeprecision 10ps;

logic [7:0] RAMArray [0:(1<<RAMAddrSize)];

assign DataOut = {RAMArray[RAMAddr - 3], RAMArray[RAMAddr - 2], RAMArray[RAMAddr - 1], RAMArray[RAMAddr]};

always_ff @( posedge clock, posedge reset )
begin
    if (reset)  RAMArray <= '{default: '0};
    else
    begin
        if (WriteControl)
        begin
            RAMArray[RAMAddr - 3] <= DataIn[31:24];
            RAMArray[RAMAddr - 2] <= DataIn[23:16];
            RAMArray[RAMAddr - 1] <= DataIn[15:8];
            RAMArray[RAMAddr] <= DataIn[7:0];
        end
    end
end

endmodule