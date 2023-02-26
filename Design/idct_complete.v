`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2023 11:40:14 PM
// Design Name: 
// Module Name: idct_complete
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


module idct_complete(
input clk,
input rst,
input s_valid,
input [511:0] data_in,
output [511:0] data_out,
output  m_valid
    );
    wire [2047:0] temp, temp2, temp3;
    wire m_valid_middle;
    reg [2047:0] temp_reg;
    reg m_valid_middle_reg;
    IDCT_top idct_x(clk, rst, {24'b0, data_in[63:56], 24'b0, data_in[55:48], 24'b0, data_in[47:40], 24'b0, data_in[39:32], 24'b0, data_in[31:24], 24'b0, data_in[23:16], 24'b0, data_in[15:8], 24'b0, data_in[7:0]}, s_valid, 4'd11, temp, m_valid_middle);
    IDCT_top idct_y(clk, rst, temp_reg, m_valid_middle_reg, 4'd15, temp3, m_valid);
    genvar i,j;
    // Taking transpose of the row result
    for(i = 0; i<8; i = i + 1)
    begin
        for(j = 0; j<8; j = j + 1)
        begin
            assign temp2[31+(j*32+i*8*32):(j*32+i*8*32)] = temp[31+(i*32+j*8*32):(i*32+j*8*32)]; 
        end
    end
    
    // Taking transpose of the column result
    for(i = 0; i<8; i = i + 1)
    begin
        for(j = 0; j<8; j = j + 1)
        begin
            assign data_out[7+(j*8+i*8*8):(j*8+i*8*8)] = temp3[7+(i*32+j*8*32):(i*32+j*8*32)]; 
        end
    end
    
    always @(posedge clk)
    begin
        temp_reg <= temp2;
        m_valid_middle_reg <= m_valid_middle;
    end
    
endmodule
