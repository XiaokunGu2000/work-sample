`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/19 20:16:49
// Design Name: 
// Module Name: dual_ram_temp
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


module dual_ram_temp #(
    parameter DW = 32,
    parameter AW = 12,
    parameter MEM_NUM = 4096
)
(
    input wire clk,
    input wire rst,
    input wire w_en,
    input wire [AW - 1:0] w_addr_i,
    input wire [DW - 1:0] w_data_i,
    input wire r_en,
    input wire [AW - 1:0] r_addr_i,
    output reg [DW - 1:0] r_data_o
);
    reg [DW - 1:0] memory[0:MEM_NUM - 1];
    
    always@(posedge clk)begin
        if(rst && r_en)
            r_data_o <= memory[r_addr_i];
    end
    
    always@(posedge clk)begin
        if(rst && w_en)
            memory[w_addr_i] <= w_data_i;
    end
    
    
    
endmodule