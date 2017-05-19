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
	 wire [1:0] dadepen,dbdepen,dsdepen;//�������ð�յĿ����ź�
	 wire [1:0] eadepen,ebdepen;//�������ð�յĿ����ź�
	 wire [1:0] esdepen;//����store�Ŀ����źŵ�exe��
	 wire ldepen;//���loadð�յĹر�дʹ���ź�
	 
	 wire ex_is_uncond, ex_is_cond; //kongzhimaoxian
	 
	 
	 pipepc prog_cnt (npc,clock,resetn,pc,ldepen);//���������PC
	 pipeif if_stage (pcsource,pc,bpc,da,jpc,npc,pc4,ins);//ȡָIF��
	 pipeir inst_reg (pc4,ins,clock,resetn,dpc4,inst,ldepen);//IF����ID��֮��ļĴ�������ָ��Ĵ���IR
	 pipeid id_stage (dpc4,inst,                        //ָ������ID��
	                  wrn,wdi,wwreg,clock,resetn,
							bpc,jpc,pcsource,dwreg,dm2reg,dwmem,
							daluc,da,db,dimm,drn,djal,z,
							em2reg,ern,ldepen,
							ewreg,mwreg,mrn, //����ð�� ����
				         dadepen,dbdepen, //����ð�� ����
							dj,dbeq,dbne,
							ex_is_uncond, ex_is_cond,
							dsdepen); 
	 pipedereg de_reg (dwreg,dm2reg,dwmem,daluc,da,db,dimm,//ID����EXE��֮��ļĴ���
	                   drn,djal,dpc4,clock,resetn,
							 ewreg,em2reg,ewmem,ealuc,ea,eb,eimm,
							 ern0,ejal,epc4,
							 dadepen,dbdepen,eadepen,ebdepen,
							 dj,dbeq,dbne,ej,ebeq,ebne,
							 dsdepen,esdepen);
	 pipeexe exe_stage (ealuc,ea,eb,eimm,ern0,epc4,//ָ��ִ��EXE��
	                    ejal,ern,ealu,z,
							  eadepen,ebdepen, //shujumaoxian
								malu,wdi,
								ej,ebeq,ebne,
								esdepen,ebs,
								ex_is_uncond, ex_is_cond);
	 pipeemreg em_reg (ewreg,em2reg,ewmem,ealu,ebs,ern,clock,resetn,//EXE����MEM��֮��ļĴ���
	                   mwreg,mm2reg,mwmem,malu,mb,mrn);
	 IP_RAM mem_stage(mwmem,malu,mb,clock,mmo);//�洢������MEM��
	 pipemwreg mw_reg (mwreg,mm2reg,mmo,malu,mrn,clock,resetn,//MEM����WB��֮��ļĴ���
	                   wwreg,wm2reg,wmo,walu,wrn);
	 mux2x32 wb_stage (walu,wmo,wm2reg,wdi);//���д��WB����ѡ����д�ص���Դ��ALU�������ݴ洢��
endmodule
