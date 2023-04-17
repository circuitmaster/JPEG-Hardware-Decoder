module Prio_RAM_Encoder (
  input wire clk,
  input wire m1_en,
  input wire m2_en,
  output wire ram_en
);

reg current_user;

always @(posedge clk) begin
  if (m1_en && !m2_en)
    current_user <= 1'b0;
  else if (!m1_en && m2_en)
    current_user <= 1'b1;
  else if (m1_en && m2_en)
    current_user <= 1'b0; 
end

assign ram_en = (current_user == 1'b1 && m1_en) || (current_user == 1'b0 && m2_en);
endmodule
