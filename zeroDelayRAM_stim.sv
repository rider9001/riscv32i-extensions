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
parameter RAMAddrSize = 32;
parameter ROMFile = "progR32I.hex";

// inputs
logic [RAMAddrSize-1:0] RAMAddr;
logic [dataW-1:0] DataIn;
logic RAMWriteControl;

// outputs
logic [dataW-1:0] RAMOut;

zeroDelayRAM #(dataW, RAMAddrSize, ROMFile) ram1
(
    .reset(reset),
    .clock(clock),
    .RAMAddr(RAMAddr),
    .DataIn(DataIn),
    .RAMWriteControl(RAMWriteControl),
    .RAMOut(RAMOut)
);

initial
begin
    RAMAddr = 0;
    DataIn = 0;
    RAMWriteControl = 0;
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
