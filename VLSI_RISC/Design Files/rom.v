`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:15:12
// Design Name: 
// Module Name: rom
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


module rom(
	input wire clk,
	input wire rst,
	input wire w_en,
	input wire [31:0] w_addr_i,
	input wire [31:0] w_data_i,
	
	input wire r_en,
	input wire [31:0] r_addr_i,
	output wire [31:0] r_data_o
	
);
    wire [11:0] w_addr = w_addr_i[13:2];
    wire [11:0] r_addr = r_addr_i[13:2];
	dual_ram#(
	    .DW(32),
	    .AW(12),
	    .MEM_NUM(4096)
	)rom_mem
    (
        .clk(clk),
        .rst(rst),
        .w_en(w_en),
        .w_addr_i(w_addr),
        .w_data_i(w_data_i),
        .r_en(r_en),
        .r_addr_i(r_addr),
        .r_data_o(r_data_o)
    );


endmodule
