//////////////////////////////////////////////////////////////////////////////////
// Module Name: IDCT
// Description: Inverse Discrete Transform Module
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module IDCT2(
    input clk,
    input rst,
    input s_valid,
    input [1023:0] data_in,
    output reg[511:0] data_out,
    output reg m_valid
);
    reg [2047:0] data_in_dct;
    reg total_valid_prev;
    wire [2047:0] temp, temp2, data_in_pad;
    wire m_valid_middle;
    wire[511:0] data_out_signal;
    wire m_valid_signal;
    reg [4:0] shift;
    reg [2047:0] temp_reg;
    reg m_valid_middle_reg;
    
    genvar i,j;

    IDCT_top idct(clk, rst, data_in_dct, s_valid | m_valid_middle_reg, shift, temp, m_valid_middle);
    
    // Converting input from 512 bits to 2048 bits
    for(i = 0; i<8; i = i + 1)
    begin
        for(j = 0; j<8; j = j + 1)
        begin
            assign data_in_pad[31+(i*32+j*8*32):(i*32+j*8*32)] = {{16{data_in[15+(i*16+j*16*8)]}}, data_in[15+(i*16+j*16*8):(i*16+j*16*8)]};
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
            assign data_out_signal[7+(j*8+i*8*8):(j*8+i*8*8)] = temp[7+(i*32+j*8*32):(i*32+j*8*32)]; 
        end
    end
    
    always @(posedge clk) begin
        if (rst) begin
            total_valid_prev <= 0;
            shift <= 5'd11;
            m_valid_middle_reg <= 0;
            data_out <= 512'b0;
            m_valid <= 1'b0;
        end else begin
            m_valid <= m_valid_signal;
            if(m_valid_signal) begin
                data_out <= data_out_signal;
                shift <= 5'd11;
            end
        
            temp_reg <= temp2;
            if (m_valid_middle) begin
                total_valid_prev <= !total_valid_prev;
                m_valid_middle_reg <= !total_valid_prev;
                if(!total_valid_prev)
                    shift <= 5'd15;
            end else begin
                m_valid_middle_reg <= 1'b0;
            end
        end
    end
    
    always @(*) begin
        if (m_valid_middle_reg & total_valid_prev) begin
            data_in_dct <= temp_reg;
        end else begin
            data_in_dct <= data_in_pad;
        end
    end
    
    assign m_valid_signal = m_valid_middle & total_valid_prev;
    
endmodule
