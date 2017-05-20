`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:04:11 05/04/2017 
// Design Name: 
// Module Name:    pipeemreg 
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
module pipeemreg(ewreg,em2reg,ewmem,ealu,eb,ern,clk,clrn,
                 mwreg,mm2reg,mwmem,malu,mb,mrn,ex_is_cond,mem_is_cond
    );
	 input [31:0] ealu,eb;
	 input [4:0] ern;
	 input ewreg,em2reg,ewmem;
	 input clk,clrn;
	 input ex_is_cond;
	 output [31:0] malu,mb;
	 output [4:0] mrn;
	 output mwreg,mm2reg,mwmem;
	 output mem_is_cond;
	 reg [31:0] malu,mb;
	 reg [4:0] mrn;
	 reg mwreg,mm2reg,mwmem,mem_is_cond;
	 always @(negedge clrn or posedge clk)
	     if(clrn==0)
		      begin
				    mwreg<=0;    mm2reg<=0;
					 mwmem<=0;    malu<=0;
				    mb<=0;       mrn<=0;      
					 mem_is_cond<=0;
			   end
			else
			    begin
				     mwreg<=ewreg;    mm2reg<=em2reg;
					  mwmem<=ewmem;    malu<=ealu;
				     mb<=eb;       mrn<=ern;
                 mem_is_cond<=ex_is_cond;		  
				 end

endmodule
