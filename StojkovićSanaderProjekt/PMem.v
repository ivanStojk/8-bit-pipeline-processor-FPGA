`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:38 07/03/2024 
// Design Name: 
// Module Name:    PMem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PMem(
	input [3:0] addr,
	output [9:0] instr
    );

	reg [9:0] prog_mem [0:15];
	
	initial begin
		$readmemb("p53", prog_mem);
	end
	
	assign instr = prog_mem[addr];

endmodule

