//////////////////////////////////////////////////////////////////////////////////
// Module Name: DC Huffman Table
// Description: Maps encoded input sequence into output values (R-S values)
//              for DC by using Huffman algorithm
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module DC_Huffman_Table (
    input bit,                  //Encoded bit sequence
    input [3:0] state,
    output reg [3:0] r_value,   //Run length (Count of zeros before number)
    output reg [3:0] s_value,   //Number length (Bit length of the number after zeros)
    output reg [3:0] next_state
);

    //Maps input sequence to output values (S-R values)
    always @(*)begin
        r_value <= 4'b0;
        s_value <= 4'b0;    
        next_state <= 0;

        case(state)
            0: begin
                //none 
                if(bit == 0)begin
                    next_state <= 1;
                end else begin
                    next_state <= 3;
                end
            end
            1: begin
                //0
                if(bit == 0) begin
                    r_value <= 4'd0;
                    s_value <= 4'd0;
                    next_state <= 0;
                end else begin
                    next_state <= 2;
                end
            end
            2: begin
                //01
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd1;
                    next_state <= 0;
                end else begin
                    r_value <= 4'd0;
                    s_value <= 4'd2;
                    next_state <= 0;
                end
            end
            3: begin
                //1
                if(bit == 0)begin
                    next_state <= 4;
                end else begin
                    next_state <= 5;
                end
            end
            4: begin
                //10
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd3;
                    next_state <= 0;
                end else begin
                    r_value <= 4'd0;
                    s_value <= 4'd4;
                    next_state <= 0;
                end
            end
            5: begin
                //11
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd5;
                    next_state <= 0;
                end else begin
                    next_state <= 6;
                end
            end
            6: begin
                //111
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd6;
                    next_state <= 0;
                end else begin
                    next_state <= 7;
                end
            end
            7: begin
                //1111
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd7;
                    next_state <= 0;
                end else begin
                    next_state <= 8;
                end
            end
            8: begin
                //11111
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd8;
                    next_state <= 0;
                end else begin
                    next_state <= 9;
                end
            end
            9: begin
                //111111
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd9;
                    next_state <= 0;
                end else begin
                    next_state <= 10;
                end
            end
            10: begin
                //1111111
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd10;
                    next_state <= 0;
                end else begin
                    next_state <= 11;
                end
            end
            11: begin
                //11111111
                if(bit == 0)begin
                    r_value <= 4'd0;
                    s_value <= 4'd10;
                    next_state <= 0;
                end else begin
                    next_state <= 0;
                end
            end
        endcase
    end

endmodule