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
module pipeir(pc4,ins,clk,clrn,dpc4,inst,we,reset_ir
    );
	 input [31:0] pc4,ins;
	 input clk,clrn,we,reset_ir;
	 output [31:0] dpc4,inst;
	 wire [31:0] ypc4, yins, rpc4, rins;
	 wire write_ir,write_pc;
	 assign write_ir = reset_ir | (~reset_ir & we);
	 assign write_pc = reset_ir | we;
	 mux2x32 clear_ir_pc(pc4,32'h0,reset_ir,rpc4);
	 mux2x32 clear_ir_ins(ins,32'h0,reset_ir,rins);
	 mux2x32 write_pc_plus4_enable(dpc4,rpc4,write_ir,ypc4);
	 mux2x32 write_instruction_enable(inst,rins,write_ir,yins);
	 dff32 pc_plus4 (ypc4,clk,clrn,dpc4);
	 dff32 instruction (yins,clk,clrn,inst);

endmodule
