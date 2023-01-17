`timescale 1ns / 1ps

module Number_Generator_Test;
    //Period of the clock
    localparam PERIOD = 1000;

    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg next_bit = 1'b0, is_new = 1'b0;
    
    //Outputs of the module
    wire [3:0] s_value;
    wire [7:0] coefficient;
    wire is_new_coefficient;
    
    //Internal wires
    wire[3:0] s_value_huffman;
    wire[3:0] r_value_huffman;
    wire done_huffman;
    wire [7:0] decoded_number;
    wire ac_dc_huffman;
    wire bit_huffman;
    wire is_new_bit_huffman;
    wire[10:0] coded_number;
    wire[3:0] r_value;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;

    Huffman_Decoder huffman_decoder(
        .clk(clk),
        .rst(rst),
        .ac_dc_flag(ac_dc_huffman),
        .next_bit(bit_huffman),
        .is_new(is_new_bit_huffman),
        .s_value(s_value_huffman),
        .r_value(r_value_huffman),
        .done(done_huffman)
    );
    
    Number_Decoder number_decoder(
        .r_value(r_value),
        .coded_number(coded_number),
        .decoded_number(decoded_number)
    );
    
    Number_Generator number_generator(
        .clk(clk), 
        .rst(rst),
        .bit_input(next_bit),
        .is_new_bit(is_new),
        .s_value_huffman(s_value_huffman),
        .r_value_huffman(r_value_huffman),
        .done_huffman(done_huffman),
        .decoded_number(decoded_number),
        .ac_dc_huffman(ac_dc_huffman),
        .bit_huffman(bit_huffman),
        .is_new_bit_huffman(is_new_bit_huffman),
        .coded_number(coded_number),
        .r_value(r_value),
        .s_value(s_value),
        .coefficient(coefficient),
        .is_new_coefficient(is_new_coefficient)
    );

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        //Send 011 to DC Decoder (S->0, R->2) 
        next_bit <= 1'b0;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        //Send 2 bit number
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b0;
        is_new <= 1'b1;
    end
    
endmodule