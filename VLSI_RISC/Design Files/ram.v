`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/19 20:06:29
// Design Name: 
// Module Name: ram
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


module ram(
    input wire clk,
    input wire rst,
    input wire [3:0] w_en,
    input wire [31:0] w_addr_i,
    input wire [31:0] w_data_i,
    input wire        r_en,
    input wire [31:0] r_addr_i,
    output wire [31:0] r_data_o
    );
    wire [11:0] w_addr = w_addr_i[13:2];
    wire [11:0] r_addr = r_addr_i[13:2];
    
    dual_ram#(
        .DW(8),
        .AW(12),
        .MEM_NUM(4096)
    )ram_byte0
    (
        .clk(clk),
        .rst(rst),
        .w_en(w_en[0]),
        .w_addr_i(w_addr),
        .w_data_i(w_data_i[7:0]),
        .r_en(r_en),
        .r_addr_i(r_addr),
        .r_data_o(r_data_o[7:0])
    );
    
    dual_ram#(
        .DW(8),
        .AW(12),
        .MEM_NUM(4096)
    )ram_byte1
    (
        .clk(clk),
        .rst(rst),
        .w_en(w_en[1]),
        .w_addr_i(w_addr),
        .w_data_i(w_data_i[15:8]),
        .r_en(r_en),
        .r_addr_i(r_addr),
        .r_data_o(r_data_o[15:8])
    );
    
    dual_ram#(
        .DW(8),
        .AW(12),
        .MEM_NUM(4096)
    )ram_byte2
    (
        .clk(clk),
        .rst(rst),
        .w_en(w_en[2]),
        .w_addr_i(w_addr),
        .w_data_i(w_data_i[23:16]),
        .r_en(r_en),
        .r_addr_i(r_addr),
        .r_data_o(r_data_o[23:16])
    );
    
    dual_ram#(
        .DW(8),
        .AW(12),
        .MEM_NUM(4096)
    )ram_byte3
    (
        .clk(clk),
        .rst(rst),
        .w_en(w_en[3]),
        .w_addr_i(w_addr),
        .w_data_i(w_data_i[31:24]),
        .r_en(r_en),
        .r_addr_i(r_addr),
        .r_data_o(r_data_o[31:24])
    );
endmodule
