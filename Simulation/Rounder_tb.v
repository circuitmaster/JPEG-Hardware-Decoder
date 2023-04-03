module Rounder_tb;

  // Declare inputs and outputs
  reg [31:0] x;
  reg [31:0] y_expected;
  wire [31:0] y_actual;


  Rounder uut (
    .x(x),
    .y(y_actual)
  );

  // Initialize inputs
  initial begin
    x = 32'h80000001; // -2.5
    y_expected = 32'h80000000; // -2
    #1; 
    
  end

endmodule