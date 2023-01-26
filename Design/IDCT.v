//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 01/23/2023 11:30:13 PM
//// Design Name: 
//// Module Name: IDCT
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module IDCT(
//    input [63:0] data_in,
//    input s_valid,
//    output [63:0] data_out,
//    output m_valid

//    );
    
//parameter C1 = 4017; // cos( pi/16) x4096
//parameter C2 = 3784; // cos(2pi/16) x4096
//parameter C3 = 3406; // cos(3pi/16) x4096
//parameter C4 = 2896; // cos(4pi/16) x4096
//parameter C5 = 2276; // cos(5pi/16) x4096
//parameter C6 = 1567; // cos(6pi/16) x4096
//parameter C7 = 799;  // cos(7pi/16) x4096

//wire s0 = (data_in[7:0] + data_in[39:32]) * C4;
//wire s1 = (data_in[7:0] - data_in[39:32]) * C4;    
//wire s3 = (data_in[23:16] * C2) + (data_in[55:48] * C6);    
//wire s2 = (data_in[23:16] * C6) - (data_in[55:48] * C2);    
//wire s7 = (data_in[15:8] * C1) + (data_in[63:56] * C7);    
//wire s4 = (data_in[15:8] * C7) - (data_in[63:56] * C1);    
//wire s6 = (data_in[47:40] * C5) + (data_in[31:24] * C3);    
//wire s5 = (data_in[47:40] * C3) - (data_in[31:24] * C5);

//wire t0 = s0 + s3;
//wire t3 = s0 - s3;
//wire t1 = s1 + s2;
//wire t2 = s1 - s2;
//wire t4 = s4 + s5;
//wire t5 = s4 - s5;
//wire t7 = s7 + s6;
//wire t6 = s7 - s6;

//wire s6 = (t5 + t6) * 181 / 256; // 1/sqrt(2)
//wire s5 = (t6 - t5) * 181 / 256; // 1/sqrt(2)

//assign data_out[7:0]  = (t0 + t7) >> 11;
//assign data_out[15:8] = (t1 + s6) >> 11;
//assign data_out[23:16] = (t2 + s5) >> 11;
//assign data_out[31:24] = (t3 + t4) >> 11;
//assign data_out[39:32] = (t3 - t4) >> 11;
//assign data_out[47:40] = (t2 - s5) >> 11;
//assign data_out[55:48] = (t1 - s6) >> 11;
//assign data_out[63:56] = (t0 - t7) >> 11;

//assign m_valid = s_valid;
    
//endmodule
