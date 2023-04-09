`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 02:27:04 PM
// Design Name: 
// Module Name: edge_Y
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Edge_Y(
    input [199:0] image_in, //Input Matrix
    output [7:0] pixel_out //Output Matrix
);
    // Gaussian blur kernel
    // reg [7:0] edge_x = {8'd1,8'd2,8'd1,8'd2,8'd4,8'd2,8'd1,8'd2,8'd1};
    wire [15:0] tmp;
    
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
