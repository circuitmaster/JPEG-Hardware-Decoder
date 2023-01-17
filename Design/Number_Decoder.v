//////////////////////////////////////////////////////////////////////////////////
// Module Name: Number Decoder
// Description: Decodes given bit sequence into number
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Number_Decoder
#(
    parameter CODED_NUMBER_WIDTH = 11,
    parameter DECODED_NUMBER_WIDTH = 8
)(
    input [3:0] r_value,                                    //Number length (Bit length of the number after zeros)
    input [CODED_NUMBER_WIDTH-1:0] coded_number,            //bit sequencse that encodes number
    output reg [DECODED_NUMBER_WIDTH-1:0] decoded_number    //number in 2s complement form
);
    reg [CODED_NUMBER_WIDTH-1:0] incremented_coded_number;  //coded_number + 1

    integer i;
    always @(*) begin
        incremented_coded_number <= coded_number + 1;
        
        //If r value is 0 than decoded number is 0
        //Otherwise conversion is like that:
        // 011
        // |
        // last digit is 0 so add 1 to number (result = 100)
        // decoded number is 8 bit so fill remaining parts with 1 (result = 11111100)
        //
        // 101
        // |
        // last digit is 1, don't add anything
        // decoded number is 8 bit so fill remaining pars with 0 (result = 00000101)
        // 
        //Code below does this conversion
        for(i=0; i<CODED_NUMBER_WIDTH; i=i+1) begin
            if(i < DECODED_NUMBER_WIDTH) begin
                if(r_value == 0) begin
                    decoded_number[i] <= 1'b0;
                end else if(i < r_value) begin
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