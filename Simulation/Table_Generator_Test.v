`timescale 1ns / 100ps

module Table_Generator_Test;
    //Period of the clock
    localparam PERIOD = 100;

    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg [3:0]r_value = 4'b0;
    reg [7:0]coefficient = 7'b0;
    reg is_new_coefficient = 1'b0;
    
    //Outputs of the module
    wire [2047:0] value;
    wire valid;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;
   
    Table_Generator table_generator(
        .clk(clk), 
        .rst(rst),
        .is_new_coefficient(is_new_coefficient),
        .r_value(r_value),
        .value(calue),
        .valid(valid)
    );

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        //DETAILED EXAMPLES
        //DC coefficient is first element
        give_bit_sequence(4'b0, 8'b10101010);
        
        //
        give_bit_sequence(4'b0110, 8'b11110000);
        
        //
        give_bit_sequence(4'b1010, 8'b11001100);
        
        //
        give_bit_sequence(4'b0011, 8'b11010001);

    end
    
    //Gives bit sequence into table generator
    task give_bit_sequence(input reg[3:0] bit_sequence, input reg[7:0]  bit_seq_2); 
        integer i;
    begin
        r_value <= bit_sequence;
        coefficient <= bit_seq_2;
        is_new_coefficient <= 1'b1;
        #10;
        @(posedge clk);
        r_value <= 3'b0;
        coefficient <= 7'b0;
        is_new_coefficient <= 1'b0;
    end
    endtask    
    
endmodule
















