// Sign extender for RSICV32I instruction immeidates
module signExtender
(
    input logic sign,
    output logic [19:0] IStypeSign,     // 20 bit wide sign
    output logic [18:0] BTypeSign,      // 19 bit wide sign
    output logic [10:0] JTypeSign       // 11 bit wide sign
);

timeunit 1ns; timeprecision 10ps;

assign IStypeSign = sign ? 20'b1111_1111_1111_1111_1111 : 20'b0;
assign BtypeSign = sign ? 19'b111_1111_1111_1111_1111 : 19'b0;
assign JTypeSign = sign ? 11'b1111_1111_111 : 11'b0;

endmodule
