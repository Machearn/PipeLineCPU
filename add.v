`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:02 05/04/2017 
// Design Name: 
// Module Name:    add 
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
module add(a,b,c,g,p,s
    );
	 input a,b,c;
	 output g,p,s;
	 assign s=a^b^c;
	 assign g=a&b;
	 assign p=a|b;
endmodule