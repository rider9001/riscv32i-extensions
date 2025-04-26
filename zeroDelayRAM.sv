// Zero delay RAM module
// implemented as a test tool for the RSICV32I processor
// RAM is treated as unintialized execpt for 0->prog length on reset
module zeroDelayRAM #(
parameter dataW = 32,
parameter RAMAddrSize = 32,
parameter ROMFile = "no_file_loaded.hex"
)
(
    input logic clock, reset,
    input logic [RAMAddrSize-1:0] RAMAddr,
    input logic [dataW-1:0] DataIn,
    input logic RAMWriteControl,
    output logic [dataW-1:0] RAMOut
);

timeunit 1ns; timeprecision 10ps;

// Byte array to allow nonaligned acsesses
logic [7:0] RAMArray [0:(1<<RAMAddrSize)-1];

// Memory is treated as big endian
assign RAMOut = {>>{RAMArray[RAMAddr], RAMArray[RAMAddr+1], RAMArray[RAMAddr+2], RAMArray[RAMAddr+3]}};

always_ff @( posedge clock, posedge reset )
begin
    if (reset)
    begin
        // Read program memory into RAM
        $readmemh(ROMFile, RAMArray);
    end
    else
    begin
        if (RAMWriteControl)
        begin
            RAMArray[RAMAddr] <= DataIn[31:24];
            RAMArray[RAMAddr+1] <= DataIn[23:16];
            RAMArray[RAMAddr+2] <= DataIn[15:8];
            RAMArray[RAMAddr+3] <= DataIn[7:0];
        end
    end
end

endmodule
