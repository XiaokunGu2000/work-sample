`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:25:18
// Design Name: 
// Module Name: open_risc_v_soc
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


module open_risc_v_soc(
	input wire clk,
	input wire reset_n
);
	wire[31:0] open_risc_v_inst_addr_o;
	wire[31:0] rom_inst_o;
	
	wire       open_risc_v_mem_rd_req_o;
	wire[31:0]open_risc_v_mem_rd_addr_o;
	wire[31:0]            ram_rd_data_o;
    wire       open_risc_v_mem_wd_req_o;
    wire[3:0]  open_risc_v_mem_wd_sel_o;
    wire[31:0]open_risc_v_mem_wd_addr_o;
    wire[31:0]open_risc_v_mem_wd_data_o;

	open_risc_v open_risc_v_inst(
		.clk(clk),
		.reset_n(reset_n),
		.inst_i(rom_inst_o),
		.inst_addr_o(open_risc_v_inst_addr_o),
		
		.mem_rd_req_o(open_risc_v_mem_rd_req_o),
		.mem_rd_addr_o(open_risc_v_mem_rd_addr_o),
		.mem_rd_data_i(ram_rd_data_o),
		
		.mem_wd_req_o(open_risc_v_mem_wd_req_o),
		.mem_wd_addr_o(open_risc_v_mem_wd_addr_o),
		.mem_wd_data_o(open_risc_v_mem_wd_data_o),
		.mem_wd_sel_o(open_risc_v_mem_wd_sel_o)
	);
	ram ram_inst(
	   .clk(clk),
	   .rst(reset_n),
	   .w_en(open_risc_v_mem_wd_sel_o),
	   .w_addr_i(open_risc_v_mem_wd_addr_o),
	   .w_data_i(open_risc_v_mem_wd_data_o),
	   
	   .r_en(open_risc_v_mem_rd_req_o),
	   .r_addr_i(open_risc_v_mem_rd_addr_o),
	   .r_data_o(ram_rd_data_o)   
    );
	
	rom rom_inst(
	   .clk(clk),
	   .rst(reset_n),
	   .w_en(1'b0),
	   .w_addr_i(32'b0),
	   .w_data_i(32'b0),
	   
	   .r_en(1'b1),
	   .r_addr_i(open_risc_v_inst_addr_o),
	   .r_data_o(rom_inst_o)   
    );
    
    


endmodule