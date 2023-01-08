//////////////////////////////////////////////////////////////////////////////////
// Module Name: Number Decoder
// Description: Decodes given bit sequence into number
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Number_Decoder
#(
    parameter CODED_NUMBER_WIDTH = 12,
    parameter DECODED_NUMBER_WIDTH = 8
)(
    input [3:0] r_value,
    input [CODED_NUMBER_WIDTH-1:0] coded_number,
    output reg [DECODED_NUMBER_WIDTH-1:0] decoded_number
);
    reg [CODED_NUMBER_WIDTH-1:0] incremented_coded_number;

    integer i;
    always @(*) begin
        incremented_coded_number <= coded_number + 1;
    
        for(i=0; i<CODED_NUMBER_WIDTH; i=i+1) begin
            if(i < DECODED_NUMBER_WIDTH) begin
                if(i < r_value) begin
                    if(coded_number[r_value-1] == 0) begin
                        decoded_number[i] <= incremented_coded_number[i];
                    end else begin
                        decoded_number[i] <= coded_number[i];
                    end 
                end else begin
                    if(coded_number[r_value-1] == 0) begin
                        decoded_number[i] <= 1'b1;
                    end else begin
                        decoded_number[i] <= 1'b0;
                    end 
                end
            end
        end
        
    end

endmodule