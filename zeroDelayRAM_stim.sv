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
logic [dataW-1:0] DataIn, UsrInpData1, UsrInpData2;
logic WriteControl;

// outputs
logic [dataW-1:0] DataOut, UsrOutData1, UsrOutData2;

zeroDelayRAM #(dataW, RAMAddrSize) ram1
(
    .reset(reset),
    .clock(clock),
    .RAMAddr(RAMAddr),
    .DataIn(DataIn),
    .UsrInpData1(UsrInpData1),
    .UsrInpData2(UsrInpData2),
    .WriteControl(WriteControl),
    .DataOut(DataOut),
    .UsrOutData1(UsrOutData1),
    .UsrOutData2(UsrOutData2)
);

initial
begin
    RAMAddr = 0;
    DataIn = 0;
    UsrInpData1 = 0;
    UsrInpData2 = 0;
    WriteControl = 0;
    #CLOCK_P
    UsrInpData1 = 87;
    #CLOCK_P
    DataIn = 55;
    WriteControl = 1;
    #CLOCK_P
    RAMAddr = 8;
    #CLOCK_P
    WriteControl = 0;
    RAMAddr = 64;
    #CLOCK_P
    DataIn = 90;
    WriteControl = 1;
    #CLOCK_P
    DataIn = 91;
    RAMAddr = 68;
    #CLOCK_P
    WriteControl = 0;
    RAMAddr = 64;
    #CLOCK_P
    RAMAddr = 68;
    #CLOCK_P
    $finish;$stop;
end

endmodule