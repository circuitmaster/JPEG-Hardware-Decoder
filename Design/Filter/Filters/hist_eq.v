`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: hist_eq
// Description: Performs Histogram Equalization
//////////////////////////////////////////////////////////////////////////////////


module Hist_Eq(
    input [31:0] cdf,
    input [31:0] cdf_min,
    output [7:0] pixel_out
);
    wire[31:0] tmp, tmp2;
    assign tmp = (cdf - cdf_min)/(76800 - cdf_min) * 255;
    
    Rounder r(tmp, tmp2);
    assign pixel_out = tmp2[7:0];
    
endmodule
