`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2023 08:46:49 PM
// Design Name: 
// Module Name: idct_add2
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


module idct_add2(
input [31:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9,
output [31:0] o0, o1, o2, o3, o4, o5, o6, o7, o8, o9
    );
    
    assign o0 = t0 + t7;
    assign o1 = t1 + t9;
    assign o2 = t2 + t8;
    assign o3 = t3 + t4;
    assign o4 = t3 - t4;
    assign o5 = t2 - t8;
    assign o6 = t1 - t9;
    assign o7 = t0 - t7;
    
endmodule
