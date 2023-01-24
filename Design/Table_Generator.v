//////////////////////////////////////////////////////////////////////////////////
// Module Name: Table Generator
// Description: Generates table from generated numbers
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Table_Generator(
    input clk, rst,
    input [3:0] r_value,            //Indicates run length of coefficient
    input [7:0] coefficient,        //Coefficient inferred from encoded image sequence
    input is_new_coefficient,       //Indicates if coefficient is valid

    //Each row is given as outputs
    output reg[64*8-1:0] value,
    output reg valid
);
    
    //Zig Zag index parameters
    parameter [0:64*8-1] params = {8'd0,8'd1,8'd8,8'd16,8'd9,8'd2,8'd3,8'd10,8'd17,8'd24,8'd32,8'd25,8'd18,8'd11,8'd4,8'd5,8'd12,8'd19,8'd26,8'd33,8'd40,8'd48,8'd41,8'd34,8'd27,8'd20,8'd13,8'd6,8'd7,8'd14,8'd21,8'd28,8'd35,8'd42,8'd49,8'd56,8'd57,8'd50,8'd43,8'd36,8'd29,8'd22,8'd15,8'd23,8'd30,8'd37,8'd44,8'd51,8'd58,8'd59,8'd52,8'd45,8'd38,8'd31,8'd39,8'd46,8'd53,8'd60,8'd61,8'd54,8'd47,8'd55,8'd62,8'd63};
    parameter [0:64*8-1] params_quant = {8'd16,8'd11,8'd10,8'd16,8'd24,8'd40,8'd51,8'd61,8'd12,8'd12,8'd14,8'd19,8'd26,8'd58,8'd60,8'd55,8'd14,8'd13,8'd16,8'd24,8'd40,8'd57,8'd69,8'd56,8'd14,8'd17,8'd22,8'd29,8'd51,8'd87,8'd80,8'd62,8'd18,8'd22,8'd37,8'd56,8'd68,8'd109,8'd103,8'd77,8'd24,8'd35,8'd55,8'd64,8'd81,8'd104,8'd113,8'd92,8'd49,8'd64,8'd78,8'd87,8'd103,8'd121,8'd120,8'd101,8'd72,8'd92,8'd95,8'd98,8'd112,8'd100,8'd103,8'd99};
    
    //Zig Zag index memory
    reg[7:0] memory [0:63];
    
    //Quantization coefficients memory
    reg[7:0] memory_quant [0:63];
    
    //Table memory 
    reg[7:0] zig_zag_matrix [0:63];
    
    //Internal registers
    reg[5:0] counter;
    reg valid_reg;
    
    //Internal wires
    reg[7:0] zig_zag_index;
    
    integer i;
    initial begin
        for(i=0; i<64; i=i+1) begin
            memory[i] <= params[i*8 +: 8];
            memory_quant[i] <= params_quant[i*8 +: 8];
            zig_zag_matrix[i] <= 8'd0;
        end
    end
    
    always @(*) begin
        valid <= valid_reg;
        zig_zag_index <= memory[counter+r_value];
    
        for(i=0; i<64; i = i + 1) begin
            value[i*8 +: 8] <= zig_zag_matrix[i]*memory_quant[i];
        end
    end 

    //Control Flow
    always @(posedge clk) begin
        if(rst) begin
            counter <= 6'b0;
            valid_reg <= 1'b0;
        end else begin
            if (is_new_coefficient) begin 
                zig_zag_matrix[zig_zag_index] = coefficient;
                
                if(counter == 6'd63) begin
                    valid_reg <= 1'b1;
                    counter <= 6'b0;
                end else begin
                    counter <= counter + r_value + 1;
                end
             end        
        end
    end
endmodule