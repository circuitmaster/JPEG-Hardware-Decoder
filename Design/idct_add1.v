`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2023 08:13:23 PM
// Design Name: 
// Module Name: idct_add1
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


module idct_add1(
    input [31:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11,
    output [31:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9
    );
    
        assign t0 = s0 + s3;
        assign t3 = s0 - s3;
        assign t1 = s1 + s2;
        assign t2 = s1 - s2;
        assign t4 = s4 + s5;
        assign t5 = s4 - s5;
        assign t7 = s7 + s6;
        assign t6 = s7 - s6;
        
        assign t8 = s8 - s9;
        assign t9 = s10 + s11;
        
        
endmodule
