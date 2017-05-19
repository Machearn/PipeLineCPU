`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:19:46 05/18/2017
// Design Name:   pipeidcu
// Module Name:   D:/PipeLineCPU/pipeidcu_tb.v
// Project Name:  pipeline
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeidcu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pipeidcu_tb;

	// Inputs
	reg rsrtequ;
	reg [5:0] func;
	reg [5:0] op;
	reg em2reg;
	reg [4:0] ern;
	reg [4:0] rs;
	reg [4:0] rt;
	reg [4:0] mrn;
	reg ewreg;
	reg mwreg;

	// Outputs
	wire wreg;
	wire m2reg;
	wire wmem;
	wire [4:0] aluc;
	wire regrt;
	wire aluimm;
	wire sext;
	wire [1:0] pcsource;
	wire shift;
	wire jal;
	wire load_depen;
	wire [1:0] a_depen;
	wire [1:0] b_depen;

	// Instantiate the Unit Under Test (UUT)
	pipeidcu uut (
		.rsrtequ(rsrtequ), 
		.func(func), 
		.op(op), 
		.wreg(wreg), 
		.m2reg(m2reg), 
		.wmem(wmem), 
		.aluc(aluc), 
		.regrt(regrt), 
		.aluimm(aluimm), 
		.sext(sext), 
		.pcsource(pcsource), 
		.shift(shift), 
		.jal(jal), 
		.em2reg(em2reg), 
		.ern(ern), 
		.load_depen(load_depen), 
		.rs(rs), 
		.rt(rt), 
		.mrn(mrn), 
		.ewreg(ewreg), 
		.mwreg(mwreg), 
		.a_depen(a_depen), 
		.b_depen(b_depen)
	);

	initial begin
		// Initialize Inputs
		rsrtequ = 0;
		func = 0;
		op = 0;
		em2reg = 0;
		ern = 0;
		rs = 0;
		rt = 0;
		mrn = 0;
		ewreg = 0;
		mwreg = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rsrtequ = 0;
		func = 6'b000010;
		op = 6'b000000;
		em2reg = 0;
		ern = 5'b00001;
		rs = 5'b00001;
		rt = 5'b00101;
		mrn = 0;
		ewreg = 1;
		mwreg = 0;
	end
      
endmodule

