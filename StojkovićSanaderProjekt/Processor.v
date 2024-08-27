`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:51:26 07/03/2024 
// Design Name: 
// Module Name:    Processor 
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
module Processor(
	input clk_sporki, rst_sporki, clk50,
	input [3:0] adr, // 4 sklopke
	output [7:0] d_out, // 8 ledica 
	output[3:0] pc_out
    );

	parameter LOAD = 4'b0010, ADD = 4'b0001, STORE = 4'b0011, LOADC = 4'b0100, 
             XOR = 4'b0101, AND = 4'b0110, SHL = 4'b0111, SHR = 4'b1000, ADDI=4'b1001;
	reg [3:0] PC = 0;
	wire [7:0] acc, dr_out;
	wire [9:0] ir1_wire;
	reg data_WE = 0;
	reg [7:0] OP1, OP2, ACC, dr_in;
	reg [9:0] IR1, IR2, IR3;
	reg [7:0] REG0, REG1, REG2, REG3;
	wire clk, rst;
	
	
	ALU alu_unit(.operand1(OP1), .operand2(OP2), .mode(IR2[9:6]), .out(acc));
	PMem prog_mem(.addr(PC), .instr(ir1_wire));
	DMem data_mem(.WE(data_WE), .clk(clk), .addr(ACC), .DI(dr_in), .DO(dr_out), .dout(d_out), .doutadr(adr));
	debounce debounce1(clk_sporki, clk50, clk);
	debounce debounce2(rst_sporki, clk50, rst);

	

	// FETCH(getting instruction from adress in PC)
	always@(posedge clk) begin
		if (rst)
			PC <= 0;
		if (PC < 15) 
			PC <= PC + 1;
		IR1 <= ir1_wire;
	end

	// DECODE(based on opcode getting the operands from instr)
	always@(posedge clk) begin
		case(IR1[9:6])
			LOAD : 	begin
							OP1 <= IR1[3:0];
							IR2 <= IR1;
						end
			STORE : 	begin
							OP1 <= IR1[3:0];
							IR2 <= IR1;
						end
			LOADC : 	begin
							OP1 <= IR1[3:0];
							IR2 <= IR1;
						end
			ADD : 	begin
							case(IR1[3:2]) 
								0 : OP1 <= REG0;
								1 : OP1 <= REG1;
								2 : OP1 <= REG2;
								3 : OP1 <= REG3;
							endcase
							case(IR1[1:0]) 
								0 : OP2 <= REG0;
								1 : OP2 <= REG1;
								2 : OP2 <= REG2;
								3 : OP2 <= REG3;
							endcase
							IR2 <= IR1;
						end
			XOR : 	begin
                     case(IR1[3:2]) 
                        0 : OP1 <= REG0;
                        1 : OP1 <= REG1;
                        2 : OP1 <= REG2;
                        3 : OP1 <= REG3;
                     endcase
                     case(IR1[1:0])
                        0 : OP2 <= REG0;
                        1 : OP2 <= REG1;
                        2 : OP2 <= REG2;
                        3 : OP2 <= REG3;
                     endcase
                     IR2 <= IR1;
                  end
			AND : 	begin
                     case(IR1[3:2]) 
                        0 : OP1 <= REG0;
                        1 : OP1 <= REG1;
                        2 : OP1 <= REG2;
                        3 : OP1 <= REG3;
                     endcase
                     case(IR1[1:0]) 
                        0 : OP2 <= REG0;
                        1 : OP2 <= REG1;
                        2 : OP2 <= REG2;
                        3 : OP2 <= REG3;
                     endcase
                     IR2 <= IR1;
                  end
         SHL : 	begin
                     case(IR1[3:2]) 
                        0 : OP1 <= REG0;
                        1 : OP1 <= REG1;
                        2 : OP1 <= REG2;
                        3 : OP1 <= REG3;
                     endcase
                   /*case(IR1[1:0])
                        0 : OP2 <= REG0;
                        1 : OP2 <= REG1;
                        2 : OP2 <= REG2;
                        3 : OP2 <= REG3;
                     endcase*/
							 IR2 <= IR1;
                   end
			SHR : 	begin
                     case(IR1[3:2]) 
                        0 : OP1 <= REG0;
                        1 : OP1 <= REG1;
                        2 : OP1 <= REG2;
                        3 : OP1 <= REG3;
                     endcase
                   /*case(IR1[1:0])
                        0 : OP2 <= REG0;
                        1 : OP2 <= REG1;
                        2 : OP2 <= REG2;
                        3 : OP2 <= REG3;
                     endcase*/
                       IR2 <= IR1;
                    end
			ADDI:	begin
						OP1<=IR1[1:0];
						case(IR1[3:2])
							0 : OP2 <= REG0;
							1 : OP2 <= REG1;
							2 : OP2 <= REG2;
							3 : OP2 <= REG3;
						endcase
							IR2 <= IR1;
						end
							
			default : IR2 <= IR1;
		endcase
	end

	// EXECUTE(getting the result from ALU and storing in ase of STORE instr)
	always@(posedge clk) begin
		ACC <= acc;
		IR3 <= IR2;
		if(IR2[9:6] == STORE) begin
			case(IR2[5:4]) 
				0 : dr_in <= REG0;
				1 : dr_in <= REG1;
				2 : dr_in <= REG2;
				3 : dr_in <= REG3;
			endcase
			data_WE <= 1;
		end
		else begin
			data_WE<=0;
			end
	end

	// STORE
	always@(posedge clk) begin
		case(IR3[9:6])
			LOAD : 	begin
							case(IR3[5:4]) 
								0 : REG0 <= dr_out;
								1 : REG1 <= dr_out;
								2 : REG2 <= dr_out;
								3 : REG3 <= dr_out;
							endcase
						end
			STORE : 	begin
							
						end
			ADD : 	begin
							case(IR3[5:4]) 
								0 : REG0 <= ACC;
								1 : REG1 <= ACC;
								2 : REG2 <= ACC;
								3 : REG3 <= ACC;
							endcase
						end
			LOADC : 	begin
							case(IR3[5:4]) 
								0 : REG0 <= ACC;
								1 : REG1 <= ACC;
								2 : REG2 <= ACC;
								3 : REG3 <= ACC;
							endcase
						end
			XOR : begin
                     case(IR3[5:4]) 
                        0 : REG0 <= ACC;
                        1 : REG1 <= ACC;
                        2 : REG2 <= ACC;
                        3 : REG3 <= ACC;
                     endcase
                end
         AND : begin
                     case(IR3[5:4]) 
                        0 : REG0 <= ACC;
                        1 : REG1 <= ACC;
                        2 : REG2 <= ACC;
                        3 : REG3 <= ACC;
                     endcase
               end
         SHL : begin
                      case(IR3[5:4]) 
                         0 : REG0 <= ACC;
                         1 : REG1 <= ACC;
                         2 : REG2 <= ACC;
                         3 : REG3 <= ACC;
                      endcase
               end
         SHR : begin
                      case(IR3[5:4]) 
                         0 : REG0 <= ACC;
                         1 : REG1 <= ACC;
                         2 : REG2 <= ACC;
                         3 : REG3 <= ACC;
                      endcase
               end
			ADDI: begin
							case(IR3[5:4])
								0 : REG0 <= ACC;
								1 : REG1 <= ACC;
								2 : REG2 <= ACC;
								3 : REG3 <= ACC;
							endcase
						end
			default :begin
						end
		endcase
	end


endmodule
