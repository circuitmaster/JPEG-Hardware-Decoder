//////////////////////////////////////////////////////////////////////////////////
// Module Name: Table Generator
// Description: Generates table from generated numbers
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Table_Generator(
    input clk, rst,
    input [3:0] r_value,            //Indicates run length of coefficient
    input [7:0] coefficient,        //Coefficient inferred from encoded image sequence
    input is_new_coefficient,       //Indicates if coefficient is valid

    //Each row is given as outputs
    output reg[64*8-1:0] table_value,
    output reg valid
);
    
    //Zig Zag index parameters
    parameter [0:64*8-1] zigzag_params = {
        8'd0,   8'd1,   8'd8,   8'd16,  8'd9,   8'd2,   8'd3,   8'd10,
        8'd17,  8'd24,  8'd32,  8'd25,  8'd18,  8'd11,  8'd4,   8'd5,
        8'd12,  8'd19,  8'd26,  8'd33,  8'd40,  8'd48,  8'd41,  8'd34,
        8'd27,  8'd20,  8'd13,  8'd6,   8'd7,   8'd14,  8'd21,  8'd28,
        8'd35,  8'd42,  8'd49,  8'd56,  8'd57,  8'd50,  8'd43,  8'd36,
        8'd29,  8'd22,  8'd15,  8'd23,  8'd30,  8'd37,  8'd44,  8'd51,
        8'd58,  8'd59,  8'd52,  8'd45,  8'd38,  8'd31,  8'd39,  8'd46,
        8'd53,  8'd60,  8'd61,  8'd54,  8'd47,  8'd55,  8'd62,  8'd63
    };
    
    //Quantization parameters
    parameter [0:64*8-1] quantization_params = {
        8'd16,  8'd11,  8'd10,  8'd16,  8'd24,  8'd40,  8'd51,  8'd61,
        8'd12,  8'd12,  8'd14,  8'd19,  8'd26,  8'd58,  8'd60,  8'd55,
        8'd14,  8'd13,  8'd16,  8'd24,  8'd40,  8'd57,  8'd69,  8'd56,
        8'd14,  8'd17,  8'd22,  8'd29,  8'd51,  8'd87,  8'd80,  8'd62,
        8'd18,  8'd22,  8'd37,  8'd56,  8'd68,  8'd109, 8'd103, 8'd77,
        8'd24,  8'd35,  8'd55,  8'd64,  8'd81,  8'd104, 8'd113, 8'd92,
        8'd49,  8'd64,  8'd78,  8'd87,  8'd103, 8'd121, 8'd120, 8'd101,
        8'd72,  8'd92,  8'd95,  8'd98,  8'd112, 8'd100, 8'd103, 8'd99
    };
    
    //Zig Zag params memory
    reg[7:0] zigzag_params_memory [0:63];
    
    //Quantization params memory
    reg[7:0] quantization_params_memory [0:63];
    
    //Table memory 
    reg[7:0] table_memory [0:63];
    
    //Internal registers
    reg[6:0] counter;
    reg valid_reg;
    
    //Internal wires
    reg[6:0] next_counter;
    reg[7:0] quantization_param;
    reg signed[15:0] multiplication_result;
    
    // Previous DC value
    reg [7:0] prev_dc_val;
    wire [7:0] real_coefficient;
    
    assign real_coefficient = coefficient + prev_dc_val;
    
    integer i;
    initial begin
        for(i=0; i<64; i=i+1) begin
            zigzag_params_memory[i] <= zigzag_params[i*8 +: 8];
            quantization_params_memory[i] <= quantization_params[i*8 +: 8];
            table_memory[i] <= 8'd0;
        end
    end
    
    always @(*) begin
        valid <= valid_reg;
        quantization_param <= quantization_params_memory[zigzag_params_memory[counter+r_value]];
        
        if(counter == 0) begin
            multiplication_result <= {{8{real_coefficient[7]}}, real_coefficient} * {{8{quantization_param[7]}}, quantization_param};
        end else begin
            multiplication_result <= {{8{coefficient[7]}}, coefficient} * {{8{quantization_param[7]}}, quantization_param};
        end
        
        for(i=0; i<64; i = i + 1) begin
            table_value[i*8 +: 8] <= table_memory[i];
        end
        
        if(counter + r_value + 1 == 7'd64 || (counter != 7'b0 && r_value == 4'b0 && coefficient == 8'b0)) begin
            next_counter <= 7'b0;
        end else begin
            next_counter <= counter + r_value + 1;
        end
    end 

    //Control Flow
    always @(posedge clk) begin
        if(rst) begin
            counter <= 7'b0;
            valid_reg <= 1'b0;
            prev_dc_val <= 8'b0;
        end else begin
            valid_reg <= 1'b0;
            
            if (is_new_coefficient) begin 
                if(counter == 7'b0) begin
                    reset_table_memory;
                    prev_dc_val <= prev_dc_val + coefficient;
                end
            
                if(multiplication_result > $signed(16'd127)) begin
                    table_memory[zigzag_params_memory[counter+r_value]] <= 8'd127;
                end else if(multiplication_result < $signed(-16'd128)) begin
                    table_memory[zigzag_params_memory[counter+r_value]] <= -8'd128;
                end else begin
                    table_memory[zigzag_params_memory[counter+r_value]] <= multiplication_result;
                end
                counter <= next_counter;
                
                if(next_counter == 7'b0) begin
                    valid_reg <= 1'b1;
                end
             end        
        end
    end
    
    task reset_table_memory;
        for(i=0; i<64; i = i + 1) begin
            table_memory[i] <= 8'd0;
        end
    endtask
endmodule