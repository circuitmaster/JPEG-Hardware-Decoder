`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2023 04:19:06 PM
// Design Name: 
// Module Name: idct_add0
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


module idct_add0(
input [31:0] in0_c4, in1_c7, in1_c1, in2_c6, in2_c2, in3_c3, in3_c5, in4_c4, in5_c3, in5_c5, in6_c6, in6_c2, in7_c7, in7_c1, in1_c8, in1_c9, in7_c8, in7_c9, in5_c10, in5_c11, in3_c10, in3_c11,
output [31:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11
    );
    
    assign s0 = in0_c4 + in4_c4;
    assign s1 = in0_c4 - in4_c4;
    assign s2 = in2_c6 - in6_c2;
    assign s3 = in2_c2 + in6_c6;
    assign s4 = in1_c7 - in7_c1;
    assign s5 = in5_c3 - in3_c5;
    assign s6 = in5_c5 + in3_c3;
    assign s7 = in1_c1 + in7_c7;
    
    assign s8 = in1_c8 - in7_c9; // 1st and 7th inputs contributions
    assign s9 = in5_c10 + in3_c11; // 3rd and 5th inputs contributions (Warning: multiplied  with -1)
    assign s10 = in1_c9 + in7_c8; // 1st and 7th inputs contributions
    assign s11 = in5_c11 - in3_c10; // 3rd and 5th inputs contributions
     
endmodule
