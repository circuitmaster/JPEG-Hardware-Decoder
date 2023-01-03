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
        s_value <= 4'd0;
        r_value <= 4'd0;
        is_valid <= 1'b1;
        
        case({bit_series, length})
             {16'b0000000000000000, 5'd2}:begin
                s_value <= 4'd0;
                r_value <= 4'd0;
             end
             {16'b0100000000000000, 5'd3}:begin
                s_value <= 4'd0;
                r_value <= 4'd1;
             end
             {16'b0110000000000000, 5'd3}:begin
                s_value <= 4'd0;
                r_value <= 4'd2;
             end
             {16'b1000000000000000, 5'd3}:begin
                s_value <= 4'd0;
                r_value <= 4'd3;
             end
             {16'b1010000000000000, 5'd3}:begin
                s_value <= 4'd0;
                r_value <= 4'd4;
             end
             {16'b1100000000000000, 5'd3}:begin
                s_value <= 4'd0;
                r_value <= 4'd5;
             end
             {16'b1110000000000000, 5'd4}:begin
                s_value <= 4'd0;
                r_value <= 4'd6;
             end
             {16'b1111000000000000, 5'd5}:begin
                s_value <= 4'd0;
                r_value <= 4'd7;
             end
             {16'b1111100000000000, 5'd6}:begin
                s_value <= 4'd0;
                r_value <= 4'd8;
             end
             {16'b1111110000000000, 5'd7}:begin
                s_value <= 4'd0;
                r_value <= 4'd9;
             end
             {16'b1111111000000000, 5'd8}:begin
                s_value <= 4'd0;
                r_value <= 4'd10;
             end
             {16'b1111111100000000, 5'd9}:begin
                s_value <= 4'd0;
                r_value <= 4'd11;
             end
             default:begin
                is_valid <= 1'b0;
             end
        endcase
    end

endmodule