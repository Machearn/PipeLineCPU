`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:04:47 05/04/2017 
// Design Name: 
// Module Name:    pipeexe 
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
module pipeexe(ealuc,ea,eb,eimm,ern0,epc4,ejal,ern,ealu,z,
					eadepen,ebdepen, //数据冒险
					malu,wdi,
					ej,ebeq,ebne,
					esdepen,ebs, //store 冒险
					ex_is_uncond, ex_is_cond //控制冒险
    );
	 input [31:0] ea,eb,eimm,epc4;
	 input [4:0] ern0;
	 input [4:0] ealuc;
	 input ejal;
	 input [1:0] eadepen,ebdepen,esdepen;
	 input [31:0] malu,wdi;
	 input ej,ebeq,ebne;
	 
	 output [31:0] ealu;
	 output [4:0] ern;
	 output [31:0] ebs;
	 wire [31:0] alua,alub,sa,ealu0,epc8;
	 wire ex_is_uncond, ex_is_cond;
	 output z;
	 output ex_is_uncond, ex_is_cond;
	 assign sa={eimm[4:0],eimm[31:5]};//移位位数的生成
	 cla32 ret_addr(epc4,32'h4,1'b0,epc8);//将PC+4再加4变成PC+8，供jal用
	 mux4x32 alu_ina(ea,sa,malu,wdi,eadepen,alua);//选择ALU a端的数据来源,并且处理数据冒险
	 mux4x32 alu_inb(eb,eimm,malu,wdi,ebdepen,alub);//选择ALU b端的数据来源,并且处理数据冒险
	 //mux2x32 alu_ina (ea,sa,eshift,alua);//选择ALU a端的数据来源
	 //mux2x32 alu_inb (eb,eimm,ealuimm,alub);//选择ALU b端的数据来源
	 mux2x32 save_pc8(ealu0,epc8,ejal,ealu);//选择最后ALU结果的来源，ejal为0时是ALU内部算出的结果，为1时是PC+8
	 assign ern=ern0|{5{ejal}};//当jal指令执行时，把返回地址写入31号寄存器
	 alu al_unit (alua,alub,ealuc,ealu0,z);//ALU
	 mux4x32 select_store(eb,32'h0,malu,wdi,esdepen,ebs); //store冒险的处理
	 assign ex_is_uncond = ej|ejal;
	 assign ex_is_cond = (z & ebeq) | (~z & ebne);

endmodule
