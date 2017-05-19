`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:17 05/04/2017 
// Design Name: 
// Module Name:    pipeid 
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
module pipeid(dpc4,inst,wrn,
              wdi,wwreg,clk,clrn,bpc,jpc,pcsource,
				  wreg,m2reg,wmem,aluc,a,b,imm,rn,
				  jal,rsrtequ,
				  em2reg,ern,load_depen, //load ð�� ����
				  ewreg,mwreg,mrn, //����ð�� ����
				  a_depen,b_depen, //����ð�� ����
				  j,beq,bne,
				  ex_is_uncond, ex_is_cond,
				  store_depen
    );
	 input [31:0] dpc4,inst,wdi;
	 input [4:0] wrn;
	 input wwreg;
	 input clk,clrn;
	 input rsrtequ;
	 input em2reg; //load ð������
	 input [4:0] ern; //load ð������
	 input [4:0] mrn; //����ð������
	 input ewreg,mwreg; //����ð������
	 input ex_is_uncond, ex_is_cond;
	 
	 output [31:0] bpc,jpc,a,b,imm;
	 output [4:0] rn;
	 output [4:0] aluc;
	 output [1:0] pcsource;
	 output wreg,m2reg,wmem,jal;
	 output load_depen; //load ð�����
	 output [1:0] a_depen,b_depen; //����ð�����
	 output j,beq,bne;
	 output [1:0] store_depen;
	 
	 
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd;
	 wire [31:0] qa,qb,br_offset;
	 wire [15:0] ext16;
	 wire regrt,sext,e;
	 
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 assign jpc={dpc4[31:28],inst[25:0],2'b00};//jump,jalָ���Ŀ���ַ�ļ���
	 
	 pipeidcu cu(rsrtequ,func,                          //���Ʋ���
	             op,wreg,m2reg,wmem,aluc,regrt,
					 sext,pcsource,jal,
					 em2reg,ern,load_depen,rs,rt,
					 mrn,ewreg,mwreg,a_depen,b_depen,
					 j,beq,bne,
					 ex_is_uncond, ex_is_cond,
					 store_depen);
    regfile rf (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb);//�Ĵ����ѣ���32��32λ�ļĴ�����0�żĴ�����Ϊ0
	 mux2x5 des_reg_no (rd,rt,regrt,rn); //ѡ��Ŀ�ļĴ�����������rd,����rt
	 assign a=qa;
	 assign b=qb;
	 assign e=sext&inst[25];//������չ��0��չ
	 assign ext16={16{e}};//������չ
	 assign imm={ext16,inst[25:10]};//�����������з�����չ
	 assign br_offset={imm[29:0],2'b00};
	 cla32 br_addr (dpc4,br_offset,1'b0,bpc);//beq,bneָ���Ŀ���ַ�ļ���
	 

endmodule
