//////////////////////////////////////////////////////////////////////////////////
// Module Name: Number Generator
// Description: Generates number from endecoded image sequence
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Number_Generator(
    input clk, rst,
    input bit_input,                    //Next input bit in the encoded image
    input is_new_bit,                   //Indicates if given bit input is valid
    output reg[3:0] r_value,            //Indicates run length of coefficient
    output reg[7:0] coefficient,        //Coefficient inferred from encoded image sequence
    output reg is_new_coefficient       //Indicates if coefficient is valid
);
    //States
    localparam HUFFMAN_DECODE_STATE = 0;
    localparam NUMBER_DECODE_STATE = 1;
    
    //Signals between modules          
    wire[3:0] r_value_huffman;      //R value coming from huffman decoder
    wire[3:0] s_value_huffman;      //S value coming from huffman decoder
    wire done_huffman;              //Done signal coming from huffman decoder
    wire[7:0] decoded_number;       //Decoded number that goes into table generator
    reg ac_dc_huffman;              //Selects which table will be used for decoding in huffman decoder
    reg bit_huffman;                //Next bit goes into huffman decoder
    reg is_new_bit_huffman;         //Indicates if given huffman bit output is valid
    reg[10:0] coded_number;         //Coded number goes into number decoder
    reg[3:0] s_value;               //S value goes into number decoder
    
    //Internal Signals
    reg EOB;                            //End of block signal
    reg ZRL;                            //Indicates there is 16 zeros 
    reg[5:0] next_coefficient_index;    //Incremented version of coefficient index. Incremented by r_value_reg+1
    
    //Registers
    reg state;                      //State of number generation
    reg[5:0] coefficient_index;     //Index of coefficient in the block
    reg[10:0] coded_number_reg;     //Holds encoded number
    reg[3:0] coded_number_index;    //Holds which coded number slot will be filled when new bit comes
    reg[3:0] r_value_reg;           //Holds r value coming from huffman decoder
    reg[3:0] s_value_reg;           //Holds s value coming from huffman decoder
    
    
    //Control signals
    always @(*) begin
        ac_dc_huffman <= 1'b0;
        bit_huffman <= bit_input;
        is_new_bit_huffman <= 1'b0;
        coded_number <= coded_number_reg;
        r_value <= 4'b0;
        s_value <= s_value_reg;
        coefficient <= 8'b0;
        is_new_coefficient <= 1'b0;
   
        EOB <= r_value_huffman == 4'b0 && s_value_huffman == 4'b0;          //End of Block signal indicates that 8x8 block coefficients are ended
        ZRL <= r_value_huffman == 4'd15 && s_value_huffman == 4'b0;         //Indicates there are 16 zeros in the table
        next_coefficient_index <= coefficient_index + r_value_reg + 1;      //coefficient index will be updated based on the run length
 
        case(state)
            HUFFMAN_DECODE_STATE: begin
                //Lead new bits into huffman decoder in this state
                is_new_bit_huffman <= is_new_bit;
                ac_dc_huffman <= coefficient_index == 6'b0 ? 1'b1 : 1'b0;
                
                if(done_huffman) begin
                    if(EOB) begin
                        //Output EOB value
                        ac_dc_huffman <= 1'b1;
                        r_value <= 4'b0;
                        coefficient <= 8'b0;
                        is_new_coefficient <= 1'b1;
                    end else if(ZRL) begin
                        //Output ZRL value (16 zeros)
                        r_value <= 4'd15;
                        coefficient <= 8'b0;
                        is_new_coefficient <= 1'b1;
                    end else begin
                        //There is a number after R-S values so prevent new bits going into huffman decoder
                        is_new_bit_huffman <= 1'b0;
                    end
                end
            end
            NUMBER_DECODE_STATE: begin
                if(coded_number_index == 4'b1111) begin
                    //Number decoding is finished but there can be new bits, so lead them to huffman decoder
                    is_new_bit_huffman <= is_new_bit;
                    ac_dc_huffman <= next_coefficient_index == 6'd63 ? 1'b1 : 1'b0;
                    
                    //Index is smaller than zero so coefficient is decoded, Output it
                    r_value <= r_value_reg;
                    coefficient <= decoded_number;
                    is_new_coefficient <= 1'b1;
                end
            end
        endcase
    end
    
    //Controller
    always @(posedge clk) begin
        if(rst) begin
            state <= HUFFMAN_DECODE_STATE;
            coefficient_index <= 6'b0;
            coded_number_reg <= 11'b0;
            coded_number_index <= 4'b0;
            r_value_reg <= 4'b0;
            s_value_reg <= 4'b0;
        end else begin
            case(state)
                HUFFMAN_DECODE_STATE: begin
                    if(done_huffman) begin
                        if(EOB) begin
                            //Block is finished reset coefficient index to 0
                            coefficient_index <= 6'b0;
                        end else if(ZRL) begin
                            //Coefficient index is icremented by 16 because of 16 zeros
                            coefficient_index <= coefficient_index + 6'd16;
                        end else begin
                            //Save R-S values into register
                            r_value_reg <= r_value_huffman;
                            s_value_reg <= s_value_huffman;
                            
                            //If new bit is came right now save it into coded number register.
                            //Otherwise just initialize coded number index (Incoming bits are saved from left to right)
                            if(is_new_bit) begin
                                coded_number_reg[s_value_huffman-1] <= bit_input;
                                coded_number_index <= s_value_huffman-2;
                            end else begin
                                coded_number_index <= s_value_huffman-1;
                            end
                            
                            state <= NUMBER_DECODE_STATE;
                        end
                    end
                end
                NUMBER_DECODE_STATE: begin
                    //If coded number index is greater or equal to 0 than continue to get bits.
                    //Otherwise finish number decoding state and update coefficient index
                    if(coded_number_index != 4'b1111) begin
                        if(is_new_bit) begin
                            coded_number_reg[coded_number_index] <= bit_input;
                            coded_number_index <= coded_number_index - 1;
                        end
                    end else begin
                        if(next_coefficient_index == 6'd63) begin
                            coefficient_index <= 6'b0;
                        end else begin
                            coefficient_index <= next_coefficient_index;
                        end
                    
                        state <= HUFFMAN_DECODE_STATE;
                    end
                end
            endcase
        end
    end
    
    Huffman_Decoder huffman_decoder(
        .clk(clk),
        .rst(rst),
        .ac_dc_flag(ac_dc_huffman),
        .next_bit(bit_huffman),
        .is_new(is_new_bit_huffman),
        .r_value(r_value_huffman),
        .s_value(s_value_huffman),
        .done(done_huffman)
    );
    
    Number_Decoder number_decoder(
        .s_value(s_value),
        .coded_number(coded_number),
        .decoded_number(decoded_number)
    );
    
endmodule

















