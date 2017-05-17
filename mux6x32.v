`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:02:12 05/04/2017 
// Design Name: 
// Module Name:    mux6x32 
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
module mux6x32(a0,a1,a2,a3,a4,a5,s,y
    );
	 input [31:0] a0,a1,a2,a3,a4,a5;
	 input [2:0] s;
	 output [31:0] y;
	 function [31:0] select;
	     input [31:0] a0,a1,a2,a3,a4,a5;
	     input [2:0] s;
		  case(s)
		  3'b000:select=a0;
		  3'b001:select=a1;
		  3'b010:select=a2;
		  3'b011:select=a3;
		  3'b100:select=a4;
		  3'b101:select=a5;
		  default:select=a0;
		  endcase
	endfunction
	assign y=select(a0,a1,a2,a3,a4,a5,s);
endmodule
