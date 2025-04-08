// comparison code generator testbench
module conditionalR32I_stim;

timeunit 1ns; timeprecision 10ps;

parameter CLOCK_P = 100;

logic reset, clock;
// Intial reset
initial begin reset = 0; #10 reset = 1; #10 reset = 0; end

// Clock signal
always begin clock = 0; #(CLOCK_P/2) clock = 1; #(CLOCK_P/2) clock = 0; end

parameter dataW = 32;

// inputs
logic signed [dataW-1:0] rs1, rs2;

// outputs
logic EQ, NE, LT, LTU, GE, UGE;

conditionalR32I cond1
(
    .rs1(rs1),
    .rs2(rs2),
    .EQ(EQ),
    .NE(NE),
    .LT(LT),
    .LTU(LTU),
    .GE(GE),
    .UGE(UGE)
);

initial
begin
    rs1 = 0;
    rs2 = 0;
    #CLOCK_P
    rs1 = 6;
    #CLOCK_P
    rs2 = -6;
    #CLOCK_P
end

endmodule