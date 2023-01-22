//////////////////////////////////////////////////////////////////////////////////
// Module Name: Table Generator
// Description: Generates table from generated numbers
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Table_Generator(
    input clk, rst,
    input [3:0] r_value,                    //The value came from the number generator
    input [7:0] coefficient,                //The value came from the number generator
    input is_new_coefficient,               //The value came from the number generator

    //Each row is given as outputs
    output reg[64*8-1:0] value,
    output reg valid

);

    parameter [0:8*8-1] params = {8'd1,8'd2,8'd9,8'd17,8'd10,8'd3,8'd4,8'd11,8'd18,8'd25,8'd33,8'd26,8'd19,8'd12,8'd5,8'd6,8'd13,8'd20,8'd27,8'd34,8'd41,8'd49,8'd42,8'd35,8'd28,8'd21,8'd14,8'd7,8'd8,8'd15,8'd22,8'd29,8'd36,8'd43,8'd50,8'd57,8'd58,8'd51,8'd44,8'd37,8'd30,8'd23,8'd16,8'd24,8'd31,8'd38,8'd45,8'd52,8'd59,8'd60,8'd53,8'd46,8'd39,8'd32,8'd40,8'd47,8'd54,8'd61,8'd62,8'd55,8'd48,8'd56,8'd63,8'd64};
    reg[7:0] memory [0:63]; 
    reg[7:0] zig_zag_matrix [0:63]; 
    
    integer i;
    
    initial begin
        for(i=0; i<64; i=i+1) begin
            memory[i] <= params[i];
            zig_zag_matrix[i] <= 8'd0;
        end
    end
    //Internal Signals

    integer counter = 0; //Loop counter
    integer j;

    //Registers
          //The matrix that will be operated upon
    
    //Flow
    always @(posedge clk) begin
        if (is_new_coefficient) begin 
            zig_zag_matrix[memory[counter+r_value]] = coefficient;
            
            if(counter == 63) begin
                valid <= 1'b1;
                counter <= 0;
            end
            else 
            begin
                counter <= counter + 1 + r_value;
            end
         end        
    end
    
    always @(*) begin
        for(j=0; j<64; j = j + 1) begin
            value[j*8 +: 8] <= zig_zag_matrix[j];
        end
    end
endmodule