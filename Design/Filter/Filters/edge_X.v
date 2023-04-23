`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: edge_X
// Description: Performs Sobel_X operation
//////////////////////////////////////////////////////////////////////////////////


module Edge_X(
    input [199:0] image_in, //Input Matrix
    output [7:0] pixel_out //Output Matrix
);
    //For parallelization
    wire [15:0] tmp;
    
    //Directly writing the values for 5x5 kernel, where the values are hand-calculated
    wire [15:0] first_row1 = -image_in[7:0] - 2*image_in[15:8];
    wire [15:0] first_row2 = 2 * image_in[31:24] + image_in[39:32];
    wire [15:0] second_row1 = -4*image_in[7+40:40] - 8*image_in[15+40:8+40];
    wire [15:0] second_row2 = 8*image_in[31+40:24+40] + 4*image_in[39+40:32+40];
    wire [15:0] third_row1 = -6*image_in[7+80:80] - 12*image_in[15+80:8+80];
    wire [15:0] third_row2 = 12*image_in[31+80:24+80] + 6*image_in[39+80:32+80];
    wire [15:0] fourth_row1 = -4*image_in[7+120:120] - 8*image_in[15+120:8+120];
    wire [15:0] fourth_row2 = 8*image_in[31+120:24+120] + 4*image_in[39+120:32+120];
    wire [15:0] fifth_row1 = -image_in[7+160:160] - 2*image_in[15+160:8+160];
    wire [15:0] fifth_row2 = 2*image_in[31+160:24+160] + image_in[39+160:32+160];
    
    wire [15:0] first_row = first_row1 + first_row2;
    wire [15:0] second_row = second_row1 + second_row2;
    wire [15:0] third_row = third_row1 + third_row2;
    wire [15:0] fourth_row = fourth_row1 + fourth_row2;
    wire [15:0] fifth_row = fifth_row1 + fifth_row2;
    
    assign tmp = first_row + second_row + third_row + fourth_row + fifth_row;

    assign pixel_out = (tmp > 0) ? tmp>>4 : - tmp>>4;
    
endmodule
