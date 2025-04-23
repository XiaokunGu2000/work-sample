`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:19:28
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
	input wire clk,
	input wire rst,
	input wire[31:0] jump_addr_i,
	input wire       jump_en,
	output reg[31:0] pc_o
);
	always@(posedge clk)begin
		if(rst == 1'b0)
			pc_o <= 32'b0;
		else if(jump_en)
		    pc_o <= jump_addr_i;
		else
			pc_o <= pc_o + 3'd4;
	
	end
	


endmodule
