`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/14 17:32:14
// Design Name: 
// Module Name: tb
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


module tb();
    reg clk;
	reg rst;
	integer I;
	
	wire [31:0] x3 = tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regss[3];
	wire [31:0] x26 = tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regss[26];
	wire [31:0] x27 = tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regss[27];
	always #10 clk = ~clk;
	
	initial begin
	    I = 0;
		clk <= 1'b1;
		rst <= 1'b0;
		#30;
		rst <= 1'b1;
	end
	
	//ROM
	initial begin
//	    $readmemb("E:/RISC/RISC_MY/inst_data_ADD.txt",tb.open_risc_v_soc_inst.rom_inst.rom_mem);
		
		$readmemh("E:/RISC/RISC_MY/inst_txt/rv32ui-p-sw.txt",tb.open_risc_v_soc_inst.rom_inst.rom_mem.dual_ram_temp_inst.memory);
//	    for (I = 0; I < 4096; I = I + 1)
//            $display("%h",tb.open_risc_v_soc_inst.rom_inst.rom_mem.dual_ram_temp_inst.memory[I]);
	end
	
	initial begin
//		while(1)begin
//			@(posedge clk)
////			$display("x27 register value is %x",tb.open_risc_v_soc_inst.open_risc_v_inst.ex_inst.rd_wen_o);
//			$display("x27 register value is %d",tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regss[27]);
//			$display("x28 register value is %d",tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regss[28]);
//			$display("x29 register value is %d",tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regss[29]);
//			$display("============================");
//			$display("============================");
////			I = I + 1;
//		end
//        #200;
//        $display("%h",tb.open_risc_v_soc_inst.open_risc_v_inst.inst_addr_o);
        wait(x26 == 32'b1);
        
        #1000;
        if(x27 == 32'b1)begin
            $display("############   pass   ############");
        end
        else begin
//            $display("############   fail   ############");
//            for(I = 0 ; I < 31; I = I + 1)begin
//                $display("%2d register value is %d",I,tb.open_risc_v_soc_inst.open_risc_v_inst.regs_inst.regss[I]);
            
//            end
              $display("############   fail   ############");
	    end
	end
	
	open_risc_v_soc open_risc_v_soc_inst(
		.clk(clk),
		.reset_n(rst)
	);
endmodule
