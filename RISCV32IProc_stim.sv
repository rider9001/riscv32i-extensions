// RISCV32I processor testbench
module RISCV32IProc_stim;

timeunit 1ns; timeprecision 10ps;

parameter CLOCK_P = 100;

logic reset, clock;
// Intial reset
initial begin reset = 0; #10 reset = 1; #10 reset = 0; end

// Clock signal
always begin clock = 0; #(CLOCK_P/2) clock = 1; #(CLOCK_P/2) clock = 0; end

parameter dataW = 32;
parameter RAMAddrSize = 32;
parameter CachedIns = 32;
parameter ROMFile = "progR32I.hex"

// inputs
logic [dataW-1:0] InpWord1, InpWord2;

// outputs
logic [dataW-1:0] OutWord1, OutWord2;

// definition
RISCV32IProc #(dataW, RAMAddrSize, CachedIns, ROMFile) proc1
(
    .clock(clock),
    .reset(reset),
    .InpWord1(InpWord1),
    .InpWord2(InpWord2),
    .OutWord1(OutWord1),
    .OutWord2(OutWord2)
);

initial
begin
    InpWord1 = 0;
    InpWord2 = 0;
    #(CLOCK_P*32)
    $finish;$stop;
end

endmodule