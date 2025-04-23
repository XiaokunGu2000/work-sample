`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:21:08
// Design Name: 
// Module Name: if_id
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


`include "defines.v"


module if_id(
	input wire clk,
	input wire rst,
	
	input wire        hold_flag_i,
	
	input wire [31:0] inst_addr_i,
	input wire [31:0] inst_i,
	output wire [31:0] inst_addr_o,
	output wire [31:0] inst_o
);
	reg inst_valid_flag;
	
	always@(posedge clk)begin
	    if(!rst | hold_flag_i)
	        inst_valid_flag <= 1'b0;
	    else
	        inst_valid_flag <= 1'b1;
	end
	
	assign inst_o =  (inst_valid_flag == 1'b1) ? inst_i : `INST_NOP;
	dff_set #(32) dff2(clk,rst,hold_flag_i,32'b0, inst_addr_i,inst_addr_o);
endmodule
