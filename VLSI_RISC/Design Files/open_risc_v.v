`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:24:41
// Design Name: 
// Module Name: open_risc_v
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module open_risc_v(
	input wire clk,
	input wire reset_n,
	input wire [31:0] inst_i,
	output wire [31:0] inst_addr_o,
	
	output wire        mem_rd_req_o,
	output wire [31:0] mem_rd_addr_o,
	input wire [31:0] mem_rd_data_i,
	
	output wire        mem_wd_req_o,
	output wire [31:0] mem_wd_addr_o,
	output wire [31:0] mem_wd_data_o,
	output wire [3:0]  mem_wd_sel_o
);
	// pc to Rom/if id
	wire [31:0] pc_reg_pc_out;
	assign inst_addr_o = pc_reg_pc_out;

	//rom rom_inst(
	//	.inst_addr_i(),
	//	.inst_o()
	//);
	
	//if to if_id

	
	//if_id to id
	wire [31:0] if_id_inst_addr_o;
	wire [31:0] if_id_inst_o;
	
	//id to id_ex
	wire[4:0] id_rs1_addr_o;
	wire[4:0] id_rs2_addr_o;
	wire[31:0] id_inst_o;
	wire[31:0]id_inst_addr_o;
	wire[31:0]id_op1_o;
	wire[31:0]id_op2_o;
	wire[4:0]id_rd_addr_o;
	wire id_reg_wen;
	wire [31:0] id_base_addr_o;
	wire [31:0] id_addr_offset_o;
	
	//regs to id
	wire [31:0] reg_reg1_rdata_o;
	wire [31:0] reg_reg2_rdata_o;
	
	//id_ex to ex
	wire [31:0] id_ex_inst_o;
	wire [31:0]id_ex_inst_addr_o;
	wire [31:0]id_ex_op1_o;
	wire [31:0]id_ex_op2_o;
	wire [4:0]id_ex_rd_addr_o;
	wire id_ex_reg_wen;
	wire [31:0] id_ex_base_addr_o;
	wire [31:0] id_ex_addr_offset_o;
	
	//ex to regs
	wire [4:0] ex_rd_addr_o;
	wire [31:0] ex_rd_data_o;
	wire       ex_rd_wen_o;
	
	//ex to ctrl
	wire [31:0] ex_jump_addr_o;
	wire        ex_jump_en_o;
	wire        ex_hold_flag_o;
	
	//ctrl to pcreg
	wire [31:0] ctrl_jump_addr_o;
	wire        ctrl_jump_en_o;
	//ctrl to if_id id_ex
	wire        ctrl_hold_flag_o;
	
	
	pc_reg pc_reg_inst(
		.clk(clk),
		.rst(reset_n),
		.jump_addr_i(ctrl_jump_addr_o),
	    .jump_en(ctrl_jump_en_o),
		.pc_o(pc_reg_pc_out)
	);
	
	
	//if_id to id
	if_id if_id_inst(
		.clk(clk),
		.rst(reset_n),
		.hold_flag_i(ctrl_hold_flag_o),
		.inst_addr_i(pc_reg_pc_out),
		.inst_i(inst_i),
		.inst_addr_o(if_id_inst_addr_o),
		.inst_o(if_id_inst_o)
	);
	
	
		
	id id_inst(
	
		.inst_i(if_id_inst_o),
		.inst_addr_i(if_id_inst_addr_o),
	
	
		.rs1_addr_o(id_rs1_addr_o),
		.rs2_addr_o(id_rs2_addr_o),
	
	
		.rs1_data_i(reg_reg1_rdata_o),
		.rs2_data_i(reg_reg2_rdata_o),
	
	
		.inst_o(id_inst_o),
		.inst_addr_o(id_inst_addr_o),
		.op1_o(id_op1_o),
		.op2_o(id_op2_o),
		.rd_addr_o(id_rd_addr_o),
		.reg_wen(id_reg_wen),
		.base_addr_o(id_base_addr_o),
	    .addr_offset_o(id_addr_offset_o),
	    .mem_rd_req_o(mem_rd_req_o),
	    .mem_rd_addr_o(mem_rd_addr_o)
	);
	
	
	regs regs_inst(
		.clk(clk),
		.rst(reset_n),
	//from id
		.reg1_raddr_i(id_rs1_addr_o),
		.reg2_raddr_i(id_rs2_addr_o),
	//to id
		.reg1_rdata_o(reg_reg1_rdata_o),
		.reg2_rdata_o(reg_reg2_rdata_o),
	//from ex
	
		.reg_waddr_i(ex_rd_addr_o),
		.reg_wdata_i(ex_rd_data_o),
	
		.reg_wen(ex_rd_wen_o)	
	);
	
	
	
	id_ex id_ex_inst(
		.clk(clk),
		.rst(reset_n),

        .hold_flag_i(ctrl_hold_flag_o),

		.inst_i(id_inst_o),
		.inst_addr_i(id_inst_addr_o),
		.op1_i(id_op1_o),
		.op2_i(id_op2_o),
		.rd_addr_i(id_rd_addr_o),
		.reg_wen_i(id_reg_wen),
		.base_addr_i(id_base_addr_o),
	    .addr_offset_i(id_addr_offset_o),

		.inst_o(id_ex_inst_o),
		.inst_addr_o(id_ex_inst_addr_o),
		.op1_o(id_ex_op1_o),
		.op2_o(id_ex_op2_o),
		.rd_addr_o(id_ex_rd_addr_o),
		.reg_wen_o(id_ex_reg_wen),
		.base_addr_o(id_ex_base_addr_o),
	    .addr_offset_o(id_ex_addr_offset_o)
	);
	
	
	
	
	ex ex_inst(
	//from id_ex
		.inst_i(id_ex_inst_o),
		.inst_addr_i(id_ex_inst_addr_o),
		.op1_i(id_ex_op1_o),
		.op2_i(id_ex_op2_o),
		.rd_addr_i(id_ex_rd_addr_o),
		.reg_wen_i(id_ex_reg_wen),
		.base_addr_i(id_ex_base_addr_o),
	    .addr_offset_i(id_ex_addr_offset_o),
		
	//to regs
		.rd_addr_o(ex_rd_addr_o),
		.rd_data_o(ex_rd_data_o),
		.rd_wen_o(ex_rd_wen_o),
		
		.jump_addr_o(ex_jump_addr_o),
	    .jump_en_o(ex_jump_en_o),
	    .hold_flag_o(ex_hold_flag_o),
	    
	    .mem_rd_data_i(mem_rd_data_i),
	    .mem_wd_req_o(mem_wd_req_o),
	    .mem_wd_sel_o(mem_wd_sel_o),
	    .mem_wd_addr_o(mem_wd_addr_o),
	    .mem_wd_data_o(mem_wd_data_o)      
	);	
	
	ctrl ctrl_inst(
	    .jump_addr_i(ex_jump_addr_o),
        .jump_en_i(ex_jump_en_o),
        .hold_flag_ex_i(ex_hold_flag_o),
    
        .jump_addr_o(ctrl_jump_addr_o),
        .jump_en_o(ctrl_jump_en_o),
        .hold_flag_o(ctrl_hold_flag_o)
	);
	
	
endmodule
