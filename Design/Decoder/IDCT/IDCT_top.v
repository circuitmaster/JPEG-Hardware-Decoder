`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//  
// Create Date: 02/12/2023 12:39:19 PM
// Design Name: 
// Module Name: IDCT_top
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


module IDCT_top(
   input clk,
   input rst,
   input [2047:0] data_in,
   input s_valid,
   input [4:0] shift_amount,
   output [2047:0] data_out,
   output m_valid
);
    wire mv1, mv2, mv3, mv4, mv5, mv6, mv7, mv8;
    idct8 idct1(clk, rst, s_valid, data_in[255:0], shift_amount, data_out[255:0], mv1);
    idct8 idct2(clk, rst, s_valid, data_in[511:256], shift_amount, data_out[511:256], mv2);
    idct8 idct3(clk, rst, s_valid, data_in[767:512], shift_amount, data_out[767:512], mv3);
    idct8 idct4(clk, rst, s_valid, data_in[1023:768], shift_amount, data_out[1023:768], mv4);
    idct8 idct5(clk, rst, s_valid, data_in[1279:1024], shift_amount, data_out[1279:1024], mv5);
    idct8 idct6(clk, rst, s_valid, data_in[1535:1280], shift_amount, data_out[1535:1280], mv6);
    idct8 idct7(clk, rst, s_valid, data_in[1791:1536], shift_amount, data_out[1791:1536], mv7);
    idct8 idct8(clk, rst, s_valid, data_in[2047:1792], shift_amount, data_out[2047:1792], mv8);
    
    assign m_valid = mv1 && mv2 && mv3 && mv4 && mv5 && mv6 && mv7 && mv8;
    
endmodule
