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


module IDCT2(
input clk,
input rst,
input s_valid,
input [511:0] data_in,
output [511:0] data_out,
output  m_valid
    );
    reg [2047:0] data_in_dct;
    reg total_valid_prev;
    wire [2047:0] temp, temp2, data_in_pad;
    wire m_valid_middle;
    reg [4:0] shift;
    reg [2047:0] temp_reg;
    reg m_valid_middle_reg;
    IDCT_top idct(clk, rst, data_in_dct, s_valid | m_valid_middle_reg, shift, temp, m_valid_middle);
    genvar i,j;
    // Converting input from 512 bits to 2048 bits
    for(i = 0; i<8; i = i + 1)
    begin
        for(j = 0; j<8; j = j + 1)
        begin
            assign data_in_pad[31+(i*32+j*8*32):(i*32+j*8*32)] = {{24{data_in[7+(i*8+j*8*8)]}}, data_in[7+(i*8+j*8*8):(i*8+j*8*8)]};
        end
    end
    
    
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
            assign data_out[7+(j*8+i*8*8):(j*8+i*8*8)] = temp[7+(i*32+j*8*32):(i*32+j*8*32)]; 
        end
    end
    
    always @(posedge clk)
    begin
        if (rst)
        begin
            total_valid_prev <= 0;
            m_valid_middle_reg <= 0;
            shift <= 5'd11;
        end
        
        temp_reg <= temp2;
        if (m_valid_middle) begin
            if (total_valid_prev)
            begin
                m_valid_middle_reg <= 1'd0;
                total_valid_prev <= 1'b0;
            end else begin
                m_valid_middle_reg <= 1'd1;
                total_valid_prev <= 1'b1;
            end
        end else begin
            m_valid_middle_reg <= 1'b0;
        end
    end
    
    always @(*)
    begin
        if (m_valid_middle_reg & total_valid_prev)
        begin
            data_in_dct <= temp_reg;
            shift <= 5'd15;
        end else begin
            data_in_dct <= data_in_pad;
        end
    end
    
    assign m_valid = m_valid_middle & total_valid_prev;
    
endmodule
