`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2023 11:49:42 PM
// Design Name: 
// Module Name: idct8
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


module idct8(
input clk,
input s_valid,
input[63:0] data_in,
input[4:0] shift_amount, //shifting max 32 bits
output[63:0] data_out,
output  m_valid
    );
    
    wire [31:0] in0_c4, in1_c7, in1_c1, in2_c6, in2_c2, in3_c3, in3_c5, in4_c4, in5_c3, in5_c5, in6_c6, in6_c2, in7_c7, in7_c1, in1_c8, in1_c9, in7_c8, in7_c9, in5_c10, in5_c11, in3_c10, in3_c11;
    wire [31:0] in0_c4_reg, in1_c7_reg, in1_c1_reg, in2_c6_reg, in2_c2_reg, in3_c3_reg, in3_c5_reg, in4_c4_reg, in5_c3_reg, in5_c5_reg, in6_c6_reg, in6_c2_reg, in7_c7_reg, in7_c1_reg, in1_c8_reg, in1_c9_reg, in7_c8_reg, in7_c9_reg, in5_c10_reg, in5_c11_reg, in3_c10_reg, in3_c11_reg;
    wire [31:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;
    wire [31:0] s0_reg, s1_reg, s2_reg, s3_reg, s4_reg, s5_reg, s6_reg, s7_reg;
    wire [31:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9;
    wire [31:0] t0_reg, t1_reg, t2_reg, t3_reg, t4_reg, t5_reg, t6_reg, t7_reg, t8_reg, t9_reg;
    wire [31:0] t0_reg2, t1_reg2, t2_reg2, t3_reg2, t4_reg2, t5_reg2, t6_reg2, t7_reg2, t8_reg2, t9_reg2;
    wire [31:0] t8_181, t9_181, t8_181_shifted, t9_181_shifted;
    wire [31:0] o0, o1, o2, o3, o4, o5, o6, o7;
    wire [31:0] o0_shifted, o1_shifted, o2_shifted, o3_shifted, o4_shifted, o5_shifted, o6_shifted, o7_shifted;
    wire s_valid_reg, s_valid_reg2, s_valid_reg3;
    
    idct_mul mul0(data_in, in0_c4, in1_c7, in1_c1, in2_c6, in2_c2, in3_c3, in3_c5, in4_c4, in5_c3, in5_c5, in6_c6, in6_c2, in7_c7, in7_c1, in7_c8, in7_c9, in5_c10, in5_c11, in3_c10, in3_c11);
    
    register r0(clk, in0_c4, in0_c4_reg);
    register r1(clk, in1_c7, in1_c7_reg);
    register r2(clk, in1_c1, in1_c1_reg);
    register r3(clk, in2_c6, in2_c6_reg);
    register r4(clk, in2_c2, in2_c2_reg);
    register r5(clk, in3_c3, in3_c3_reg);
    register r6(clk, in3_c5, in3_c5_reg);
    register r7(clk, in4_c4, in4_c4_reg);
    register r8(clk, in5_c3, in5_c3_reg);
    register r9(clk, in5_c5, in5_c5_reg);
    register r10(clk, in6_c6, in6_c6_reg);
    register r11(clk, in6_c2, in6_c2_reg);
    register r12(clk, in7_c7, in7_c7_reg);
    register r13(clk, in7_c1, in7_c1_reg);
    
    register r14(clk, in1_c8, in1_c8_reg);
    register r15(clk, in1_c9, in1_c9_reg);
    register r16(clk, in7_c8, in7_c8_reg);
    register r17(clk, in7_c9, in7_c9_reg);
    register r18(clk, in5_c10, in5_c10_reg);
    register r19(clk, in5_c11, in5_c11_reg);
    register r20(clk, in3_c10, in3_c10_reg);
    register r21(clk, in3_c11, in3_c11_reg);
    
    idct_add0 add0(in0_c4_reg, in1_c7_reg, in1_c1_reg, in2_c6_reg, in2_c2_reg, in3_c3_reg, in3_c5_reg, in4_c4_reg, in5_c3_reg, in5_c5_reg, in6_c6_reg, in6_c2_reg, in7_c7_reg, in7_c1_reg, in1_c8_reg, in1_c9_reg, in7_c8_reg, in7_c9_reg, in5_c10_reg, in5_c11_reg, in3_c10_reg, in3_c11_reg, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11);
    
    register r22(clk, s0, s0_reg);
    register r23(clk, s1, s1_reg);
    register r24(clk, s2, s2_reg);
    register r25(clk, s3, s3_reg);
    register r26(clk, s4, s4_reg);
    register r27(clk, s5, s5_reg);
    register r28(clk, s6, s6_reg);
    register r29(clk, s7, s7_reg);
    register r30(clk, s8, s8_reg);
    register r31(clk, s9, s9_reg);
    register r32(clk, s10, s10_reg);
    register r33(clk, s11, s11_reg);
    
    idct_add1 add1(s0_reg, s1_reg, s2_reg, s3_reg, s4_reg, s5_reg, s6_reg, s7_reg, s8_reg, s9_reg, s10_reg, s11_reg, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9);
    
    register r34(clk, t0, t0_reg);
    register r35(clk, t1, t1_reg);
    register r36(clk, t2, t2_reg);
    register r37(clk, t3, t3_reg);
    register r38(clk, t4, t4_reg);
    register r39(clk, t5, t5_reg);
    register r40(clk, t6, t6_reg);
    register r41(clk, t7, t7_reg);
    register r42(clk, t8, t8_reg);
    register r43(clk, t9, t9_reg);
    
    assign t8_181 = t8_reg*181;
    assign t9_181 = t9_reg*181;
    
    SRA shifter0(t8_181, 32'd8, t8_181_shifted);
    SRA shifter1(t9_181, 32'd8, t9_181_shifted);
    
    register r44(clk, t8_181_shifted, t8_reg2);
    register r45(clk, t9_181_shifted, t9_reg2);
    
    register r46(clk, t0_reg, t0_reg2);
    register r47(clk, t1_reg, t1_reg2);
    register r48(clk, t2_reg, t2_reg2);
    register r49(clk, t3_reg, t3_reg2);
    register r50(clk, t4_reg, t4_reg2);
    register r51(clk, t5_reg, t5_reg2);
    register r52(clk, t6_reg, t6_reg2);
    register r53(clk, t7_reg, t7_reg2);
    
    idct_add2 add2(t0_reg2, t1_reg2, t2_reg2, t3_reg2, t4_reg2, t5_reg2, t6_reg2, t7_reg2, t8_reg2, t9_reg2, o0, o1, o2, o3, o4, o5, o6, o7);
    
    SRA shifter2(o0, shift_amount, o0_shifted);
    SRA shifter3(o1, shift_amount, o1_shifted);
    SRA shifter4(o2, shift_amount, o2_shifted);
    SRA shifter5(o3, shift_amount, o3_shifted);
    SRA shifter6(o4, shift_amount, o4_shifted);
    SRA shifter7(o5, shift_amount, o5_shifted);
    SRA shifter8(o6, shift_amount, o6_shifted);
    SRA shifter9(o7, shift_amount, o7_shifted);
        
    assign data_out = {o7_shifted[7:0], o6_shifted[7:0], o5_shifted[7:0], o4_shifted[7:0], o3_shifted[7:0], o2_shifted[7:0], o1_shifted[7:0], o0_shifted[7:0]};
    
    reg_bit r54(clk, s_valid, s_valid_reg);
    reg_bit r55(clk, s_valid_reg, s_valid_reg2);
    reg_bit r56(clk, s_valid_reg2, s_valid_reg3);
    reg_bit r57(clk, s_valid_reg3, m_valid);
    
endmodule
