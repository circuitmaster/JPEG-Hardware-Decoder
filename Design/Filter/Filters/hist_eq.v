`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: hist_eq
// Description: Performs Histogram Equalization
//////////////////////////////////////////////////////////////////////////////////


module Hist_Eq(
    input [16:0] cdf,
    input [16:0] cdf_min,
    output [7:0] pixel_out
);
    wire[31:0] tmp, tmp2, tmp3, tmp4, tmp5;
    
    assign tmp = cdf - cdf_min;
    assign tmp2 = 76800 - cdf_min;
    assign tmp3 = tmp * 255;
    assign tmp4 = tmp3 / tmp2;
    
    Rounder r(tmp4, tmp5);
    assign pixel_out = tmp5[7:0];
    
endmodule
