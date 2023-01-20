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
    output reg [3:0] r_value,   //Run length (Count of zeros before number)
    output reg [3:0] s_value,   //Number length (Bit length of the number after zeros)
    output reg done             //Indicates decoding is done and s-r values are valid
);
    //Internal wires
    wire[3:0] ac_r_value, ac_s_value;
    wire[3:0] dc_r_value, dc_s_value;
    wire [7:0] ac_next_state;
    wire [3:0] dc_next_state;

    //Internal registers 
    reg [7:0] state;
    reg ready, ac_dc_flag_reg, bit_reg;
    
    //Direct AC or DC table results to output depending on the selection
    always @(*)begin
        if(ac_dc_flag_reg == 1'b0) begin
            r_value <= ac_r_value;
            s_value <= ac_s_value;
            done <= ac_next_state == 8'b0 && ready == 1'b0 ? 1'b1 : 1'b0;
        end else begin
            r_value <= dc_r_value;
            s_value <= dc_s_value;
            done <= dc_next_state == 4'b0 && ready == 1'b0 ? 1'b1 : 1'b0;
        end
    end
    
    //Put next bit into bit register and change state based on the huffman table (ac or dc)
    always @(posedge clk) begin
        if(rst) begin
            ready <= 1'b1;
            state <= 8'b0;
            ac_dc_flag_reg <= 1'b0;
            bit_reg <= 1'b0;
        end else begin
            if(done) begin
                ready <= 1'b1;
                
                if(ac_dc_flag_reg == 1'b0)
                    state <= ac_next_state;
                else
                    state <= {4'b0, dc_next_state};
            end
        
            if(is_new) begin
                bit_reg <= next_bit;

                if(ready || done) begin
                    ac_dc_flag_reg <= ac_dc_flag;
                    ready <= 1'b0;
                end
                
                if(!ready) begin
                    if(ac_dc_flag_reg == 1'b0)
                        state <= ac_next_state;
                    else
                        state <= {4'b0, dc_next_state};
                end
            end
        end
    end
    
    AC_Huffman_Table ac_huffman_table(
        .bit(bit_reg),
        .state(state),
        .r_value(ac_r_value),
        .s_value(ac_s_value),
        .next_state(ac_next_state)
    );
    
    DC_Huffman_Table dc_huffman_table(
        .bit(bit_reg),
        .state(state[3:0]),
        .r_value(dc_r_value),
        .s_value(dc_s_value),
        .next_state(dc_next_state)
    );
    
endmodule