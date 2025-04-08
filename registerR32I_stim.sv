// RISCV32I register file module testbench
module registerR32I_stim;

timeunit 1ns; timeprecision 10ps;

parameter CLOCK_P = 100;

logic reset, clock;
// Intial reset
initial begin reset = 0; #10 reset = 1; #10 reset = 0; end

// Clock signal
always begin clock = 0; #(CLOCK_P/2) clock = 1; #(CLOCK_P/2) clock = 0; end

parameter dataW = 32;

// inputs
logic RegWriteControl;
logic [dataW-1:0] RegDataIn, RegData1, RegData2, RegWriteAddr;

// outputs
logic [dataW-1:0] RegDataOut1, RegDataOut2;

registerR32I #(dataW) reg1
(
    .clock(clock),
    .reset(reset),
    .RegWriteControl(RegWriteControl),
    .RegDataIn(RegDataIn),
    .RegData1(RegData1),
    .RegData2(RegData2),
    .RegWriteAddr(RegWriteAddr),
    .RegDataOut1(RegDataOut1),
    .RegDataOut2(RegDataOut2)
);

initial
begin
    // Setup
    RegDataIn = 0;
    RegWriteAddr = 0;
    RegWriteControl = 0;
    RegData1 = 0;
    RegData2 = 0;
    #CLOCK_P
    RegWriteAddr = 1;
    RegDataIn = 897;
    #CLOCK_P
    RegData1 = 1;
    RegData2 = 2;
    RegWriteAddr = 2;
    RegDataIn = 666;
    #CLOCK_P
    RegData1 = 0;
    RegWriteAddr = 0;
    #(CLOCK_P*2)
    $finish;$stop;
end

endmodule