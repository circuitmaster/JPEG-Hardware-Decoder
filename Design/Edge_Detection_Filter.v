module edge_detection_filter(
    input wire clk,
    input wire reset,
    input wire [63:0] image_in[7:0], //Input Matrix
    
    output reg [7:0] image_out[7:0] //Output Matrix
);
    // Gaussian blur kernel
    reg  [7:0]gauss_kernel = {1,2,1,2,4,2,1,2,1};

    // Sobel X direction kernel
    reg [7:0] sobel_x = {-1,0,1,-2,0,2,-1,0,1};
    // Sobel Y direction kernel
    reg [7:0] sobel_y = {-1,-2,-1,0,0,0,1,2,1};

    // Temp
    reg [7:0] tmp_matrix[7:0][7:0];
    reg [7:0] tmp_matrix_2[7:0][7:0];
	integer i;
	integer j;
    // Convolution operation
    always @(posedge clk) begin
        if (reset) begin
            // Reset the matrix
            for (i = 0; i < 8; i = i+1) begin
                for ( j = 0; j < 8; j = j+1) begin
                    tmp_matrix[i][j] <= 0;
                end
            end
        end else begin
            // Perform Gaussian blur
            for (i = 0; i < 8; i = i+1) begin
                for ( j = 0; j < 8; j = j+1) begin
                    tmp_matrix[i][j] <= (
                        gauss_kernel[0] * image_in[i][j] +
                        gauss_kernel[1] * image_in[i][j+1] +
                        gauss_kernel[2] * image_in[i][j+2] +
                        gauss_kernel[3] * image_in[i+1][j] +
                        gauss_kernel[4] * image_in[i+1][j+1] +
                        gauss_kernel[5] * image_in[i+1][j+2] +
                        gauss_kernel[6] * image_in[i+2][j] +
                        gauss_kernel[7] * image_in[i+2][j+1] +
                        gauss_kernel[8] * image_in[i+2][j+2]
                    ) / 16;
                end
            end
            // Perform Sobel X direction
            for ( i = 0; i < 8; i = i+1) begin
                for ( j = 0; j < 8; j = j+1) begin
                    tmp_matrix_2[i][j] <= (
                       sobel_x[0] * tmp_matrix[i][j] +
                       sobel_x[1] * tmp_matrix[i][j+1] +
                       sobel_x[2] * tmp_matrix[i][j+2] +
                       sobel_x[3] * tmp_matrix[i+1][j] +
                       sobel_x[4] * tmp_matrix[i+1][j+1] +
                       sobel_x[5] * tmp_matrix[i+1][j+2] +
                       sobel_x[6] * tmp_matrix[i+2][j] +
                       sobel_x[7] * tmp_matrix[i+2][j+1] +
                       sobel_x[8] * tmp_matrix[i+2][j+2]
					);
				end
			end
			//Perform Sobel Y direction
			for ( i = 0; i < 8; i = i+1) begin
                for ( j = 0; j < 8; j = j+1) begin
                    image_out[i][j] <= (
                       sobel_y[0] * tmp_matrix_2[i][j] +
                       sobel_y[1] * tmp_matrix_2[i][j+1] +
                       sobel_y[2] * tmp_matrix_2[i][j+2] +
                       sobel_y[3] * tmp_matrix_2[i+1][j] +
                       sobel_y[4] * tmp_matrix_2[i+1][j+1] +
                       sobel_y[5] * tmp_matrix_2[i+1][j+2] +
                       sobel_y[6] * tmp_matrix_2[i+2][j] +
                       sobel_y[7] * tmp_matrix_2[i+2][j+1] +
                       sobel_y[8] * tmp_matrix_2[i+2][j+2]
					);
				end
			end
		end
	end
endmodule
