`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: edge_Y
// Description: Performs Sobel_Y operation
//////////////////////////////////////////////////////////////////////////////////


module Edge_Y(
    input [199:0] image_in, //Input Matrix
    output [7:0] pixel_out //Output Matrix
);

    //For paralellization
    wire [15:0] tmp;
    
    //Directly writing the values for 5x5 kernel, where the values are hand-calculated
    wire [15:0] first_col1 = -image_in[7:0] - 2*image_in[47:40];
    wire [15:0] first_col2 = 2 * image_in[127:120] + image_in[167:160];
    wire [15:0] second_col1 = -4*image_in[15:8] - 8*image_in[55+48];
    wire [15:0] second_col2 = 8*image_in[135:128] + 4*image_in[175:168];
    wire [15:0] third_col1 = -6*image_in[23:16] - 12*image_in[63:56];
    wire [15:0] third_col2 = 12*image_in[143:136] + 6*image_in[183:176];
    wire [15:0] fourth_col1 = -4*image_in[31:24] - 8*image_in[71:64];
    wire [15:0] fourth_col2 = 8*image_in[151:144] + 4*image_in[191:184];
    wire [15:0] fifth_col1 = -image_in[39:32] - 2*image_in[79:72];
    wire [15:0] fifth_col2 = 2*image_in[169:162] + image_in[199:192];
    
    wire [15:0] first_col = first_col1 + first_col2;
    wire [15:0] second_col = second_col1 + second_col2;
    wire [15:0] third_col = third_col1 + third_col2;
    wire [15:0] fourth_col = fourth_col1 + fourth_col2;
    wire [15:0] fifth_col = fifth_col1 + fifth_col2;
    
    assign tmp = first_col + second_col + third_col + fourth_col + fifth_col;

    assign pixel_out = (tmp > 0) ? tmp : - tmp;
    
    
endmodule
