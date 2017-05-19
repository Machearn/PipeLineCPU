`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:49 05/04/2017 
// Design Name: 
// Module Name:    pipeidcu 
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
module pipeidcu(rsrtequ,func,
	             op,wreg,m2reg,wmem,aluc,regrt,aluimm,
					 sext,pcsource,shift,jal,
					 em2reg,ern,load_depen,rs,rt, //load ð�� ����
					 mrn,ewreg,mwreg,a_depen,b_depen, //����ð�ղ���
					 j,beq,bne, //����ð�� ����
					 ex_is_uncond, ex_is_cond
    );
	 input rsrtequ; 
	 input [5:0] func,op;
	 input em2reg; //load ð��
	 input [4:0] ern,rs,rt; //load ð��
	 input [4:0] mrn;
	 input ewreg,mwreg;
	 input ex_is_uncond, ex_is_cond;
	 
	 
	 output wreg,m2reg,wmem,regrt,aluimm,sext,shift,jal;
	 output [4:0] aluc;
	 output [1:0] pcsource;
	 output load_depen; //load ð��
	 output [1:0] a_depen,b_depen;
	 output j,beq,bne;
	 
	 wire i_add,i_sub,i_mul,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;            //��ָ���������
	 wire i_addi,i_muli,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
	 
	 wire rs_isreg,rt_isreg;//load ð���ڲ�����
	 
	 and(i_add,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],~func[1],func[0]);
	 and(i_sub,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],func[1],~func[0]);
	 and(i_mul,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],func[1],func[0]);
	
	 
	 and(i_and,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],~func[1],func[0]);
	 and(i_or,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],func[1],~func[0]);
	
	 and(i_xor,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],func[2],~func[1],~func[0]);
	 
	 and(i_sra,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],~func[1],func[0]);
	 and(i_srl,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],~func[0]);
	 and(i_sll,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],func[0]);
	 and(i_jr,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],func[2],~func[1],~func[0]);
	 
	 and(i_addi,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);
	
	 and(i_muli,~op[5],~op[4],~op[3],op[2],op[1],op[0]);
	 
	 
	 and(i_andi,~op[5],~op[4],op[3],~op[2],~op[1],op[0]);
	 and(i_ori,~op[5],~op[4],op[3],~op[2],op[1],~op[0]);

	 and(i_xori,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);
	 
	 and(i_lw,~op[5],~op[4],op[3],op[2],~op[1],op[0]);
	 and(i_sw,~op[5],~op[4],op[3],op[2],op[1],~op[0]);
	 and(i_beq,~op[5],~op[4],op[3],op[2],op[1],op[0]);
	 and(i_bne,~op[5],op[4],~op[3],~op[2],~op[1],~op[0]);
	 and(i_lui,~op[5],op[4],~op[3],~op[2],~op[1],op[0]);
	 and(i_j,~op[5],op[4],~op[3],~op[2],op[1],~op[0]);
	 and(i_jal,~op[5],op[4],~op[3],~op[2],op[1],op[0]);
	
	 wire i_rs=i_add|i_sub|i_mul|i_and|i_or|i_xor|i_jr|i_addi|i_muli|           
	           i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne;
	 wire i_rt=i_add|i_sub|i_mul|i_and|i_or|i_xor|i_sra|i_srl|i_sll|i_sw|i_beq|i_bne;
	 
    ////////////////////////////////////////////�����źŵ�����/////////////////////////////////////////////////////////
    assign wreg=(i_add|i_sub|i_mul|i_and|i_or|i_xor|i_sll|           //wregΪ1ʱд�Ĵ�������ĳһ�Ĵ���������д
	              i_srl|i_sra|i_addi|i_muli|i_andi|i_ori|i_xori|
					  i_lw|i_lui|i_jal)&(ex_is_uncond|ex_is_cond);
	 assign regrt=i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_lui;    //regrtΪ1ʱĿ�ļĴ�����rt������Ϊrd
	 assign jal=i_jal;                                           //Ϊ1ʱִ��jalָ�������
	 assign m2reg=i_lw;  //Ϊ1ʱ���洢������д��Ĵ���������ALU���д��Ĵ���
	 assign shift=i_sll|i_srl|i_sra;//Ϊ1ʱALUa�����ʹ����λλ��
	 assign aluimm=i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_lui|i_sw;//Ϊ1ʱALUb�����ʹ��������
	 assign sext=i_addi|i_muli|i_lw|i_sw|i_beq|i_bne;//Ϊ1ʱ������չ����������չ
	 assign aluc[4]=i_sra;//ALU�Ŀ�����
	 assign aluc[3]=i_sub|i_or|i_ori|i_xor|i_xori| i_srl|i_sra|i_beq|i_bne;//ALU�Ŀ�����
	 assign aluc[2]=i_sll|i_srl|i_sra|i_lui;//ALU�Ŀ�����
	 assign aluc[1]=i_and|i_andi|i_or|i_ori|i_xor|i_xori|i_beq|i_bne;//ALU�Ŀ�����
	 assign aluc[0]=i_mul|i_muli|i_xor|i_xori|i_sll|i_srl|i_sra|i_beq|i_bne;//ALU�Ŀ�����

	 assign wmem=i_sw&(ex_is_uncond|ex_is_cond);//Ϊ1ʱд�洢��������д
	 assign pcsource[1]=i_jr|i_j|i_jal;//ѡ����һ��ָ��ĵ�ַ��00ѡPC+4,01ѡת�Ƶ�ַ��10ѡ�Ĵ����ڵ�ַ��11ѡ��ת��ַ
	 assign pcsource[0]=i_beq&rsrtequ|i_bne&~rsrtequ|i_j|i_jal;
	 
	 assign rs_isreg=i_add|i_sub|i_mul|i_and|i_or|i_xor|i_jr|i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne;
	 assign rt_isreg=i_add|i_sub|i_mul|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne|i_lui;
	 
	 wire rs_equ,rt_equ;
	 assign rs_equ = (rs == ern)?1'b1:1'b0;
	 assign rt_equ = (rt == ern)?1'b1:1'b0;
	 wire exe_a_depen,exe_b_depen;
	 and(exe_a_depen,rs_equ,em2reg,rs_isreg);
	 and(exe_b_depen,rt_equ,em2reg,rt_isreg);
	 nor(load_depen,exe_a_depen,exe_b_depen);
	 
	 wire rs_exe_equ,rt_exe_equ,rs_mem_equ,rt_mem_equ;
	 assign rs_exe_equ = (rs == ern)?1'b1:1'b0;
	 assign rt_exe_equ = (rt == ern)?1'b1:1'b0;
	 assign rs_mem_equ = (rs == mrn)?1'b1:1'b0;
	 assign rt_mem_equ = (rt == mrn)?1'b1:1'b0;

    assign a_depen[0] = shift|(~shift && ~ewreg && ~rs_exe_equ && mwreg && rs_mem_equ)|
	                     (~shift && ~ewreg && rs_exe_equ && mwreg && rs_mem_equ)|
								(~shift && ewreg && ~rs_exe_equ && mwreg && rs_mem_equ);

	 assign a_depen[1] = (~shift && ~ewreg && ~rs_exe_equ && mwreg && rs_mem_equ)|
	                     (~shift && ~ewreg && rs_exe_equ && mwreg && rs_mem_equ)|
								(~shift && ewreg && ~rs_exe_equ && mwreg && rs_mem_equ)|
								(~shift && ewreg && rs_exe_equ && mwreg && ~rs_mem_equ)|
								(~shift && ewreg && rs_exe_equ && mwreg && rs_mem_equ)|
								(~shift && ewreg && rs_exe_equ && ~mwreg && ~rs_mem_equ)|
								(~shift && ewreg && rs_exe_equ && ~mwreg && rs_mem_equ);
								
    assign b_depen[0] = aluimm|(~aluimm && ~ewreg && ~rt_exe_equ && mwreg && rt_mem_equ)|
	                     (~aluimm && ~ewreg && rt_exe_equ && mwreg && rt_mem_equ)|
								(~aluimm && ewreg && ~rt_exe_equ && mwreg && rt_mem_equ);

	 assign b_depen[1] = (~aluimm && ~ewreg && ~rt_exe_equ && mwreg && rt_mem_equ)|
	                     (~aluimm && ~ewreg && rt_exe_equ && mwreg && rt_mem_equ)|
								(~aluimm && ewreg && ~rt_exe_equ && mwreg && rt_mem_equ)|
								(~aluimm && ewreg && rt_exe_equ && mwreg && ~rt_mem_equ)|
								(~aluimm && ewreg && rt_exe_equ && mwreg && rt_mem_equ)|
								(~aluimm && ewreg && rt_exe_equ && ~mwreg && ~rt_mem_equ)|
								(~aluimm && ewreg && rt_exe_equ && ~mwreg && rt_mem_equ);
	
	assign j = i_j;
	assign beq = i_beq;
	assign bne = i_bne;
endmodule
