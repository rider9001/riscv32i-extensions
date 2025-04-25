// Zero delay RAM module
// implemented as a test tool for the RSICV32I processor
// Will try implementing a multi-cycle RAM later
// Takes the address of the LSBtye and returns 4 bytes
// Stores all data as bytes, any read lower than 4 is invalid
// First 16 bytes are reserved as hardware async input/output addresses
// 0x0 = Inp1, 0x4 = Inp2, 0x8 = Out1, 0xB = Out2
module zeroDelayRAM #(
parameter dataW = 32,
parameter RAMAddrSize = 32,
parameter ROMFile = "no_file_loaded.hex"
)
(
    input logic clock, reset,
    input logic [RAMAddrSize-1:0] RAMAddr,
    input logic [dataW-1:0] DataIn,
    input logic RAMWriteControl,
    input logic [dataW-1:0] InpWord1, InpWord2,
    output logic [dataW-1:0] RAMOut,
    output logic [dataW-1:0] OutWord1, OutWord2
);

timeunit 1ns; timeprecision 10ps;

// Create version of RAM address shifted into 4 byte per-unit range
logic [RAMAddrSize-1:0] RAMAddrAdj;
assign RAMAddrAdj = RAMAddr>>2;

logic [dataW-1:0] RAMArray [4:((1<<RAMAddrSize)>>2)-1];

always_comb
begin
    case (RAMAddrAdj)
        0: RAMOut = InpWord1;
        1: RAMOut = InpWord2;
        2: RAMOut = OutWord1;
        3: RAMOut = OutWord2;
        default: RAMOut = RAMArray[RAMAddrAdj];
    endcase
end

always_ff @( posedge clock, posedge reset )
begin
    if (reset)
    begin
        // Read program memory into RAM and zero all other memory
        RAMArray <= '{default: '0};
        OutWord1 <= 0;
        OutWord2 <= 0;
        $readmemh(ROMFile, RAMArray);
    end
    else
    begin
        // Writes to input sectors are blocked
        if (RAMWriteControl && RAMAddrAdj > 1)
        begin
            case (RAMAddrAdj)
                2: OutWord1 <= DataIn;
                3: OutWord2 <= DataIn;
                default: RAMArray[RAMAddrAdj] <= DataIn;
            endcase
        end
    end
end

endmodule
