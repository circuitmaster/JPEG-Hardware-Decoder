`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 09:46:03 PM
// Design Name: 
// Module Name: hist_eq
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


module hist_eq(
    input [31:0] cdf,
    input [31:0] cdf_min,
    output [7:0] pxl_out
    );
    wire[31:0] tmp, tmp2;
    assign tmp = (cdf - cdf_min)/(76800 - cdf_min) * 255;
    
    Rounder r(tmp, tmp2);
    assign pxl_out = tmp2[7:0];
    
endmodule
