`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:51 07/03/2024 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
	input [7:0] operand1, operand2,
	input [3:0] mode,
	output [7:0] out
    );

	parameter LOAD = 4'b0010, ADD = 4'b0001, STORE = 4'b0011, LOADC = 4'b0100, 
             XOR = 4'b0101, AND = 4'b0110, SHL = 4'b0111, SHR = 4'b1000, ADDI=4'b1001;
	reg [7:0] alu_out;
	
	always @(*) begin
		case(mode)
			4'b0000 : alu_out = 0;
			STORE : alu_out = operand1;
			LOAD : alu_out = operand1;
			LOADC : alu_out = operand1;
			ADD : alu_out = operand1 + operand2;
			XOR : alu_out = operand1 ^ operand2;
         AND :  alu_out = operand1 & operand2;
			ADDI : alu_out = operand1 + operand2; // Immediate value
         SHL : alu_out = operand1 << 1;//operand2
         SHR : alu_out = operand1 >> 1;//operand2
			default : alu_out = 0;
		endcase
	end
	
	assign out = alu_out;

endmodule
