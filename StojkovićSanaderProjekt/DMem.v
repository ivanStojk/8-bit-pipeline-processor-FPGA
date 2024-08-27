`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:17 07/03/2024 
// Design Name: 
// Module Name:    DMem 
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
module DMem(
	input WE, clk,
	input [3:0] addr, doutadr,
	input[7:0]DI,
	output [7:0] DO, dout
    );

	reg [7:0] data_mem [0:15];
	
	
	assign dout = data_mem[doutadr];
	
	initial begin
		$readmemb("initialData1.dat", data_mem);
	end
	
	always @(posedge clk) begin
		if (WE)
			data_mem[addr] <= DI;
	end
	
	assign DO = data_mem[addr];

endmodule
