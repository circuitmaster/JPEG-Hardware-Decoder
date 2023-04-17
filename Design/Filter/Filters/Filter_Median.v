`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Filter_Median
// Description: Performs Median Filtering operation
//////////////////////////////////////////////////////////////////////////////////
module Filter_Median (
    input [71:0] image_in, //Input Matrix
    output reg[7:0] pixel_out //Output Matrix
);

parameter SIZE = 3; //Variable kernel size

//Temporary buffers to use in operations
reg [7:0] buffer [SIZE-1:0][SIZE-1:0];
reg [7:0] temp_buffer [SIZE*SIZE-1:0];

integer i, j, k;
integer n = SIZE*SIZE;
integer m = 4;//Middle element index for size=3
integer p, q;
reg [7:0] t; //Temporary holder

// Buffering the input
always @(*)
begin
    for (i = 0; i < SIZE; i = i + 1)
    begin
        for (j = 0; j < SIZE; j = j + 1)
        begin
            buffer[i][j] = image_in[i*SIZE*8+j*8+:8];
        end
    end
end

// Sort the elements in the buffer
always @(*)
begin
    for (i = 0; i < SIZE*SIZE; i = i + 1)
    begin
        temp_buffer[i] = buffer[i/SIZE][i%SIZE];
    end

    for (p = 0; p < n-1; p = p + 1)
    begin
        for (q = p+1; q < n; q = q + 1)
        begin
            //Swapping the elements
            if (temp_buffer[p] > temp_buffer[q])
            begin
                t = temp_buffer[p];
                temp_buffer[p] = temp_buffer[q];
                temp_buffer[q] = t;
            end
        end
    end
    
    //Median element in the swapped matrix
    pixel_out = temp_buffer[m];
end

endmodule