`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:16:10
// Design Name: 
// Module Name: ex
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
module ex(
	//from id_ex
	input wire[31:0] inst_i,
	input wire[31:0] inst_addr_i,
	input wire [31:0] op1_i,
	input wire [31:0] op2_i,
	input wire [4:0] rd_addr_i,
	input wire        reg_wen_i,
	input wire [31:0] base_addr_i,
	input wire [31:0] addr_offset_i,
	//to regs
	output reg[4:0]  rd_addr_o,
	output reg[31:0] rd_data_o,
	output reg       rd_wen_o,
	
	//to ctrl
	output reg[31:0] jump_addr_o,
	output reg       jump_en_o,
	output reg       hold_flag_o,
	
	//from mem
	input wire [31:0] mem_rd_data_i,
	
	//to mem
	output reg       mem_wd_req_o,
	output reg [3:0] mem_wd_sel_o,
	output reg [31:0] mem_wd_addr_o,
	output reg [31:0] mem_wd_data_o
	
);
	wire [6:0] opcode;
	wire [4:0] rd;
	wire [2:0] func3;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [6:0] func7;
	wire [11:0] imm1;
	wire [31:0] jump_imm;
	wire        op1_i_equal_op2_i;
	
	wire        op1_i_less_op2_signed;
	wire        op1_i_less_op2_unsigned;
	
	wire [4:0]  shamt;
	wire [32:0] SRA_mask;
	
	
	wire [31:0] op1_i_add_op2_i;
	wire [31:0] op1_i_and_op2_i;
	wire [31:0] op1_i_or_op2_i;
	wire [31:0] op1_i_xor_op2_i;
	wire [31:0] op1_i_shift_left_op2_i;
	wire [31:0] op1_i_shift_right_op2_i;
	wire [31:0] base_addr_and_addr_offset;
	
	wire [1:0] store_index;
	wire [1:0] load_index ;
	
	assign opcode = inst_i[6:0];
	assign rd = inst_i[11:7];
	assign func3 = inst_i[14:12];
	assign rs1 = inst_i[19:15];
	assign rs2 = inst_i[24:20];
	assign func7 = inst_i[31:25];
	assign imm1 = inst_i[31:20];
	assign shamt = inst_i[24:20];
	
//	assign jump_imm = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
	assign op1_i_equal_op2_i = (op1_i == op2_i) ? 1'b1 : 1'b0;
	
	assign op1_i_less_op2_signed = ($signed(op1_i) < $signed(op2_i)) ? 1'b1 : 1'b0;
	assign op1_i_less_op2_unsigned = (op1_i < op2_i) ? 1'b1 : 1'b0;
	
	assign SRA_mask = (32'hffff_ffff) >> op2_i[4:0];
	
	
	assign op1_i_add_op2_i = op1_i + op2_i;
	assign op1_i_and_op2_i = op1_i & op2_i;
	assign op1_i_or_op2_i = op1_i | op2_i;
	assign op1_i_xor_op2_i = op1_i ^ op2_i;
	assign op1_i_shift_left_op2_i = op1_i << op2_i;
	assign op1_i_shift_right_op2_i = op1_i >> op2_i;
	assign base_addr_and_addr_offset = base_addr_i + addr_offset_i;
	
	assign store_index = base_addr_and_addr_offset[1:0];
	assign load_index = base_addr_and_addr_offset[1:0];
	
	
	always@(*)begin
		case(opcode)
			`INST_TYPE_I:begin
			    jump_addr_o = 32'b0;
	            jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
                
				case(func3)
					`INST_ADDI:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_add_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_SLTI:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = {31'b0,op1_i_less_op2_signed};
						rd_wen_o = 1'b1;
					end
					
					`INST_SLTIU:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = {31'b0,op1_i_less_op2_unsigned};
						rd_wen_o = 1'b1;
					end
					
					`INST_XORI:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_xor_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_ORI:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_or_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_ANDI:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_and_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_SLLI:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_shift_left_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_SRI:begin
						if(func7[5] == 1'b1)begin
						    rd_addr_o = rd_addr_i;
						    rd_data_o = (op1_i_shift_right_op2_i) | (({32{op1_i[31]}}) & (~SRA_mask)) ;
						    rd_wen_o = 1'b1;
						end
						else begin
						    rd_addr_o = rd_addr_i;
						    rd_data_o = op1_i_shift_right_op2_i;
						    rd_wen_o = 1'b1;
						end
					end
					
					default:begin
						rd_addr_o = 5'b0;
						rd_data_o = 32'b0;
						rd_wen_o = 1'b0;
					
					end
					
				endcase
			
			end
			
			`INST_TYPE_R_M:begin
			    jump_addr_o = 32'b0;
	            jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
				case(func3)
					`INST_ADD_SUB:begin
						if(func7[5] == 1'b0)begin
							rd_addr_o = rd_addr_i;
							rd_data_o = op1_i_add_op2_i;
							rd_wen_o = 1'b1;
						end
						else begin
							rd_addr_o = rd_addr_i;
							rd_data_o = op1_i - op2_i;
							rd_wen_o = 1'b1;
						end
					end
					
					`INST_SLL:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_shift_left_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_SLT:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = {31'b0,op1_i_less_op2_signed};
						rd_wen_o = 1'b1;
					end
					
					`INST_SLTU:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = {31'b0,op1_i_less_op2_unsigned};
						rd_wen_o = 1'b1;
					end
					
					
					`INST_XOR:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_xor_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_OR:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_or_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_AND:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = op1_i_and_op2_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_SR:begin
						if(func7[5] == 1'b1)begin
							rd_addr_o = rd_addr_i;
							rd_data_o = (op1_i_shift_right_op2_i) | (({32{op1_i[31]}}) & (~SRA_mask)) ;
							rd_wen_o = 1'b1;
						end
						else begin
							rd_addr_o = rd_addr_i;
							rd_data_o = op1_i_shift_right_op2_i;
							rd_wen_o = 1'b1;
						end
					end
					
					default:begin
						rd_addr_o = 5'b0;
						rd_data_o = 32'b0;
						rd_wen_o = 1'b0;
					
					end
					
				endcase
			
			end
			
			`INST_TYPE_B:begin
			    rd_addr_o = 5'b0;
				rd_data_o = 32'b0;
				rd_wen_o = 1'b0;
				mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
			    case(func3)
			        `INST_BEQ:begin
			            jump_addr_o = base_addr_and_addr_offset;
	                    jump_en_o = op1_i_equal_op2_i;
                        hold_flag_o = 1'b0;
			        end
			        `INST_BNE:begin
			            jump_addr_o = base_addr_and_addr_offset;
	                    jump_en_o = ~op1_i_equal_op2_i;
                        hold_flag_o = 1'b0;
			        end
			        
			        `INST_BLT:begin
			            jump_addr_o = base_addr_and_addr_offset;
	                    jump_en_o = op1_i_less_op2_signed;
                        hold_flag_o = 1'b0;
			        end
			        
			        `INST_BGE:begin
			            jump_addr_o = base_addr_and_addr_offset;
	                    jump_en_o = ~op1_i_less_op2_signed;
                        hold_flag_o = 1'b0;
			        end
			        
			        `INST_BLTU:begin
			            jump_addr_o = base_addr_and_addr_offset;
	                    jump_en_o = op1_i_less_op2_unsigned;
                        hold_flag_o = 1'b0;
			        end
			        
			        `INST_BGEU:begin
			            jump_addr_o = base_addr_and_addr_offset;
	                    jump_en_o = ~op1_i_less_op2_unsigned;
                        hold_flag_o = 1'b0;
			        end
			        
			        default:begin
			            jump_addr_o = 32'b0;
	                    jump_en_o = 1'b0;
                        hold_flag_o = 1'b0;
			        end
			    endcase
			end
			
			`INST_TYPE_L:begin
			    jump_addr_o = 32'b0;
	            jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
				case(func3)
					`INST_LW:begin
						rd_addr_o = rd_addr_i;
						rd_data_o = mem_rd_data_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_LH:begin
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
						case(load_index[1])
						    1'b0:begin
						        rd_data_o = {{16{mem_rd_data_i[15]}},mem_rd_data_i[15:0]};
						    end
						    1'b1:begin
						        rd_data_o = {{16{mem_rd_data_i[31]}},mem_rd_data_i[31:16]};
						    end
						    default:begin
						        rd_data_o = 32'b0;
						    end
						endcase
					end
					
					`INST_LB:begin
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
						case(load_index)
						    2'b00:begin
						        rd_data_o = {{24{mem_rd_data_i[7]}},mem_rd_data_i[7:0]};
						    end
						    2'b01:begin
						        rd_data_o = {{24{mem_rd_data_i[15]}},mem_rd_data_i[15:8]};
						    end
						    2'b10:begin
						        rd_data_o = {{24{mem_rd_data_i[23]}},mem_rd_data_i[23:16]};
						    end
						    2'b11:begin
						        rd_data_o = {{24{mem_rd_data_i[31]}},mem_rd_data_i[31:24]};
						    end
						    default:begin
						        rd_data_o = 32'b0;
						    end
						endcase
					end
					
					`INST_LHU:begin
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
						case(load_index[1])
						    1'b0:begin
						        rd_data_o = {16'b0,mem_rd_data_i[15:0]};
						    end
						    1'b1:begin
						        rd_data_o = {16'b0,mem_rd_data_i[31:16]};
						    end
						    default:begin
						        rd_data_o = 32'b0;
						    end
						endcase
					end
					
					`INST_LBU:begin
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
						case(load_index)
						    2'b00:begin
						        rd_data_o = {24'b0,mem_rd_data_i[7:0]};
						    end
						    2'b01:begin
						        rd_data_o = {24'b0,mem_rd_data_i[15:8]};
						    end
						    2'b10:begin
						        rd_data_o = {24'b0,mem_rd_data_i[23:16]};
						    end
						    2'b11:begin
						        rd_data_o = {24'b0,mem_rd_data_i[31:24]};
						    end
						    default:begin
						        rd_data_o = 32'b0;
						    end
						endcase
					end
					
					default:begin
						rd_addr_o = 5'b0;
						rd_data_o = 32'b0;
						rd_wen_o = 1'b0;
					
					end
					
				endcase
			
			end
			
			
			`INST_TYPE_S:begin
			    jump_addr_o = 32'b0;
	            jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                rd_addr_o = 5'b0;
				rd_data_o = 32'b0;
				rd_wen_o = 1'b0;
				case(func3)
					`INST_SW:begin
						mem_wd_req_o = 1'b1;
                        mem_wd_sel_o = 4'b1111;
                        mem_wd_addr_o = base_addr_and_addr_offset;
                        mem_wd_data_o = op2_i;
					end
					
					`INST_SH:begin
					    mem_wd_req_o = 1'b1;
						mem_wd_addr_o = base_addr_and_addr_offset;
						case(store_index[1])
						    1'b0:begin
						        mem_wd_data_o = {16'b0,op2_i[15:0]};
						        mem_wd_sel_o = 4'b0011;
						    end
						    
						    1'b1:begin
						        mem_wd_data_o = {op2_i[15:0],16'b0};
						        mem_wd_sel_o = 4'b1100;
						    end
						    
						    default:begin
						        mem_wd_data_o = 32'b0;
						        mem_wd_sel_o = 4'b0000;
						    end
						endcase
					end
					
					`INST_SB:begin
					    mem_wd_req_o = 1'b1;
						mem_wd_addr_o = base_addr_and_addr_offset;
						case(store_index)
						    2'b00:begin
						        mem_wd_data_o = {24'b0,op2_i[7:0]};
						        mem_wd_sel_o = 4'b0001;
						    end
						    
						    2'b01:begin
						        mem_wd_data_o = {16'b0,op2_i[7:0],8'b0};
						        mem_wd_sel_o = 4'b0010;
						    end
						    
						    2'b10:begin
						        mem_wd_data_o = {8'b0,op2_i[7:0],16'b0};
						        mem_wd_sel_o = 4'b0100;
						    end
						    
						    2'b11:begin
						        mem_wd_data_o = {op2_i[7:0],24'b0};
						        mem_wd_sel_o = 4'b1000;
						    end
						    
						    default:begin
						    
						    end
						endcase
					end
					
					
					default:begin
						mem_wd_req_o = 1'b0;
                        mem_wd_sel_o = 4'b0000;
                        mem_wd_addr_o = 32'b0;
                        mem_wd_data_o = 32'b0;
					
					end
					
				endcase
			
			end
			
			
			
			`INST_JAL:begin
			    rd_addr_o = rd_addr_i;
				rd_data_o = inst_addr_i + 32'd4;
				rd_wen_o = 1'b1;
			    
			    jump_addr_o = base_addr_and_addr_offset;
	            jump_en_o = 1'b1;
                hold_flag_o = 1'b0;
                
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
			end
			
			`INST_JALR:begin
			    rd_addr_o = rd_addr_i;
				rd_data_o = op1_i_add_op2_i;
				rd_wen_o = 1'b1;
			    
			    jump_addr_o = base_addr_and_addr_offset;
	            jump_en_o = 1'b1;
                hold_flag_o = 1'b0;
                
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
			end
			
			`INST_AUIPC:begin
			    rd_addr_o = rd_addr_i;
				rd_data_o = op1_i_add_op2_i;
				rd_wen_o = 1'b1;
			    
			    jump_addr_o = 32'b0;
	            jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
			end
			
			`INST_LUI:begin
			    rd_addr_o = rd_addr_i;
				rd_data_o = op1_i;
				rd_wen_o = 1'b1;
			    
			    jump_addr_o = 32'b0;
	            jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
			
			end
			
			default:begin
				rd_addr_o = 5'b0;
				rd_data_o = 32'b0;
				rd_wen_o = 1'b0;
				
				jump_addr_o = 32'b0;
	            jump_en_o = 1'b0;
                hold_flag_o = 1'b0;
                
                mem_wd_req_o = 1'b0;
                mem_wd_sel_o = 4'b0;
                mem_wd_addr_o = 32'b0;
                mem_wd_data_o = 32'b0;
			
			end
		
		
		endcase
	
	
	
	end
	




endmodule
