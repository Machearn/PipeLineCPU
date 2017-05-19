`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:06:53 05/04/2017 
// Design Name: 
// Module Name:    pipeir 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pipeir(pc4,ins,clk,clrn,dpc4,inst,we
    );
	 input [31:0] pc4,ins;
	 input clk,clrn,we;
	 output [31:0] dpc4,inst;
	 wire [31:0] ypc4, yins;
	 mux2x32 write_pc_plus4_enable(dpc4,pc4,we,ypc4);
	 mux2x32 write_instruction_enable(inst,ins,we,yins);
	 dff32 pc_plus4 (ypc4,clk,clrn,dpc4);
	 dff32 instruction (yins,clk,clrn,inst);
endmodule
