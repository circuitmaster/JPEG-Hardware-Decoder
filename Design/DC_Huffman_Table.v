//////////////////////////////////////////////////////////////////////////////////
// Module Name: DC Huffman Table
// Description: Maps encoded input sequence into output values (S-R values)
//              for DC by using Huffman algorithm
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module DC_Huffman_Table (
    input [0:15] bit_series,    //Encoded bit sequence
    input [4:0] length,         //Length of the given sequence
    output reg [3:0] s_value,   //Run length (Count of zeros before number)
    output reg [3:0] r_value,   //Number length (Bit length of the number after zeros)
    output reg is_valid         //Indicates output values are valid
);

    //Maps input sequence to output values (S-R values)
    always @(*)begin
        is_valid <= 1'b1;
        
        if(bit_series[0:1] == 2'b00 && length == 5'd2) begin
            s_value <= 4'd0;
            r_value <= 4'd0;
        end else if(bit_series[0:2] == 3'b010 && length == 5'd3) begin
            s_value <= 4'd0;
            r_value <= 4'd1;
        end else if(bit_series[0:2] == 3'b011 && length == 5'd3) begin
            s_value <= 4'd0;
            r_value <= 4'd2;
        end else if(bit_series[0:2] == 3'b100 && length == 5'd3) begin
            s_value <= 4'd0;
            r_value <= 4'd3;
        end else if(bit_series[0:2] == 3'b101 && length == 5'd3) begin
            s_value <= 4'd0;
            r_value <= 4'd4;
        end else if(bit_series[0:2] == 3'b110 && length == 5'd3) begin
            s_value <= 4'd0;
            r_value <= 4'd5;
        end else if(bit_series[0:3] == 4'b1110 && length == 5'd4) begin
            s_value <= 4'd0;
            r_value <= 4'd6;
        end else if(bit_series[0:4] == 5'b11110 && length == 5'd5) begin
            s_value <= 4'd0;
            r_value <= 4'd7;
        end else if(bit_series[0:5] == 6'b111110 && length == 5'd6) begin
            s_value <= 4'd0;
            r_value <= 4'd8;
        end else if(bit_series[0:6] == 7'b1111110 && length == 5'd7) begin
            s_value <= 4'd0;
            r_value <= 4'd9;
        end else if(bit_series[0:7] == 8'b11111110 && length == 5'd8) begin
            s_value <= 4'd0;
            r_value <= 4'd10;
        end else if(bit_series[0:8] == 9'b111111110 && length == 5'd9) begin
            s_value <= 4'd0;
            r_value <= 4'd11;
        end else begin
            s_value <= 4'd0;
            r_value <= 4'd0;
            is_valid <= 1'b0;
        end
    end

endmodule