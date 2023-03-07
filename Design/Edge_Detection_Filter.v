module edge_detection_filter_x(
    input [199:0] image_in, //Input Matrix
    
    output [7:0] pixel_out //Output Matrix
);
    // Gaussian blur kernel
    // reg [7:0] edge_x = {8'd1,8'd2,8'd1,8'd2,8'd4,8'd2,8'd1,8'd2,8'd1};
    
    wire [15:0] first_row1 = -image_in[7:0] - 2*image_in[15:8];
    wire [15:0] first_row2 = 2 * image_in[31:24] + image_in[39:32];
    wire [15:0] second_row1 = -4*image_in[7+40:40] - 8*image_in[15+40:8+40];
    wire [15:0] second_row2 = 8*image_in[31+40:24+40] + 4*image_in[39+40:32+40];
    wire [15:0] third_row1 = -6*image_in[7+80:80] - 12*image_in[15+80:8+80];
    wire [15:0] third_row2 = 12*image_in[31+80:24+80] + 6*image_in[39+80:32+80];
    wire [15:0] fourth_row1 = -4*image_in[7+120:120] - 8*image_in[15+120:8+120];
    wire [15:0] fourth_row2 = 8*image_in[31+120:24+120] + 4*image_in[39+120:32+120];
    wire [15:0] fifth_row1 = -image_in[7+160:160] - 2*image_in[15+160:8+160];
    wire [15:0] fifth_row2 = 2*image_in[31+160:24+160] + image_in[39+160:32+160];
    
    wire [15:0] first_row = first_row1 + first_row2;
    wire [15:0] second_row = second_row1 + second_row2;
    wire [15:0] third_row = third_row1 + third_row2;
    wire [15:0] fourth_row = fourth_row1 + fourth_row2;
    wire [15:0] fifth_row = fifth_row1 + fifth_row2;
    
    assign pixel_out = first_row + second_row + third_row + fourth_row + fifth_row;
    
endmodule

module edge_detection_filter_y(
    input [199:0] image_in, //Input Matrix
    
    output [7:0] pixel_out //Output Matrix
);
    // Gaussian blur kernel
    // reg [7:0] edge_x = {8'd1,8'd2,8'd1,8'd2,8'd4,8'd2,8'd1,8'd2,8'd1};
    
     wire [15:0] first_col1 = -image_in[7:0] - 2*image_in[47:40];
    wire [15:0] first_col2 = 2 * image_in[127:120] + image_in[167:160];
    wire [15:0] second_col1 = -4*image_in[15:8] - 8*image_in[55+48];
    wire [15:0] second_col2 = 8*image_in[135:128] + 4*image_in[175:168];
    wire [15:0] third_col1 = -6*image_in[23:16] - 12*image_in[63:56];
    wire [15:0] third_col2 = 12*image_in[143:136] + 6*image_in[183:176];
    wire [15:0] fourth_col1 = -4*image_in[31:24] - 8*image_in[71:64];
    wire [15:0] fourth_col2 = 8*image_in[151:144] + 4*image_in[191:184];
    wire [15:0] fifth_col1 = -image_in[39:32] - 2*image_in[79:72];
    wire [15:0] fifth_col2 = 2*image_in[169:162] + image_in[199:192];
    
    wire [15:0] first_col = first_col1 + first_col2;
    wire [15:0] second_col = second_col1 + second_col2;
    wire [15:0] third_col = third_col1 + third_col2;
    wire [15:0] fourth_col = fourth_col1 + fourth_col2;
    wire [15:0] fifth_col = fifth_col1 + fifth_col2;

    assign pixel_out = first_col + second_col + third_col + fourth_col + fifth_col;
    
endmodule

module edge_detection_filter_log(
    input [199:0] image_in, //Input Matrix
    
    output [7:0] pixel_out //Output Matrix
);
    // Gaussian blur kernel
    // reg [7:0] edge_x = {8'd1,8'd2,8'd1,8'd2,8'd4,8'd2,8'd1,8'd2,8'd1};
    
    wire [7:0] el1 = -1*image_in[7:0]; 
    wire [7:0] el2 = -3*image_in[15:8]; 
    wire [7:0] el3 = -4*image_in[23:16]; 
    wire [7:0] el4 = -3*image_in[31:24]; 
    wire [7:0] el5 = -1*image_in[39:32]; 

    wire [7:0] el6 = -3*image_in[47:40]; 
    wire [7:0] el7 = 0*image_in[55:48]; 
    wire [7:0] el8 = 6*image_in[63:56]; 
    wire [7:0] el9 = 0*image_in[71:64]; 
    wire [7:0] el10 = -3*image_in[79:72]; 

    wire [7:0] el11 = -4*image_in[87:80]; 
    wire [7:0] el12 = 6*image_in[95:88]; 
    wire [7:0] el13 = 21*image_in[103:96]; 
    wire [7:0] el14 = 6*image_in[111:104]; 
    wire [7:0] el15 = -4*image_in[119:112]; 

    wire [7:0] el16 = -3*image_in[127:120]; 
    wire [7:0] el17 = 0*image_in[135:128]; 
    wire [7:0] el18 = 6*image_in[143:136]; 
    wire [7:0] el19 = 0*image_in[151:144]; 
    wire [7:0] el20 = -3*image_in[159:152]; 

    wire [7:0] el21 = -1*image_in[167:160]; 
    wire [7:0] el22 = -3*image_in[175:168]; 
    wire [7:0] el23 = -4*image_in[183:176]; 
    wire [7:0] el24 = -3*image_in[191:184]; 
    wire [7:0] el25 = -1*image_in[199:192]; 

    assign pixel_out = el1 + el2 + el3 + el4 + el5 + el6 + el7 + el8 + el9 + el10 + el11 + el12 + el13 + el14 + el15 + el16 + el17 + el18 + el19 + el20 + el21 + el22 + el23 + el24 + el25;
    
endmodule