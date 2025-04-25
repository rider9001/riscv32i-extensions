// Zero delay RAM module testbench
module zeroDelayRAM_stim;

timeunit 1ns; timeprecision 10ps;

parameter CLOCK_P = 100;

logic reset, clock;
// Intial reset
initial begin reset = 0; #10 reset = 1; #10 reset = 0; end

// Clock signal
always begin clock = 0; #(CLOCK_P/2) clock = 1; #(CLOCK_P/2) clock = 0; end

parameter dataW = 32;
parameter RAMAddrSize = 8;

// inputs
logic [RAMAddrSize-1:0] RAMAddr;
logic [dataW-1:0] DataIn, InpWord1, InpWord2;
logic RAMWriteControl;

// outputs
logic [dataW-1:0] RAMOut, OutWord1, OutWord2;

zeroDelayRAM #(dataW, RAMAddrSize) ram1
(
    .reset(reset),
    .clock(clock),
    .RAMAddr(RAMAddr),
    .DataIn(DataIn),
    .InpWord1(InpWord1),
    .InpWord2(InpWord2),
    .RAMWriteControl(RAMWriteControl),
    .RAMOut(RAMOut),
    .OutWord1(OutWord1),
    .OutWord2(OutWord2)
);

initial
begin
    RAMAddr = 0;
    DataIn = 0;
    InpWord1 = 0;
    InpWord2 = 0;
    RAMWriteControl = 0;
    #CLOCK_P
    InpWord1 = 87;
    #CLOCK_P
    DataIn = 55;
    RAMWriteControl = 1;
    #CLOCK_P
    RAMAddr = 8;
    #CLOCK_P
    RAMWriteControl = 0;
    RAMAddr = 64;
    #CLOCK_P
    DataIn = 90;
    RAMWriteControl = 1;
    #CLOCK_P
    DataIn = 91;
    RAMAddr = 68;
    #CLOCK_P
    RAMWriteControl = 0;
    RAMAddr = 64;
    #CLOCK_P
    RAMAddr = 68;
    #CLOCK_P
    $finish;$stop;
end

endmodule