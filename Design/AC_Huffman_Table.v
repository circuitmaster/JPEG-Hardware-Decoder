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
        s_value <= 4'd0;
        r_value <= 4'd0;
        is_valid <= 1'b1;
        
        case({bit_series, length})
            {16'b1010000000000000, 5'd4}:begin
                s_value <= 4'd0;
                r_value <= 4'd0;
            end
            {16'b0000000000000000, 5'd2}:begin
                s_value <= 4'd0;
                r_value <= 4'd1;
            end
            {16'b0100000000000000, 5'd2}:begin
                s_value <= 4'd0;
                r_value <= 4'd2;
            end
            {16'b1000000000000000, 5'd3}:begin
                s_value <= 4'd0;
                r_value <= 4'd3;
            end
            {16'b1011000000000000, 5'd4}:begin
                s_value <= 4'd0;
                r_value <= 4'd4;
            end
            {16'b1101000000000000, 5'd5}:begin
                s_value <= 4'd0;
                r_value <= 4'd5;
            end
            {16'b1111000000000000, 5'd7}:begin
                s_value <= 4'd0;
                r_value <= 4'd6;
            end
            {16'b1111100000000000, 5'd8}:begin
                s_value <= 4'd0;
                r_value <= 4'd7;
            end
            {16'b1111110110000000, 5'd10}:begin
                s_value <= 4'd0;
                r_value <= 4'd8;
            end
            {16'b1111111110000010, 5'd16}:begin
                s_value <= 4'd0;
                r_value <= 4'd9;
            end
            {16'b1111111110000011, 5'd16}:begin
                s_value <= 4'd0;
                r_value <= 4'd10;
            end
            {16'b1100000000000000, 5'd4}:begin
                s_value <= 4'd1;
                r_value <= 4'd1;
            end
            {16'b1101100000000000, 5'd5}:begin
                s_value <= 4'd1;
                r_value <= 4'd2;
            end
            {16'b1111001000000000, 5'd7}:begin
                s_value <= 4'd1;
                r_value <= 4'd3;
            end
            {16'b1111101100000000, 5'd9}:begin
                s_value <= 4'd1;
                r_value <= 4'd4;
            end
            {16'b1111111011000000, 5'd11}:begin
                s_value <= 4'd1;
                r_value <= 4'd5;
            end
            {16'b1111111110000100, 5'd16}:begin
                s_value <= 4'd1;
                r_value <= 4'd6;
            end
            {16'b1111111110000101, 5'd16}:begin
                s_value <= 4'd1;
                r_value <= 4'd7;
            end
            {16'b1111111110000110, 5'd16}:begin
                s_value <= 4'd1;
                r_value <= 4'd8;
            end
            {16'b1111111110000111, 5'd16}:begin
                s_value <= 4'd1;
                r_value <= 4'd9;
            end
            {16'b1111111110001000, 5'd16}:begin
                s_value <= 4'd1;
                r_value <= 4'd10;
            end
            {16'b1110000000000000, 5'd5}:begin
                s_value <= 4'd2;
                r_value <= 4'd1;
            end
            {16'b1111100100000000, 5'd8}:begin
                s_value <= 4'd2;
                r_value <= 4'd2;
            end
            {16'b1111110111000000, 5'd10}:begin
                s_value <= 4'd2;
                r_value <= 4'd3;
            end
            {16'b1111111101000000, 5'd12}:begin
                s_value <= 4'd2;
                r_value <= 4'd4;
            end
            {16'b1111111110001001, 5'd16}:begin
                s_value <= 4'd2;
                r_value <= 4'd5;
            end
            {16'b1111111110001010, 5'd16}:begin
                s_value <= 4'd2;
                r_value <= 4'd6;
            end
            {16'b1111111110001011, 5'd16}:begin
                s_value <= 4'd2;
                r_value <= 4'd7;
            end
            {16'b1111111110001100, 5'd16}:begin
                s_value <= 4'd2;
                r_value <= 4'd8;
            end
            {16'b1111111110001101, 5'd16}:begin
                s_value <= 4'd2;
                r_value <= 4'd9;
            end
            {16'b1111111110001110, 5'd16}:begin
                s_value <= 4'd2;
                r_value <= 4'd10;
            end
            {16'b1110100000000000, 5'd6}:begin
                s_value <= 4'd3;
                r_value <= 4'd1;
            end
            {16'b1111101110000000, 5'd9}:begin
                s_value <= 4'd3;
                r_value <= 4'd2;
            end
            {16'b1111111101010000, 5'd12}:begin
                s_value <= 4'd3;
                r_value <= 4'd3;
            end
            {16'b1111111110001111, 5'd16}:begin
                s_value <= 4'd3;
                r_value <= 4'd4;
            end
            {16'b1111111110010000, 5'd16}:begin
                s_value <= 4'd3;
                r_value <= 4'd5;
            end
            {16'b1111111110010001, 5'd16}:begin
                s_value <= 4'd3;
                r_value <= 4'd6;
            end
            {16'b1111111110010010, 5'd16}:begin
                s_value <= 4'd3;
                r_value <= 4'd7;
            end
            {16'b1111111110010011, 5'd16}:begin
                s_value <= 4'd3;
                r_value <= 4'd8;
            end
            {16'b1111111110010100, 5'd16}:begin
                s_value <= 4'd3;
                r_value <= 4'd9;
            end
            {16'b1111111110010101, 5'd16}:begin
                s_value <= 4'd3;
                r_value <= 4'd10;
            end
            {16'b1110110000000000, 5'd6}:begin
                s_value <= 4'd4;
                r_value <= 4'd1;
            end
            {16'b1111111000000000, 5'd10}:begin
                s_value <= 4'd4;
                r_value <= 4'd2;
            end
            {16'b1111111110010110, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd3;
            end
            {16'b1111111110010111, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd4;
            end
            {16'b1111111110011000, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd5;
            end
            {16'b1111111110011001, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd6;
            end
            {16'b1111111110011010, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd7;
            end
            {16'b1111111110011011, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd8;
            end
            {16'b1111111110011100, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd9;
            end
            {16'b1111111110011101, 5'd16}:begin
                s_value <= 4'd4;
                r_value <= 4'd10;
            end
            {16'b1111010000000000, 5'd7}:begin
                s_value <= 4'd5;
                r_value <= 4'd1;
            end
            {16'b1111111011100000, 5'd11}:begin
                s_value <= 4'd5;
                r_value <= 4'd2;
            end
            {16'b1111111110011110, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd3;
            end
            {16'b1111111110011111, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd4;
            end
            {16'b1111111110100000, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd5;
            end
            {16'b1111111110100001, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd6;
            end
            {16'b1111111110100010, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd7;
            end
            {16'b1111111110100011, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd8;
            end
            {16'b1111111110100100, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd9;
            end
            {16'b1111111110100101, 5'd16}:begin
                s_value <= 4'd5;
                r_value <= 4'd10;
            end
            {16'b1111011000000000, 5'd7}:begin
                s_value <= 4'd6;
                r_value <= 4'd1;
            end
            {16'b1111111101100000, 5'd12}:begin
                s_value <= 4'd6;
                r_value <= 4'd2;
            end
            {16'b1111111110100110, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd3;
            end
            {16'b1111111110100111, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd4;
            end
            {16'b1111111110101000, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd5;
            end
            {16'b1111111110101001, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd6;
            end
            {16'b1111111110101010, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd7;
            end
            {16'b1111111110101011, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd8;
            end
            {16'b1111111110101100, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd9;
            end
            {16'b1111111110101101, 5'd16}:begin
                s_value <= 4'd6;
                r_value <= 4'd10;
            end
            {16'b1111101000000000, 5'd8}:begin
                s_value <= 4'd7;
                r_value <= 4'd1;
            end
            {16'b1111111101110000, 5'd12}:begin
                s_value <= 4'd7;
                r_value <= 4'd2;
            end
            {16'b1111111110101110, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd3;
            end
            {16'b1111111110101111, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd4;
            end
            {16'b1111111110110000, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd5;
            end
            {16'b1111111110110001, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd6;
            end
            {16'b1111111110110010, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd7;
            end
            {16'b1111111110110011, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd8;
            end
            {16'b1111111110110100, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd9;
            end
            {16'b1111111110110101, 5'd16}:begin
                s_value <= 4'd7;
                r_value <= 4'd10;
            end
            {16'b1111110000000000, 5'd9}:begin
                s_value <= 4'd8;
                r_value <= 4'd1;
            end
            {16'b1111111110000000, 5'd15}:begin
                s_value <= 4'd8;
                r_value <= 4'd2;
            end
            {16'b1111111110110110, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd3;
            end
            {16'b1111111110110111, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd4;
            end
            {16'b1111111110111000, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd5;
            end
            {16'b1111111110111001, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd6;
            end
            {16'b1111111110111010, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd7;
            end
            {16'b1111111110111011, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd8;
            end
            {16'b1111111110111100, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd9;
            end
            {16'b1111111110111101, 5'd16}:begin
                s_value <= 4'd8;
                r_value <= 4'd10;
            end
            {16'b1111110010000000, 5'd9}:begin
                s_value <= 4'd9;
                r_value <= 4'd1;
            end
            {16'b1111111110111110, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd2;
            end
            {16'b1111111110111111, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd3;
            end
            {16'b1111111111000000, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd4;
            end
            {16'b1111111111000001, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd5;
            end
            {16'b1111111111000010, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd6;
            end
            {16'b1111111111000011, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd7;
            end
            {16'b1111111111000100, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd8;
            end
            {16'b1111111111000101, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd9;
            end
            {16'b1111111111000110, 5'd16}:begin
                s_value <= 4'd9;
                r_value <= 4'd10;
            end
            {16'b1111110100000000, 5'd9}:begin
                s_value <= 4'd10;
                r_value <= 4'd1;
            end
            {16'b1111111111000111, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd2;
            end
            {16'b1111111111001000, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd3;
            end
            {16'b1111111111001001, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd4;
            end
            {16'b1111111111001010, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd5;
            end
            {16'b1111111111001011, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd6;
            end
            {16'b1111111111001100, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd7;
            end
            {16'b1111111111001101, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd8;
            end
            {16'b1111111111001110, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd9;
            end
            {16'b1111111111001111, 5'd16}:begin
                s_value <= 4'd10;
                r_value <= 4'd10;
            end
            {16'b1111111001000000, 5'd10}:begin
                s_value <= 4'd11;
                r_value <= 4'd1;
            end
            {16'b1111111111010000, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd2;
            end
            {16'b1111111111010001, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd3;
            end
            {16'b1111111111010010, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd4;
            end
            {16'b1111111111010011, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd5;
            end
            {16'b1111111111010100, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd6;
            end
            {16'b1111111111010101, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd7;
            end
            {16'b1111111111010110, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd8;
            end
            {16'b1111111111010111, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd9;
            end
            {16'b1111111111011000, 5'd16}:begin
                s_value <= 4'd11;
                r_value <= 4'd10;
            end
            {16'b1111111010000000, 5'd10}:begin
                s_value <= 4'd12;
                r_value <= 4'd1;
            end
            {16'b1111111111011001, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd2;
            end
            {16'b1111111111011010, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd3;
            end
            {16'b1111111111011011, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd4;
            end
            {16'b1111111111011100, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd5;
            end
            {16'b1111111111011101, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd6;
            end
            {16'b1111111111011110, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd7;
            end
            {16'b1111111111011111, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd8;
            end
            {16'b1111111111100000, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd9;
            end
            {16'b1111111111100001, 5'd16}:begin
                s_value <= 4'd12;
                r_value <= 4'd10;
            end
            {16'b1111111100000000, 5'd11}:begin
                s_value <= 4'd13;
                r_value <= 4'd1;
            end
            {16'b1111111111100010, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd2;
            end
            {16'b1111111111100011, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd3;
            end
            {16'b1111111111100100, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd4;
            end
            {16'b1111111111100101, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd5;
            end
            {16'b1111111111100110, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd6;
            end
            {16'b1111111111100111, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd7;
            end
            {16'b1111111111101000, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd8;
            end
            {16'b1111111111101001, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd9;
            end
            {16'b1111111111101010, 5'd16}:begin
                s_value <= 4'd13;
                r_value <= 4'd10;
            end
            {16'b1111111111101011, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd1;
            end
            {16'b1111111111101100, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd2;
            end
            {16'b1111111111101101, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd3;
            end
            {16'b1111111111101110, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd4;
            end
            {16'b1111111111101111, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd5;
            end
            {16'b1111111111110000, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd6;
            end
            {16'b1111111111110001, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd7;
            end
            {16'b1111111111110010, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd8;
            end
            {16'b1111111111110011, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd9;
            end
            {16'b1111111111110100, 5'd16}:begin
                s_value <= 4'd14;
                r_value <= 4'd10;
            end
            {16'b1111111111110101, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd1;
            end
            {16'b1111111111110110, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd2;
            end
            {16'b1111111111110111, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd3;
            end
            {16'b1111111111111000, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd4;
            end
            {16'b1111111111111001, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd5;
            end
            {16'b1111111111111010, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd6;
            end
            {16'b1111111111111011, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd7;
            end
            {16'b1111111111111100, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd8;
            end
            {16'b1111111111111101, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd9;
            end
            {16'b1111111111111110, 5'd16}:begin
                s_value <= 4'd15;
                r_value <= 4'd10;
            end
            {16'b1111111100100000, 5'd11}:begin
                s_value <= 4'd15;
                r_value <= 4'd0;
            end
            default:begin
                is_valid <= 1'b0;
            end
        endcase
    end

endmodule