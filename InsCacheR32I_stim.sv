// testbench for the instruction cache
// tests refill and indexing
module InsCacheR32I_stim;

timeunit 1ns; timeprecision 10ps;

parameter CLOCK_P = 100;

logic reset, clock;
// Intial reset
initial begin reset = 0; #10 reset = 1; #10 reset = 0; end

// Clock signal
always begin clock = 0; #(CLOCK_P/2) clock = 1; #(CLOCK_P/2) clock = 0; end

parameter dataW = 32;
parameter CachedIns = 8;

// Inputs
logic [dataW-1:0] ProgAddr, InsReadInp;

// Outputs
logic InsCacheStall;
logic [dataW-1:0] InsCacheReadAddr, OutputIns;

InsCacheR32I InsC1(dataW, CachedIns)
(
    .clock(clock),
    .reset(reset),
    .ProgAddr(ProgAddr),
    .InsReadInp(InsReadInp),
    .InsCacheStall(InsCacheStall),
    .InsCacheReadAddr(InsCacheReadAddr),
    .OutputIns(OutputIns)
);

initial
begin
    ProgAddr = 0;
    InsReadInp = 0;
    #CLOCK_P
    InsReadInp = 1;
    #CLOCK_P
    InsReadInp = 2;
    #CLOCK_P
    InsReadInp = 3;
    #CLOCK_P
    InsReadInp = 4;
    #CLOCK_P
    InsReadInp = 5;
    #CLOCK_P
    InsReadInp = 6;
    #CLOCK_P
    InsReadInp = 7;
    #(CLOCK_P*2)
    ProgAddr = 1;
    #CLOCK_P
    ProgAddr = 6;
    #CLOCK_P
    ProgAddr = 4;
    #CLOCK_P
    ProgAddr = 32;
    InsReadInp = 69;
    #(CLOCK_P*10)
    $finish;$stop;
end

endmodule