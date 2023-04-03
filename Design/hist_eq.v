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
    input [16:0] cdf,
    input [8:0] cdf_min,
    output [31:0] pxl_out
    );
    wire[31:0] tmp;
    assign tmp = (cdf - cdf_min)/(76800 - cdf_min) * 255;
    
    Rounder r(tmp, pxl_out);
    
endmodule
