`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 03:05:43 PM
// Design Name: 
// Module Name: erosion
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


module Erosion(
    input [71:0] image_in,
    output [7:0] pixel_out
);
    wire temp, temp2, temp3, temp4, temp5;
    
    assign temp = (image_in[7:0] > 127) & (image_in[15:8] > 127);
    assign temp2 = (image_in[23:16] > 127) & (image_in[31:24] > 127);
    assign temp3 = (image_in[39:32] > 127) & (image_in[47:40] > 127);
    assign temp4 = (image_in[55:48] > 127) & (image_in[63:56] > 127);
    
    assign temp5 = temp & temp2;
    assign temp6 = temp3 & temp4;
    
    assign temp7 = temp5 & temp6;
    assign pixel_out = 8'd255 & {8{(temp7 & (image_in[71:64] > 127))}};
    
    
endmodule
