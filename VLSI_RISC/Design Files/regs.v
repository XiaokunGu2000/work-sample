`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:21:47
// Design Name: 
// Module Name: regs
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


module regs(
	input wire clk,
	input wire rst,
	//from id
	input wire[4:0] reg1_raddr_i,
	input wire[4:0] reg2_raddr_i,
	//to id
	output reg[31:0] reg1_rdata_o,
	output reg[31:0] reg2_rdata_o,
	//from ex
	
	input wire[4:0] reg_waddr_i,
	input wire[31:0] reg_wdata_i,
	
	input reg_wen	
);
	reg[31:0] regss[0:31];
	integer i;
	
	
	//always@(posedge clk)begin
	always@(*)begin
		if(rst == 1'b0)begin
			reg1_rdata_o = 32'b0;
		end
		else if(reg1_raddr_i == 5'b0)
			reg1_rdata_o = 32'b0;
		else if(reg_wen && reg1_raddr_i == reg_waddr_i)
			reg1_rdata_o = reg_wdata_i; 

		
		else
			reg1_rdata_o = regss[reg1_raddr_i];
	end

	//always@(posedge clk)begin
	always@(*)begin
		if(rst == 1'b0)begin
			reg2_rdata_o = 32'b0;
		end
		else if(reg2_raddr_i == 5'b0)
			reg2_rdata_o = 32'b0;
		else if(reg_wen && reg2_raddr_i == reg_waddr_i)
			reg2_rdata_o = reg_wdata_i; 

		else
			reg2_rdata_o = regss[reg2_raddr_i];
	end
	
	
	always@(posedge clk)begin
		if(rst == 1'b0)begin
			for(i = 0 ; i < 32; i = i + 1)begin
				regss[i] <= 32'b0;
			end
		end
		
		else if(reg_wen && reg_waddr_i != 5'b0)begin
			regss[reg_waddr_i] <= reg_wdata_i;
		end
		
	
	end

endmodule
