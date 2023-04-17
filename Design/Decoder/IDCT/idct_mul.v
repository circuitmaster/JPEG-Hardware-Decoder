`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2023 11:59:07 PM
// Design Name: 
// Module Name: idct_mul
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


module idct_mul(
input[255:0]data_in, 
output [31:0] in0_c4, in1_c7, in1_c1, in2_c6, in2_c2, in3_c3, in3_c5, in4_c4, in5_c3, in5_c5, in6_c6, in6_c2, in7_c7, in7_c1, in1_c8, in1_c9, in7_c8, in7_c9, in5_c10, in5_c11, in3_c10, in3_c11
    );
    parameter C1 = 4017; // cos( pi/16) x4096
    parameter C2 = 3784; // cos(2pi/16) x4096
    parameter C3 = 3406; // cos(3pi/16) x4096
    parameter C4 = 2896; // cos(4pi/16) x4096
    parameter C5 = 2276; // cos(5pi/16) x4096
    parameter C6 = 1567; // cos(6pi/16) x4096
    parameter C7 = 799;  // cos(7pi/16) x4096
    
    parameter C8 = 4017+799; // C1 + C7
    parameter C9 = 4017-799; // C1 - C7
    parameter C10 = 3406+2276; // C3 + C5
    parameter C11 = 3406-2276; // C3 - C5
    
    assign in0_c4 = data_in[31:0]*C4;
    assign in1_c7 = data_in[63:32]*C7;
    assign in1_c1 = data_in[63:32]*C1;
    assign in2_c6 = data_in[95:64]*C6;
    assign in2_c2 = data_in[95:64]*C2; 
    assign in3_c3 = data_in[127:96]*C3;  
    assign in3_c5 = data_in[127:96]*C5;  
    assign in4_c4 = data_in[159:128]*C4;
    assign in5_c3 = data_in[191:160]*C3;
    assign in5_c5 = data_in[191:160]*C5; 
    assign in6_c6 = data_in[223:192]*C6;
    assign in6_c2 = data_in[223:192]*C2;
    assign in7_c7 = data_in[255:224]*C7;
    assign in7_c1 = data_in[255:224]*C1;
    
    assign in1_c8 = data_in[63:32]*C8;
    assign in1_c9 = data_in[63:32]*C9;
    assign in7_c8 = data_in[255:224]*C8;
    assign in7_c9 = data_in[255:224]*C9;
    assign in5_c10 = data_in[191:160]*C10;
    assign in5_c11 = data_in[191:160]*C11;
    assign in3_c10 = data_in[127:96]*C10;
    assign in3_c11 = data_in[127:96]*C11;
    
endmodule
