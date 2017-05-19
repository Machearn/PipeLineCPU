`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:05:57 05/18/2017
// Design Name:   pipeid
// Module Name:   D:/PipeLineCPU/pipeid_tb.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeid
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pipeid_tb;

	// Inputs
	reg [31:0] dpc4;
	reg [31:0] inst;
	reg [4:0] wrn;
	reg [31:0] wdi;
	reg wwreg;
	reg clk;
	reg clrn;
	reg rsrtequ;
	reg em2reg;
	reg [4:0] ern;
	reg ewreg;
	reg mwreg;
	reg [4:0] mrn;

	// Outputs
	wire [31:0] bpc;
	wire [31:0] jpc;
	wire [1:0] pcsource;
	wire wreg;
	wire m2reg;
	wire wmem;
	wire [4:0] aluc;
	wire aluimm;
	wire [31:0] a;
	wire [31:0] b;
	wire [31:0] imm;
	wire [4:0] rn;
	wire shift;
	wire jal;
	wire load_depen;
	wire [1:0] a_depen;
	wire [1:0] b_depen;

	// Instantiate the Unit Under Test (UUT)
	pipeid uut (
		.dpc4(dpc4), 
		.inst(inst), 
		.wrn(wrn), 
		.wdi(wdi), 
		.wwreg(wwreg), 
		.clk(clk), 
		.clrn(clrn), 
		.bpc(bpc), 
		.jpc(jpc), 
		.pcsource(pcsource), 
		.wreg(wreg), 
		.m2reg(m2reg), 
		.wmem(wmem), 
		.aluc(aluc), 
		.aluimm(aluimm), 
		.a(a), 
		.b(b), 
		.imm(imm), 
		.rn(rn), 
		.shift(shift), 
		.jal(jal), 
		.rsrtequ(rsrtequ), 
		.em2reg(em2reg), 
		.ern(ern), 
		.load_depen(load_depen), 
		.ewreg(ewreg), 
		.mwreg(mwreg), 
		.mrn(mrn), 
		.a_depen(a_depen), 
		.b_depen(b_depen)
	);

	initial begin
		// Initialize Inputs
		dpc4 = 0;
		inst = 0;
		wrn = 0;
		wdi = 0;
		wwreg = 0;
		clk = 0;
		clrn = 0;
		rsrtequ = 0;
		em2reg = 0;
		ern = 0;
		ewreg = 0;
		mwreg = 0;
		mrn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

