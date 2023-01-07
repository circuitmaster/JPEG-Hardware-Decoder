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
    reg [7:0] state;
    
    //Internal wires
    wire[3:0] ac_s_value, ac_r_value;
    wire[3:0] dc_s_value, dc_r_value;
    wire ac_is_valid, dc_is_valid;
    wire [7:0] ac_next_state;
    wire [3:0] dc_next_state;
    
    //Direct AC or DC table results to output depending on the selection
    always @(*)begin
        if(ac_dc_flag == 1'b0) begin
            s_value <= ac_s_value;
            r_value <= ac_r_value;
            done <= ac_next_state == 8'b0 ? 1'b1 : 1'b0;
        end else begin
            s_value <= dc_s_value;
            r_value <= dc_r_value;
            done <= dc_next_state[3:0] == 4'b0 ? 1'b1 : 1'b0;
        end
    end
    
    //Places new bits to empty index and reset when decoding is finished
    always @(posedge clk) begin
        if(rst) begin
            state <= 8'b0;
        end else begin
            if(is_new) begin
                if(ac_dc_flag == 1'b0)
                    state <= ac_next_state;
                else
                    state[3:0] <= dc_next_state;
            end
        end
    end
    
    AC_Huffman_Table ac_huffman_table(
        .bit(next_bit),
        .state(state),
        .s_value(ac_s_value),
        .r_value(ac_r_value),
        .next_state(ac_next_state)
    );
    
    DC_Huffman_Table dc_huffman_table(
        .bit(next_bit),
        .state(state[3:0]),
        .s_value(dc_s_value),
        .r_value(dc_r_value),
        .next_state(dc_next_state)
    );
    
endmodule