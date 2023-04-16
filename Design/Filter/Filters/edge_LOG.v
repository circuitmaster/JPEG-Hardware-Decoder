`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: edge_LOG
// Description: Performs Lapplacian of Gaussian Operation
//////////////////////////////////////////////////////////////////////////////////


module Edge_Log(
    input [199:0] image_in, //Input Matrix
    output [7:0] pixel_out //Output Matrix
);
    // Temporary registers for paralelization
    wire [15:0] tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
    
    //Directly writing the values for 5x5 kernel, where the values are hand-calculated
    wire [15:0] el1 = -1*image_in[7:0]; 
    wire [15:0] el2 = -3*image_in[15:8]; 
    wire [15:0] el3 = -4*image_in[23:16]; 
    wire [15:0] el4 = -3*image_in[31:24]; 
    wire [15:0] el5 = -1*image_in[39:32]; 

    wire [15:0] el6 = -3*image_in[47:40]; 
    wire [15:0] el7 = 0*image_in[55:48]; 
    wire [15:0] el8 = 6*image_in[63:56]; 
    wire [15:0] el9 = 0*image_in[71:64]; 
    wire [15:0] el10 = -3*image_in[79:72]; 

    wire [15:0] el11 = -4*image_in[87:80]; 
    wire [15:0] el12 = 6*image_in[95:88]; 
    wire [15:0] el13 = 20*image_in[103:96]; 
    wire [15:0] el14 = 6*image_in[111:104]; 
    wire [15:0] el15 = -4*image_in[119:112]; 

    wire [15:0] el16 = -3*image_in[127:120]; 
    wire [15:0] el17 = 0*image_in[135:128]; 
    wire [15:0] el18 = 6*image_in[143:136]; 
    wire [15:0] el19 = 0*image_in[151:144]; 
    wire [15:0] el20 = -3*image_in[159:152]; 

    wire [15:0] el21 = -1*image_in[167:160]; 
    wire [15:0] el22 = -3*image_in[175:168]; 
    wire [15:0] el23 = -4*image_in[183:176]; 
    wire [15:0] el24 = -3*image_in[191:184]; 
    wire [15:0] el25 = -1*image_in[199:192]; 
    
    
    assign tmp1 = el1 + el2 + el3 + el4 + el5;
    assign tmp2 = el6 + el7 + el8 + el9 + el10;
    assign tmp3 = el11 + el12 + el13 + el14 + el15;
    assign tmp4 = el16 + el17 + el18 + el19 + el20;
    assign tmp5 = el21 + el22 + el23 + el24 + el25;
    assign tmp6 = tmp1 + tmp2 + tmp3 + tmp4 + tmp5;
    
    assign tmp7 = (tmp6 > 0) ? tmp6 : - tmp6; 
    
    assign pixel_out = tmp7[11:4] + image_in[103:96];
    
endmodule
