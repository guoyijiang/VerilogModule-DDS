`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: C06
// Create Date: 2017/07/06 10:34:13
// Design Name: GYJ
// Module Name: dds2DA
// 
//////////////////////////////////////////////////////////////////////////////////


module dds2DA#(
    parameter PHASE_W = 32,
    parameter DATA_W = 10,
    parameter TABLE_AW = 16,
    parameter MEM_FILE = "SineTable.dat"
)
(
    input [PHASE_W - 1 : 0] FreqWord, // 
    input [PHASE_W - 1 : 0] PhaseShift,
    input Clock,
    output reg signed [DATA_W - 1 : 0] Out,
    output reg signed [DATA_W - 1 : 0] x,
    output reg signed [DATA_W - 1 : 0] y
);
//f = 100Mhz * step / 2**TABLE_AW

    reg ClkEn;
    reg [6:0]clkCnt;
    always@(posedge Clock)
    begin
      if(clkCnt < 7'd9)
        begin
          ClkEn = 1'b0;
          clkCnt <= clkCnt + 7'd1;   
        end
      else
        begin
          clkCnt <= 7'd0;
          ClkEn = 1'b1; 
        end      
    end
     
    
    reg signed [DATA_W - 1 : 0] sinTable[2 ** TABLE_AW - 1 : 0]; // Sine table ROM
    reg [PHASE_W - 1 : 0] phase; // Phase Accumulater
    wire [PHASE_W - 1 : 0] addr = phase + PhaseShift; // Phase Shift
   
    initial
    begin
        phase = 0; Out = 0;
        $readmemh(MEM_FILE, sinTable); // Initialize the ROM
    end
    
    always@(posedge Clock)
    begin
        if(ClkEn)
            phase <= phase + FreqWord;
    end
   
    always@(posedge Clock)
    begin
        if(ClkEn)
            Out <= sinTable[addr[PHASE_W - 1 : PHASE_W - TABLE_AW]]; // Look up the table
            x   <= sinTable[addr[PHASE_W - 1 : PHASE_W - TABLE_AW]];
            y   <= sinTable[(addr[PHASE_W - 1 : PHASE_W - TABLE_AW] + 32'd16384)%65536];
    end
endmodule
