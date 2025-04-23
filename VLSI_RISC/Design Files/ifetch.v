`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:20:19
// Design Name: 
// Module Name: ifetch
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


module ifetch(
	//from pc
	input wire [31:0] pc_addr_i,
	//from rom
	input wire [31:0] rom_inst_i,
	//to rom
	output wire [31:0] if2rom_addr_o,
	output wire [31:0] inst_addr_o,
	output wire [31:0] inst_o
);
	assign if2rom_addr_o = pc_addr_i;
	
	assign inst_addr_o = pc_addr_i;
	
	assign inst_o = rom_inst_i;
	
endmodule