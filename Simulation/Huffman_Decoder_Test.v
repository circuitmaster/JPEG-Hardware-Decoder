`timescale 1ns / 1ps

module Huffman_Decoder_Test;
    //Period of the clock
    localparam PERIOD = 100;

    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg ac_dc_flag = 1'b0, next_bit = 1'b0, is_new = 1'b0;
    
    //Outputs of the module
    wire [3:0] s_value;
    wire [3:0] r_value;
    wire done;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;

    Huffman_Decoder huffman_decoder(
        .clk(clk),
        .rst(rst),
        .ac_dc_flag(ac_dc_flag),
        .next_bit(next_bit),
        .is_new(is_new),
        .s_value(s_value),
        .r_value(r_value),
        .done(done)
    );

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        //Send 011 to DC Decoder (S->0, R->2)
        ac_dc_flag <= 1'b1;  
        next_bit <= 1'b0;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        //Send 11011 to AC Decoder (S->1, R->2)
        ac_dc_flag <= 1'b0;  
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b0;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        next_bit <= 1'b1;
        is_new <= 1'b1;
        @(posedge clk)
        
        is_new <= 1'b0;
    end
    
endmodule