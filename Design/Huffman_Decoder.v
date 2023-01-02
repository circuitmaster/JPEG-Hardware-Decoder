//////////////////////////////////////////////////////////////////////////////////
// Module Name: Huffman Decoder
// Description: Decodes given bit sequences based on the
//              DC and AC tables given as seperate module
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Huffman_Decoder (
    input clk, rst,
    input ac_dc_flag,           //Selects which table will be used for decoding
    input next_bit,             //Next bit from encoded image
    input is_new,               //Indicates if bit input is valid
    output reg [3:0] s_value,   //Run length (Count of zeros before number)
    output reg [3:0] r_value,   //Number length (Bit length of the number after zeros)
    output reg done             //Indicates decoding is done and s-r values are valid
);

    //Internal registers 
    reg ac_dc_flag_reg;     //Select huffman table
    reg [0:15] bit_series;  //Holds bit sequence
    reg [4:0] bit_index;    //Holds index that new bit will be placed
    
    //Internal wires
    wire[3:0] ac_s_value, ac_r_value;
    wire[3:0] dc_s_value, dc_r_value;
    wire ac_is_valid, dc_is_valid;
    
    //Direct AC or DC table results to output depending on the selection
    always @(*)begin
        if(ac_dc_flag_reg == 1'b0) begin
            s_value <= ac_s_value;
            r_value <= ac_r_value;
            done <= ac_is_valid;
        end else begin
            s_value <= dc_s_value;
            r_value <= dc_r_value;
            done <= dc_is_valid;
        end
    end
    
    //Places new bits to empty index and reset when decoding is finished
    always @(posedge clk) begin
        if(rst) begin
            ac_dc_flag_reg <= 1'b0;
            bit_series <= 16'b0;
            bit_index <= 5'b0;
        end else begin
            if(is_new) begin
                if(bit_index == 5'd0 || done) begin
                    ac_dc_flag_reg <= ac_dc_flag;
                    bit_series[0] <= next_bit;
                    bit_index <= 5'd1;
                end else begin
                    bit_series[bit_index] <= next_bit;
                    bit_index <= bit_index + 1;
                end
            end
        end
    end
    
    AC_Huffman_Table ac_huffman_table(
        .bit_series(bit_series),
        .length(bit_index),
        .s_value(ac_s_value),
        .r_value(ac_r_value),
        .is_valid(ac_is_valid)
    );
    
    DC_Huffman_Table dc_huffman_table(
        .bit_series(bit_series),
        .length(bit_index),
        .s_value(dc_s_value),
        .r_value(dc_r_value),
        .is_valid(dc_is_valid)
    );
    
endmodule