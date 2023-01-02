//////////////////////////////////////////////////////////////////////////////////
// Module Name: AC Huffman Table
// Description: Maps encoded input sequence into output values (S-R values)
//              for AC by using Huffman algorithm
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module AC_Huffman_Table (
    input [0:15] bit_series,    //Encoded bit sequence
    input [4:0] length,         //Length of the given sequence
    output reg [3:0] s_value,   //Run length (Count of zeros before number)
    output reg [3:0] r_value,   //Number length (Bit length of the number after zeros)
    output reg is_valid         //Indicates output values are valid
);

    //Maps input sequence to output values (S-R values)
    always @(*)begin
        is_valid <= 1'b1;
        
        if(bit_series[0:3] == 4'b1010 && length == 5'd4) begin
            s_value <= 4'd0;
            r_value <= 4'd0;
        end else if(bit_series[0:1] == 2'b00 && length == 5'd2) begin
            s_value <= 4'd0;
            r_value <= 4'd1;
        end else if(bit_series[0:1] == 2'b01 && length == 5'd2) begin
            s_value <= 4'd0;
            r_value <= 4'd2;
        end else if(bit_series[0:2] == 3'b100 && length == 5'd3) begin
            s_value <= 4'd0;
            r_value <= 4'd3;
        end else if(bit_series[0:3] == 4'b1011 && length == 5'd4) begin
            s_value <= 4'd0;
            r_value <= 4'd4;
        end else if(bit_series[0:4] == 5'b11010 && length == 5'd5) begin
            s_value <= 4'd0;
            r_value <= 4'd5;
        end else if(bit_series[0:6] == 7'b1111000 && length == 5'd7) begin
            s_value <= 4'd0;
            r_value <= 4'd6;
        end else if(bit_series[0:7] == 8'b11111000 && length == 5'd8) begin
            s_value <= 4'd0;
            r_value <= 4'd7;
        end else if(bit_series[0:9] == 10'b1111110110 && length == 5'd10) begin
            s_value <= 4'd0;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110000010 && length == 5'd16) begin
            s_value <= 4'd0;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110000011 && length == 5'd16) begin
            s_value <= 4'd0;
            r_value <= 4'd10;
        end else if(bit_series[0:3] == 4'b1100 && length == 5'd4) begin
            s_value <= 4'd1;
            r_value <= 4'd1;
        end else if(bit_series[0:4] == 5'b11011 && length == 5'd5) begin
            s_value <= 4'd1;
            r_value <= 4'd2;
        end else if(bit_series[0:6] == 7'b1111001 && length == 5'd7) begin
            s_value <= 4'd1;
            r_value <= 4'd3;
        end else if(bit_series[0:8] == 9'b111110110 && length == 5'd9) begin
            s_value <= 4'd1;
            r_value <= 4'd4;
        end else if(bit_series[0:10] == 11'b11111110110 && length == 5'd11) begin
            s_value <= 4'd1;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110000100 && length == 5'd16) begin
            s_value <= 4'd1;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110000101 && length == 5'd16) begin
            s_value <= 4'd1;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110000110 && length == 5'd16) begin
            s_value <= 4'd1;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110000111 && length == 5'd16) begin
            s_value <= 4'd1;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110001000 && length == 5'd16) begin
            s_value <= 4'd1;
            r_value <= 4'd10;
        end else if(bit_series[0:4] == 5'b11100 && length == 5'd5) begin
            s_value <= 4'd2;
            r_value <= 4'd1;
        end else if(bit_series[0:7] == 8'b11111001 && length == 5'd8) begin
            s_value <= 4'd2;
            r_value <= 4'd2;
        end else if(bit_series[0:9] == 10'b1111110111 && length == 5'd10) begin
            s_value <= 4'd2;
            r_value <= 4'd3;
        end else if(bit_series[0:11] == 12'b111111110100 && length == 5'd12) begin
            s_value <= 4'd2;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111110001001 && length == 5'd16) begin
            s_value <= 4'd2;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110001010 && length == 5'd16) begin
            s_value <= 4'd2;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110001011 && length == 5'd16) begin
            s_value <= 4'd2;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110001100 && length == 5'd16) begin
            s_value <= 4'd2;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110001101 && length == 5'd16) begin
            s_value <= 4'd2;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110001110 && length == 5'd16) begin
            s_value <= 4'd2;
            r_value <= 4'd10;
        end else if(bit_series[0:5] == 6'b111010 && length == 5'd6) begin
            s_value <= 4'd3;
            r_value <= 4'd1;
        end else if(bit_series[0:8] == 9'b111110111 && length == 5'd9) begin
            s_value <= 4'd3;
            r_value <= 4'd2;
        end else if(bit_series[0:11] == 12'b111111110101 && length == 5'd12) begin
            s_value <= 4'd3;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111110001111 && length == 5'd16) begin
            s_value <= 4'd3;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111110010000 && length == 5'd16) begin
            s_value <= 4'd3;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110010001 && length == 5'd16) begin
            s_value <= 4'd3;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110010010 && length == 5'd16) begin
            s_value <= 4'd3;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110010011 && length == 5'd16) begin
            s_value <= 4'd3;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110010100 && length == 5'd16) begin
            s_value <= 4'd3;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110010101 && length == 5'd16) begin
            s_value <= 4'd3;
            r_value <= 4'd10;
        end else if(bit_series[0:5] == 6'b111011 && length == 5'd6) begin
            s_value <= 4'd4;
            r_value <= 4'd1;
        end else if(bit_series[0:9] == 10'b1111111000 && length == 5'd10) begin
            s_value <= 4'd4;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111110010110 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111110010111 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111110011000 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110011001 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110011010 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110011011 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110011100 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110011101 && length == 5'd16) begin
            s_value <= 4'd4;
            r_value <= 4'd10;
        end else if(bit_series[0:6] == 7'b1111010 && length == 5'd7) begin
            s_value <= 4'd5;
            r_value <= 4'd1;
        end else if(bit_series[0:10] == 11'b11111110111 && length == 5'd11) begin
            s_value <= 4'd5;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111110011110 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111110011111 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111110100000 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110100001 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110100010 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110100011 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110100100 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110100101 && length == 5'd16) begin
            s_value <= 4'd5;
            r_value <= 4'd10;
        end else if(bit_series[0:6] == 7'b1111011 && length == 5'd7) begin
            s_value <= 4'd6;
            r_value <= 4'd1;
        end else if(bit_series[0:11] == 12'b111111110110 && length == 5'd12) begin
            s_value <= 4'd6;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111110100110 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111110100111 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111110101000 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110101001 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110101010 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110101011 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110101100 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110101101 && length == 5'd16) begin
            s_value <= 4'd6;
            r_value <= 4'd10;
        end else if(bit_series[0:7] == 8'b11111010 && length == 5'd8) begin
            s_value <= 4'd7;
            r_value <= 4'd1;
        end else if(bit_series[0:11] == 12'b111111110111 && length == 5'd12) begin
            s_value <= 4'd7;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111110101110 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111110101111 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111110110000 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110110001 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110110010 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110110011 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110110100 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110110101 && length == 5'd16) begin
            s_value <= 4'd7;
            r_value <= 4'd10;
        end else if(bit_series[0:8] == 9'b111111000 && length == 5'd9) begin
            s_value <= 4'd8;
            r_value <= 4'd1;
        end else if(bit_series[0:14] == 15'b111111111000000 && length == 5'd15) begin
            s_value <= 4'd8;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111110110110 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111110110111 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111110111000 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111110111001 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111110111010 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111110111011 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111110111100 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111110111101 && length == 5'd16) begin
            s_value <= 4'd8;
            r_value <= 4'd10;
        end else if(bit_series[0:8] == 9'b111111001 && length == 5'd9) begin
            s_value <= 4'd9;
            r_value <= 4'd1;
        end else if(bit_series[0:15] == 16'b1111111110111110 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111110111111 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111111000000 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111111000001 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111111000010 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111111000011 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111111000100 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111111000101 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111111000110 && length == 5'd16) begin
            s_value <= 4'd9;
            r_value <= 4'd10;
        end else if(bit_series[0:8] == 9'b111111010 && length == 5'd9) begin
            s_value <= 4'd10;
            r_value <= 4'd1;
        end else if(bit_series[0:15] == 16'b1111111111000111 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111111001000 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111111001001 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111111001010 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111111001011 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111111001100 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111111001101 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111111001110 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111111001111 && length == 5'd16) begin
            s_value <= 4'd10;
            r_value <= 4'd10;
        end else if(bit_series[0:9] == 10'b1111111001 && length == 5'd10) begin
            s_value <= 4'd11;
            r_value <= 4'd1;
        end else if(bit_series[0:15] == 16'b1111111111010000 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111111010001 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111111010010 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111111010011 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111111010100 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111111010101 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111111010110 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111111010111 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111111011000 && length == 5'd16) begin
            s_value <= 4'd11;
            r_value <= 4'd10;
        end else if(bit_series[0:9] == 10'b1111111010 && length == 5'd10) begin
            s_value <= 4'd12;
            r_value <= 4'd1;
        end else if(bit_series[0:15] == 16'b1111111111011001 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111111011010 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111111011011 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111111011100 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111111011101 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111111011110 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111111011111 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111111100000 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111111100001 && length == 5'd16) begin
            s_value <= 4'd12;
            r_value <= 4'd10;
        end else if(bit_series[0:10] == 11'b11111111000 && length == 5'd11) begin
            s_value <= 4'd13;
            r_value <= 4'd1;
        end else if(bit_series[0:15] == 16'b1111111111100010 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111111100011 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111111100100 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111111100101 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111111100110 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111111100111 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111111101000 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111111101001 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111111101010 && length == 5'd16) begin
            s_value <= 4'd13;
            r_value <= 4'd10;
        end else if(bit_series[0:15] == 16'b1111111111101011 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd1;
        end else if(bit_series[0:15] == 16'b1111111111101100 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111111101101 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111111101110 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111111101111 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111111110000 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111111110001 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111111110010 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111111110011 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111111110100 && length == 5'd16) begin
            s_value <= 4'd14;
            r_value <= 4'd10;
        end else if(bit_series[0:15] == 16'b1111111111110101 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd1;
        end else if(bit_series[0:15] == 16'b1111111111110110 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd2;
        end else if(bit_series[0:15] == 16'b1111111111110111 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd3;
        end else if(bit_series[0:15] == 16'b1111111111111000 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd4;
        end else if(bit_series[0:15] == 16'b1111111111111001 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd5;
        end else if(bit_series[0:15] == 16'b1111111111111010 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd6;
        end else if(bit_series[0:15] == 16'b1111111111111011 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd7;
        end else if(bit_series[0:15] == 16'b1111111111111100 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd8;
        end else if(bit_series[0:15] == 16'b1111111111111101 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd9;
        end else if(bit_series[0:15] == 16'b1111111111111110 && length == 5'd16) begin
            s_value <= 4'd15;
            r_value <= 4'd10;
        end else if(bit_series[0:10] == 11'b11111111001 && length == 5'd11) begin
            s_value <= 4'd15;
            r_value <= 4'd0;
        end else begin
            s_value <= 4'd0;
            r_value <= 4'd0;
            is_valid <= 1'b0;
        end
    end

endmodule