module Rounder (
  input [31:0] x,
  output reg [31:0] y
);

  reg [30:0] frac; // fractional part
  reg carry; // carry bit

  always @* begin
    if (x[30:0] >= 2**30) begin
      frac = x[30:0] - 2**30;
      carry = 1;
    end else begin
      frac = x[30:0];
      carry = 0;
    end

    if (carry == 1) begin
      if (frac[0] == 1) begin
        y = {x[31], (frac >> 1) + 1};
      end else begin
        y = {x[31], frac >> 1};
      end
    end else begin
      y = {x[31], frac >> 1};
    end
  end

endmodule