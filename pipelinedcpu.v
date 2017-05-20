`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:07:45 05/04/2017 
// Design Name: 
// Module Name:    pipelinedcpu 
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
module pipelinedcpu(clock,resetn,pc,inst,ealu,malu,walu
    );
	 input clock,resetn;
	 output [31:0] pc,inst,ealu,malu,walu;
	 wire [31:0] bpc,jpc,npc,pc4,ins,dpc4,inst,da,db,dimm,ea,eb,eimm;
	 wire [31:0] epc4,mb,mmo,wmo,wdi;
	 wire [31:0] ebs;
	 wire [4:0] drn,ern0,ern,mrn,wrn;
	 wire [4:0] daluc,ealuc;
	 wire [1:0] pcsource;
	 wire dwreg,dm2reg,dwmem,daluimm,dshift,djal;
	 wire ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
	 wire mwreg,mm2reg,mwmem;
	 wire wwreg,wm2reg;
	 wire z;
	 wire dj,dbeq,dbne;
	 wire ej,ebeq,ebne;
	 wire [1:0] dadepen,dbdepen,dsdepen;//添加数据冒险的控制信号
	 wire [1:0] eadepen,ebdepen;//添加数据冒险的控制信号
	 wire [1:0] esdepen;//传递store的控制信号到exe级
	 wire we_pc_ir;//添加关闭写使能信号,包括load冒险和beq,bne的后面的第一个周期
	 wire reset_ir;
	 wire [31:0] dbpc;
	 
	 wire ex_is_uncond, ex_is_cond, mem_is_cond; //kongzhimaoxian
	 
	 
	 pipepc prog_cnt (npc,clock,resetn,pc,we_pc_ir);//程序计数器PC
	 pipeif if_stage (pcsource,pc,bpc,da,jpc,npc,pc4,ins);//取指IF级
	 pipeir inst_reg (pc4,ins,clock,resetn,dpc4,inst,we_pc_ir,reset_ir);//IF级与ID级之间的寄存器，即指令寄存器IR
	 pipeid id_stage (dpc4,inst,                        //指令译码ID级
	                  wrn,wdi,wwreg,clock,resetn,
							dbpc,jpc,pcsource,dwreg,dm2reg,dwmem,
							daluc,da,db,dimm,drn,djal,z,
							em2reg,ern,we_pc_ir,
							ewreg,mwreg,mrn, //数据冒险 参数
				         dadepen,dbdepen, //数据冒险 参数
							dj,dbeq,dbne,
							ex_is_uncond, ex_is_cond, mem_is_cond,
							dsdepen,
							reset_ir); 
	 pipedereg de_reg (dwreg,dm2reg,dwmem,daluc,da,db,dimm,//ID级与EXE级之间的寄存器
	                   drn,djal,dpc4,clock,resetn,
							 ewreg,em2reg,ewmem,ealuc,ea,eb,eimm,
							 ern0,ejal,epc4,
							 dadepen,dbdepen,eadepen,ebdepen,
							 dj,dbeq,dbne,ej,ebeq,ebne,
							 dsdepen,esdepen,
							 dbpc,bpc);
	 pipeexe exe_stage (ealuc,ea,eb,eimm,ern0,epc4,//指令执行EXE级
	                    ejal,ern,ealu,z,
							  eadepen,ebdepen, //shujumaoxian
								malu,wdi,
								ej,ebeq,ebne,
								esdepen,ebs,
								ex_is_uncond, ex_is_cond);
	 pipeemreg em_reg (ewreg,em2reg,ewmem,ealu,ebs,ern,clock,resetn,//EXE级与MEM级之间的寄存器
	                   mwreg,mm2reg,mwmem,malu,mb,mrn,ex_is_cond,mem_is_cond);
	 IP_RAM mem_stage(mwmem,malu,mb,clock,mmo);//存储器访问MEM级
	 pipemwreg mw_reg (mwreg,mm2reg,mmo,malu,mrn,clock,resetn,//MEM级与WB级之间的寄存器
	                   wwreg,wm2reg,wmo,walu,wrn);
	 mux2x32 wb_stage (walu,wmo,wm2reg,wdi);//结果写回WB级，选择结果写回的来源是ALU还是数据存储器
endmodule
