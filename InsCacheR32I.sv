// Instruction cache for 32 bit wide RSICV instructions
// Capable of commanding PC to stall in order to refresh cache
`include "instructionCodesR32I.sv"
module InsCacheR32I #(parameter dataW = 32, parameter CachedIns = 32)
(
    input logic clock, reset,
    input logic [dataW-1:0] ProgAddr,                       // Input program address
    input logic [dataW-1:0] InsReadInp,                     // Incoming instructions from RAM
    output logic InsCacheStall,                             // High when the instruction cache is refreshing and PC must halt
    output logic [dataW-1:0] InsCacheReadAddr,              // Address to read instructions from RAM
    output logic [dataW-1:0] OutputIns                      // Output instruction to decoder
);

timeunit 1ns; timeprecision 10ps;

// Instruction cache
logic [dataW-1:0] InsCache [0:CachedIns-1];

// Absolute instruction addr range limits
// Origin is the start of the range, upper is the highest instruction in cache
logic [dataW-1:0] InsCacheAddrOrigin, InsCacheAddrUpper;
assign InsCacheAddrUpper = InsCacheAddrOrigin + (4 * (CachedIns - 1));

// Index to read from memory cache, derived from ProgAddr
logic [$clog2(CachedIns)-1:0] InsCacheIndx;
// All absolute program addresses are multiples of 4, if not then PC is in an invalid state
assign InsCacheIndx = ((ProgAddr - InsCacheAddrOrigin) >> 2);

// Counter to read and increment over entire range of instruction cache
logic [$clog2(CachedIns)-1:0] InsCacheWriteIndx;
assign InsCacheReadAddr = ProgAddr + (InsCacheWriteIndx * 4);

// Bounds are reset only after the cache has been refreshed
assign InsCacheStall = (ProgAddr < InsCacheAddrOrigin) || (ProgAddr > InsCacheAddrUpper);

// If progAddr is OOB of cached instructions, stall CPU by giving NOP as instruction
// else output the current instruction
assign OutputIns = InsCacheStall ? `NOP : InsCache[InsCacheIndx];

always_ff @( posedge clock, posedge reset )
begin
    // Reset sets the origin to non zero to force a cache read fail and perform an initial reset
    if (reset)
    begin
        InsCacheAddrOrigin = 32'd9999999;
        InsCacheWriteIndx = 0;
        InsCache <= '{default: '0};
    end
    else
    begin
        if (InsCacheStall)
        begin
            if (InsCacheWriteIndx == CachedIns - 1)
            begin
                // Write final instruction
                InsCache[InsCacheWriteIndx] <= InsReadInp;
                // Set new range limits
                InsCacheAddrOrigin <= ProgAddr;
            end
            else
            begin
                // Increment CacheWrite index until cache has been refreshed
                InsCacheWriteIndx <= InsCacheWriteIndx + 1;
                InsCache[InsCacheWriteIndx] <= InsReadInp;
            end
        end
        else InsCacheWriteIndx <= 0;
    end
end

endmodule
