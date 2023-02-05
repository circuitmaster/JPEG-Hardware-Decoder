module Histogram_Generator (
  input wire [63:0] matrix, //Input image 
  output wire [255:0] histogram //Output hist
);

// Initial zero
reg [255:0] histogram_reg = 0;
reg [63:0] matrix_reg;

integer i;
integer j;

always @* begin
  for (i = 0; i < 63; i = i+1) begin
      matrix_reg[i] <= matrix[i];
    end
  end

// Matrix iteration
always @* begin
  for (j = 0; j < 63; j = j+1) begin 
      histogram_reg[matrix_reg[j]] <= histogram_reg[matrix_reg[j]] + 1;
    end
  end
assign histogram = histogram_reg;
endmodule