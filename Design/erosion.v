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


module erosion(
    input [7:0] num1,
    input [7:0] num2,
    input [7:0] num3,
    input [7:0] num4,
    input [7:0] num5,
    input [7:0] num6,
    input [7:0] num7,
    input [7:0] num8,
    input [7:0] num9,
    output [7:0] erod
    
    );
    wire temp, temp2, temp3, temp4, temp5;
    
    assign temp = (num1 > 127) & (num2 > 127);
    assign temp2 = (num3 > 127) & (num4 > 127);
    assign temp3 = (num5 > 127) & (num6 > 127);
    assign temp4 = (num7 > 127) & (num8 > 127);
    
    assign temp5 = temp & temp2;
    assign temp6 = temp3 & temp4;
    
    assign temp7 = temp5 & temp6;
    assign erod = 8'd255 & {8{(temp7 & (num9 > 127))}};
    
    
endmodule
