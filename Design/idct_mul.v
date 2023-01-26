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
input[63:0]data_in, 
output [7:0] in0_c4, in1_c7, in1_c1, in2_c6, in2_c2, in3_c3, in3_c5, in4_c4, in5_c3, in5_c5, in6_c6, in6_c2, in7_c7, in7_c1
    );
    parameter C1 = 4017; // cos( pi/16) x4096
    parameter C2 = 3784; // cos(2pi/16) x4096
    parameter C3 = 3406; // cos(3pi/16) x4096
    parameter C4 = 2896; // cos(4pi/16) x4096
    parameter C5 = 2276; // cos(5pi/16) x4096
    parameter C6 = 1567; // cos(6pi/16) x4096
    parameter C7 = 799;  // cos(7pi/16) x4096
    
    assign in0_c4 = data_in[7:0]*C4;
    assign in1_c7 = data_in[15:8]*C7;
    assign in1_c1 = data_in[15:8]*C1;
    assign in2_c6 = data_in[23:16]*C6;
    assign in2_c2 = data_in[23:16]*C2; 
    assign in3_c3 = data_in[31:24]*C3;  
    assign in3_c5 = data_in[31:24]*C5;  
    assign in4_c4 = data_in[39:32]*C4;
    assign in5_c3 = data_in[47:40]*C3;
    assign in5_c5 = data_in[47:40]*C5; 
    assign in6_c6 = data_in[55:48]*C6;
    assign in6_c2 = data_in[55:48]*C2;
    assign in7_c7 = data_in[63:56]*C7;
    assign in7_c1 = data_in[63:56]*C1;
    
endmodule
