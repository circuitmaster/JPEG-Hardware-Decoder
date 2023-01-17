//////////////////////////////////////////////////////////////////////////////////
// Module Name: Number Generator
// Description: Generates number from endecoded image sequence
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Number_Generator(
    input clk, rst,
    input bit_input,
    input is_new_bit,
    input[3:0] s_value_huffman,
    input[3:0] r_value_huffman,
    input done_huffman,
    input [7:0] decoded_number,
    output reg ac_dc_huffman,
    output reg bit_huffman,
    output reg is_new_bit_huffman,
    output reg[10:0] coded_number,
    output reg[3:0] r_value,
    output reg[3:0] s_value,
    output reg[7:0] coefficient,
    output reg is_new_coefficient
);
   
    localparam HUFFMAN_DECODE_STATE = 0;
    localparam NUMBER_DECODE_STATE = 1;
    
    //Registers
    reg state;
    reg[5:0] coefficient_index;     //Index of coefficient in the block
    reg[10:0] coded_number_reg;         //Holds encoded_number
    reg[3:0] coded_number_index;
    reg[3:0] s_value_reg;
    reg[3:0] r_value_reg;
    
    //Internal Signals
    reg EOB, full_zeros;
    reg[5:0] next_coefficient_index;
    reg next_state;
    
    always @(*) begin
        ac_dc_huffman <= 1'b0;
        bit_huffman <= bit_input;
        is_new_bit_huffman <= 1'b0;
        coded_number <= coded_number_reg;
        s_value <= 4'b0;
        r_value <= r_value_reg;
        coefficient <= 8'b0;
        is_new_coefficient <= 1'b0;
   
        EOB <= s_value_huffman == 4'b0 && r_value_huffman == 4'b0;
        full_zeros <= s_value_huffman == 4'd15 && r_value_huffman == 4'b0;
        next_coefficient_index <= coefficient_index + s_value_reg + 1;
        next_state <= 1'b0;
   
        case(state)
            HUFFMAN_DECODE_STATE: begin
                is_new_bit_huffman <= is_new_bit;
                ac_dc_huffman <= coefficient_index == 6'b0 ? 1'b1 : 1'b0;
                
                if(done_huffman) begin
                    if(EOB) begin
                        ac_dc_huffman <= 1'b1;
                        s_value <= 4'b0;
                        coefficient <= 8'b0;
                        is_new_coefficient <= 1'b1;
                    end else if(full_zeros) begin
                        s_value <= 4'd15;
                        coefficient <= 8'b0;
                        is_new_coefficient <= 1'b1;
                    end else begin
                        is_new_bit_huffman <= 1'b0;
                        next_state <= NUMBER_DECODE_STATE;
                    end
                end
            end
            NUMBER_DECODE_STATE: begin
                if(coded_number_index != 4'b1111) begin
                    s_value <= s_value_reg;
                    coefficient <= decoded_number;
                    is_new_coefficient <= 1'b1;
                    next_state <= HUFFMAN_DECODE_STATE;
                end
            end
        endcase
    end
    
    always @(posedge clk) begin
        if(rst) begin
            state <= HUFFMAN_DECODE_STATE;
            coefficient_index <= 6'b0;
            coded_number_reg <= 11'b0;
            coded_number_index <= 4'b0;
            s_value_reg <= 4'b0;
            r_value_reg <= 4'b0;
        end else begin
            case(state)
                HUFFMAN_DECODE_STATE: begin
                    if(done_huffman) begin
                        if(EOB) begin
                            coefficient_index <= 6'b0;
                        end else if(full_zeros) begin
                            coefficient_index <= coefficient_index + 6'd16;
                        end else begin
                            s_value_reg <= s_value_huffman;
                            r_value_reg <= r_value_huffman;
                            if(is_new_bit) begin
                                coded_number_reg[r_value_huffman-1] <= bit_input;
                                coded_number_index <= r_value_huffman-2;
                            end else begin
                                coded_number_index <= r_value_huffman-1;
                            end
                            state <= next_state;
                        end
                    end
                end
                NUMBER_DECODE_STATE: begin
                    if(coded_number_index == 4'b1111) begin
                        if(is_new_bit) begin
                            coded_number_reg[coded_number_index] <= bit_input;
                            coded_number_index <= coded_number_index - 1;
                        end
                    end else begin
                        if(next_coefficient_index == 6'd63) begin
                            coefficient_index <= 6'b0;
                        end else begin
                            coefficient_index <= next_coefficient_index;
                        end
                    
                        state <= next_state;
                    end
                end
            endcase
        end
    end
    
endmodule

















