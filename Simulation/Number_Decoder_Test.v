`timescale 1ns / 1ps

module Number_Decoder_Test;
    //Registers given as input to the module
    reg[3:0] r_value;
    reg[11:0] coded_number;
    
    //Outputs of the module
    wire[7:0] decoded_number;
    
    Number_Decoder number_decoder(
        .r_value(r_value),
        .coded_number(coded_number),
        .decoded_number(decoded_number)
    );

    initial begin
        r_value <= 4'd1;
        coded_number <= 12'b0;
        #10
        r_value <= 4'd2;
        coded_number <= 12'b0;
        #10
        r_value <= 4'd1;
        coded_number <= 12'b1;
        #10
        r_value <= 4'd2;
        coded_number <= 12'b1;
        #10
        r_value <= 4'd4;
        coded_number <= 12'b101;
        #10
        r_value <= 4'd0;
        coded_number <= 12'b101;
    end
    
endmodule