`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:40 05/04/2017 
// Design Name: 
// Module Name:    pipepc 
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
module pipepc(npc,clk,clrn,pc,we
    );
	 input [31:0] npc;
	 input clk,clrn,we;
	 output [31:0] pc;
	 
	 wire [31:0] y;
	 mux2x32 write_pc_enable(pc,npc,we,y);
	 dff32 program_counter(y,clk,clrn,pc);   //利用32位的D触发器实现PC
endmodule
