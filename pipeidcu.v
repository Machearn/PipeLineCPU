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
					 em2reg,ern,load_depen,rs,rt, //load 冒险 参数
					 mrn,ewreg,mwreg,a_depen,b_depen, //数据冒险参数
					 j,beq,bne, //控制冒险 参数
					 ex_is_uncond, ex_is_cond
    );
	 input rsrtequ; 
	 input [5:0] func,op;
	 input em2reg; //load 冒险
	 input [4:0] ern,rs,rt; //load 冒险
	 input [4:0] mrn;
	 input ewreg,mwreg;
	 input ex_is_uncond, ex_is_cond;
	 
	 
	 output wreg,m2reg,wmem,regrt,aluimm,sext,shift,jal;
	 output [4:0] aluc;
	 output [1:0] pcsource;
	 output load_depen; //load 冒险
	 output [1:0] a_depen,b_depen;
	 output j,beq,bne;
	 
	 wire i_add,i_sub,i_mul,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;            //对指令进行译码
	 wire i_addi,i_muli,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
	 
	 wire rs_isreg,rt_isreg;//load 冒险内部变量
	 
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
	 
    ////////////////////////////////////////////控制信号的生成/////////////////////////////////////////////////////////
    assign wreg=(i_add|i_sub|i_mul|i_and|i_or|i_xor|i_sll|           //wreg为1时写寄存器堆中某一寄存器，否则不写
	              i_srl|i_sra|i_addi|i_muli|i_andi|i_ori|i_xori|
					  i_lw|i_lui|i_jal)&(ex_is_uncond|ex_is_cond);
	 assign regrt=i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_lui;    //regrt为1时目的寄存器是rt，否则为rd
	 assign jal=i_jal;                                           //为1时执行jal指令，否则不是
	 assign m2reg=i_lw;  //为1时将存储器数据写入寄存器，否则将ALU结果写入寄存器
	 assign shift=i_sll|i_srl|i_sra;//为1时ALUa输入端使用移位位数
	 assign aluimm=i_addi|i_muli|i_andi|i_ori|i_xori|i_lw|i_lui|i_sw;//为1时ALUb输入端使用立即数
	 assign sext=i_addi|i_muli|i_lw|i_sw|i_beq|i_bne;//为1时符号拓展，否则零拓展
	 assign aluc[4]=i_sra;//ALU的控制码
	 assign aluc[3]=i_sub|i_or|i_ori|i_xor|i_xori| i_srl|i_sra|i_beq|i_bne;//ALU的控制码
	 assign aluc[2]=i_sll|i_srl|i_sra|i_lui;//ALU的控制码
	 assign aluc[1]=i_and|i_andi|i_or|i_ori|i_xor|i_xori|i_beq|i_bne;//ALU的控制码
	 assign aluc[0]=i_mul|i_muli|i_xor|i_xori|i_sll|i_srl|i_sra|i_beq|i_bne;//ALU的控制码

	 assign wmem=i_sw&(ex_is_uncond|ex_is_cond);//为1时写存储器，否则不写
	 assign pcsource[1]=i_jr|i_j|i_jal;//选择下一条指令的地址，00选PC+4,01选转移地址，10选寄存器内地址，11选跳转地址
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
