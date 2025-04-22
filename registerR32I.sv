// RISCV32I register file module
// implements 32 32-bit general registers
module registerR32I #(parameter dataW = 32)
(
    input logic clock, reset,
    input logic RegWriteControl,                                        // Writeback control signal
    input logic [dataW-1:0] RegDataIn,                                  // RegWriteControl data input
    input logic [$clog2(dataW)-1:0] RegData1, RegData2,                 // Register read index
    input logic [$clog2(dataW)-1:0] RegWriteAddr,                       // Writeback register index
    output logic [dataW-1:0] RegDataOut1, RegDataOut2                   // Outputs for register data at indexes 1 and 2
);

timeunit 1ns; timeprecision 10ps;

// first register is zero reg, all other registers are general purpose
logic [dataW-1:0] RegisterFile [31:1];

always_comb
begin
    case (RegData1)
        0:          RegDataOut1 = 0;
        default:    RegDataOut1 = RegisterFile[RegData1];
    endcase

    case (RegData2)
        0:          RegDataOut2 = 0;
        default:    RegDataOut2 = RegisterFile[RegData2];
    endcase
end

always_ff @(posedge clock, posedge reset)
begin
    if (reset)
    begin
        RegisterFile <= '{default: '0};
    end
    else
    begin
        // Writes are made to register at RegWriteAddr, ban writes to x0 for hardware saftey
        if (RegWriteControl && RegWriteAddr != 0) RegisterFile[RegWriteAddr] <= RegDataIn;
    end
end


endmodule