`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/19 20:05:41
// Design Name: 
// Module Name: dual_ram
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


module dual_ram #(
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
    output wire [DW - 1:0] r_data_o
);
    reg rd_wr_equ_flag;
    wire [31:0] r_data_o_wire;
    reg [31:0] r_data_o_reg;
//    assign rd_wr_equ_flag = (rst && w_en && r_en && w_addr_i == r_addr_i)? 1'b1 : 1'b0;
    
    
    
    assign r_data_o = rd_wr_equ_flag ? r_data_o_reg : r_data_o_wire ;
    
    always@(posedge clk)begin
        if(rst && w_en && r_en && (w_addr_i == r_addr_i))
            rd_wr_equ_flag <= 1'b1;
        else if(rst && r_en)
            rd_wr_equ_flag <= 1'b0;
    end
    
    always@(posedge clk)begin
        if(!rst)
            r_data_o_reg <= 32'b0;
        else
            r_data_o_reg <= w_data_i;
    end
    
    
    dual_ram_temp #(
        .DW(DW),
        .AW(AW),
        .MEM_NUM(MEM_NUM)
    )dual_ram_temp_inst
    (
        .clk(clk),
        .rst(rst),
        .w_en(w_en),
        .w_addr_i(w_addr_i),
        .w_data_i(w_data_i),
        .r_en(r_en),
        .r_addr_i(r_addr_i),
        .r_data_o(r_data_o_wire)
    );
    
    
    
    
    
endmodule
