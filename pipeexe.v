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
					eadepen,ebdepen, //����ð��
					malu,wdi,
					ej,ebeq,ebne,
					esdepen,ebs, //store ð��
					ex_is_uncond, ex_is_cond //����ð��
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
	 assign sa={eimm[4:0],eimm[31:5]};//��λλ��������
	 cla32 ret_addr(epc4,32'h4,1'b0,epc8);//��PC+4�ټ�4���PC+8����jal��
	 mux4x32 alu_ina(ea,sa,malu,wdi,eadepen,alua);//ѡ��ALU a�˵�������Դ,���Ҵ�������ð��
	 mux4x32 alu_inb(eb,eimm,malu,wdi,ebdepen,alub);//ѡ��ALU b�˵�������Դ,���Ҵ�������ð��
	 //mux2x32 alu_ina (ea,sa,eshift,alua);//ѡ��ALU a�˵�������Դ
	 //mux2x32 alu_inb (eb,eimm,ealuimm,alub);//ѡ��ALU b�˵�������Դ
	 mux2x32 save_pc8(ealu0,epc8,ejal,ealu);//ѡ�����ALU�������Դ��ejalΪ0ʱ��ALU�ڲ�����Ľ����Ϊ1ʱ��PC+8
	 assign ern=ern0|{5{ejal}};//��jalָ��ִ��ʱ���ѷ��ص�ַд��31�żĴ���
	 alu al_unit (alua,alub,ealuc,ealu0,z);//ALU
	 mux4x32 select_store(eb,32'h0,malu,wdi,esdepen,ebs); //storeð�յĴ���
	 assign ex_is_uncond = ej|ejal;
	 assign ex_is_cond = (z & ebeq) | (~z & ebne);

endmodule
