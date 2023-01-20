`timescale 1ns / 1ps

module Number_Generator_Test;
    //Period of the clock
    localparam PERIOD = 100;

    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg next_bit = 1'b0, is_new = 1'b0;
    
    //Outputs of the module
    wire [3:0] r_value;
    wire [7:0] coefficient;
    wire is_new_coefficient;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;
   
    Number_Generator number_generator(
        .clk(clk), 
        .rst(rst),
        .bit_input(next_bit),
        .is_new_bit(is_new),
        .r_value(r_value),
        .coefficient(coefficient),
        .is_new_coefficient(is_new_coefficient)
    );

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        //NOTE: First sequence will be decoded based on dc table
        
        //DETAILED EXAMPLES
        //Send 011 to DC Decoder (R->0, S->2)
        give_bit_sequence(3'b011, 3);
        
        //Send encoded number 10 (number=2)
        give_bit_sequence(2'b10, 2);
        
        //Send 1111001 to AC Decoder (R->1, S->3)
        give_bit_sequence(7'b1111001, 7);
        
        //Send encoded number 010 (number=-5)
        give_bit_sequence(3'b010, 3);
        
        
        //OTHER EXAMPLES
        //Send 111110111_01 (R->3, number=-2)
        give_bit_sequence(11'b111110111_01, 11);
        
        //Send 1111111110101001_011111 (R->6, number=-32)
        give_bit_sequence(22'b1111111110101001_011111, 22);
                
        //Send 11111111001 (ZRL, R->15, number->0)
        give_bit_sequence(11'b11111111001, 11);
        
        //Send 1010 (EOB, R->0, number->0)
        give_bit_sequence(4'b1010, 4);

    end
    
    //Gives bit sequence into number generator
    task give_bit_sequence(input reg[99:00] bit_sequence, input integer length);
        integer i;
    begin
        for(i=length-1; i>=0; i=i-1) begin
            next_bit <= bit_sequence[i];
            is_new <= 1'b1;
            @(posedge clk);
            next_bit <= 1'b0;
            is_new <= 1'b0;
        end
    end
    endtask    
    
endmodule
















