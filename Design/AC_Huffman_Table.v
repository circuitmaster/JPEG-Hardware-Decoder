//////////////////////////////////////////////////////////////////////////////////
// Module Name: AC Huffman Table
// Description: Maps encoded input sequence into output values (S-R values)
//              for AC by using Huffman algorithm
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module AC_Huffman_Table (
    input bit,                  //Encoded bit sequence
    input [7:0] state,
    output reg [3:0] s_value,   //Run length (Count of zeros before number)
    output reg [3:0] r_value,   //Number length (Bit length of the number after zeros)
    output reg is_valid,        //Indicates output values are valid
    output reg next_state
);

    //Maps input sequence to output values (S-R values)
    always @(*)begin
        s_value <= 4'b0;
        r_value <= 4'b0;
        next_state <= 0;

        case(state)
            0: begin
                //0
                if(bit == 0) begin
//                    s_value <= 4'd0;
//                    r_value <= 4'd1;
//                    next_state <= 0;
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            1: begin
                //1
                if(bit == 0) begin
                    next_state <= 2;
                end else begin
                    next_state <= 4;
                end
            end
            2: begin
                //10
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 3;
                end
            end
            3: begin
                //101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            4: begin
                //11
                if(bit == 0) begin
                    next_state <= 5;
                end else begin
                    next_state <= 7;
                end
            end
            5: begin
                //110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 6;
                end
            end
            6: begin
                //1101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            7: begin
                //111
                if(bit == 0) begin
                    next_state <= 38;
                end else begin
                    next_state <= 8;
                end
            end
            8: begin
                //1111
                if(bit == 0) begin
                    next_state <= 9;
                end else begin
                    next_state <= 11;
                end
            end
            9: begin
                //11110
                if(bit == 0) begin
                    next_state <= 10;
                end else begin
                    next_state <= 62;
                end
            end
            10: begin
                //111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            11: begin
                //11111
                if(bit == 0) begin
                    next_state <= 12;
                end else begin
                    next_state <= 14;
                end
            end
            12: begin
                //111110
                if(bit == 0) begin
                    next_state <= 13;
                end else begin
                    next_state <= 27;
                end
            end
            13: begin
                //1111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            14: begin
                //111111
                if(bit == 0) begin
                    next_state <= 15;
                end else begin
                    next_state <= 18;
                end
            end
            15: begin
                //1111110
                if(bit == 0) begin
                    next_state <= 88;
                end else begin
                    next_state <= 16;
                end
            end
            16: begin
                //11111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 17;
                end
            end
            17: begin
                //111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            18: begin
                //1111111
                if(bit == 0) begin
                    next_state <= 29;
                end else begin
                    next_state <= 19;
                end
            end
            19: begin
                //11111111
                if(bit == 0) begin
                    next_state <= 39;
                end else begin
                    next_state <= 20;
                end
            end
            20: begin
                //111111111
                if(bit == 0) begin
                    next_state <= 21;
                end else begin
                    next_state <= 97;
                end
            end
            21: begin
                //1111111110
                if(bit == 0) begin
                    next_state <= 22;
                end else begin
                    next_state <= 64;
                end
            end
            22: begin
                //11111111100
                if(bit == 0) begin
                    next_state <= 23;
                end else begin
                    next_state <= 47;
                end
            end
            23: begin
                //111111111000
                if(bit == 0) begin
                    next_state <= 24;
                end else begin
                    next_state <= 35;
                end
            end
            24: begin
                //1111111110000
                if(bit == 0) begin
                    next_state <= 25;
                end else begin
                    next_state <= 32;
                end
            end
            25: begin
                //11111111100000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 26;
                end
            end
            26: begin
                //111111111000001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            27: begin
                //1111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 28;
                end
            end
            28: begin
                //11111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            29: begin
                //11111110
                if(bit == 0) begin
                    next_state <= 54;
                end else begin
                    next_state <= 30;
                end
            end
            30: begin
                //111111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 31;
                end
            end
            31: begin
                //1111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            32: begin
                //11111111100001
                if(bit == 0) begin
                    next_state <= 33;
                end else begin
                    next_state <= 34;
                end
            end
            33: begin
                //111111111000010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            34: begin
                //111111111000011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            35: begin
                //1111111110001
                if(bit == 0) begin
                    next_state <= 36;
                end else begin
                    next_state <= 43;
                end
            end
            36: begin
                //11111111100010
                if(bit == 0) begin
                    next_state <= 37;
                end else begin
                    next_state <= 42;
                end
            end
            37: begin
                //111111111000100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            38: begin
                //1110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 46;
                end
            end
            39: begin
                //111111110
                if(bit == 0) begin
                    next_state <= 134;
                end else begin
                    next_state <= 40;
                end
            end
            40: begin
                //1111111101
                if(bit == 0) begin
                    next_state <= 41;
                end else begin
                    next_state <= 72;
                end
            end
            41: begin
                //11111111010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            42: begin
                //111111111000101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            43: begin
                //11111111100011
                if(bit == 0) begin
                    next_state <= 44;
                end else begin
                    next_state <= 45;
                end
            end
            44: begin
                //111111111000110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            45: begin
                //111111111000111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            46: begin
                //11101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            47: begin
                //111111111001
                if(bit == 0) begin
                    next_state <= 48;
                end else begin
                    next_state <= 56;
                end
            end
            48: begin
                //1111111110010
                if(bit == 0) begin
                    next_state <= 49;
                end else begin
                    next_state <= 52;
                end
            end
            49: begin
                //11111111100100
                if(bit == 0) begin
                    next_state <= 50;
                end else begin
                    next_state <= 51;
                end
            end
            50: begin
                //111111111001000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            51: begin
                //111111111001001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            52: begin
                //11111111100101
                if(bit == 0) begin
                    next_state <= 53;
                end else begin
                    next_state <= 55;
                end
            end
            53: begin
                //111111111001010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            54: begin
                //111111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            55: begin
                //111111111001011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            56: begin
                //1111111110011
                if(bit == 0) begin
                    next_state <= 57;
                end else begin
                    next_state <= 60;
                end
            end
            57: begin
                //11111111100110
                if(bit == 0) begin
                    next_state <= 58;
                end else begin
                    next_state <= 59;
                end
            end
            58: begin
                //111111111001100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            59: begin
                //111111111001101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            60: begin
                //11111111100111
                if(bit == 0) begin
                    next_state <= 61;
                end else begin
                    next_state <= 63;
                end
            end
            61: begin
                //111111111001110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            62: begin
                //111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            63: begin
                //111111111001111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            64: begin
                //11111111101
                if(bit == 0) begin
                    next_state <= 65;
                end else begin
                    next_state <= 81;
                end
            end
            65: begin
                //111111111010
                if(bit == 0) begin
                    next_state <= 66;
                end else begin
                    next_state <= 74;
                end
            end
            66: begin
                //1111111110100
                if(bit == 0) begin
                    next_state <= 67;
                end else begin
                    next_state <= 70;
                end
            end
            67: begin
                //11111111101000
                if(bit == 0) begin
                    next_state <= 68;
                end else begin
                    next_state <= 69;
                end
            end
            68: begin
                //111111111010000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            69: begin
                //111111111010001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            70: begin
                //11111111101001
                if(bit == 0) begin
                    next_state <= 71;
                end else begin
                    next_state <= 73;
                end
            end
            71: begin
                //111111111010010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            72: begin
                //11111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            73: begin
                //111111111010011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            74: begin
                //1111111110101
                if(bit == 0) begin
                    next_state <= 75;
                end else begin
                    next_state <= 78;
                end
            end
            75: begin
                //11111111101010
                if(bit == 0) begin
                    next_state <= 76;
                end else begin
                    next_state <= 77;
                end
            end
            76: begin
                //111111111010100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            77: begin
                //111111111010101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            78: begin
                //11111111101011
                if(bit == 0) begin
                    next_state <= 79;
                end else begin
                    next_state <= 80;
                end
            end
            79: begin
                //111111111010110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            80: begin
                //111111111010111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            81: begin
                //111111111011
                if(bit == 0) begin
                    next_state <= 82;
                end else begin
                    next_state <= 90;
                end
            end
            82: begin
                //1111111110110
                if(bit == 0) begin
                    next_state <= 83;
                end else begin
                    next_state <= 86;
                end
            end
            83: begin
                //11111111101100
                if(bit == 0) begin
                    next_state <= 84;
                end else begin
                    next_state <= 85;
                end
            end
            84: begin
                //111111111011000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            85: begin
                //111111111011001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            86: begin
                //11111111101101
                if(bit == 0) begin
                    next_state <= 87;
                end else begin
                    next_state <= 89;
                end
            end
            87: begin
                //111111111011010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            88: begin
                //11111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            89: begin
                //111111111011011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            90: begin
                //1111111110111
                if(bit == 0) begin
                    next_state <= 91;
                end else begin
                    next_state <= 94;
                end
            end
            91: begin
                //11111111101110
                if(bit == 0) begin
                    next_state <= 92;
                end else begin
                    next_state <= 93;
                end
            end
            92: begin
                //111111111011100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            93: begin
                //111111111011101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            94: begin
                //11111111101111
                if(bit == 0) begin
                    next_state <= 95;
                end else begin
                    next_state <= 96;
                end
            end
            95: begin
                //111111111011110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            96: begin
                //111111111011111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            97: begin
                //1111111111
                if(bit == 0) begin
                    next_state <= 98;
                end else begin
                    next_state <= 129;
                end
            end
            98: begin
                //11111111110
                if(bit == 0) begin
                    next_state <= 99;
                end else begin
                    next_state <= 114;
                end
            end
            99: begin
                //111111111100
                if(bit == 0) begin
                    next_state <= 100;
                end else begin
                    next_state <= 107;
                end
            end
            100: begin
                //1111111111000
                if(bit == 0) begin
                    next_state <= 101;
                end else begin
                    next_state <= 104;
                end
            end
            101: begin
                //11111111110000
                if(bit == 0) begin
                    next_state <= 102;
                end else begin
                    next_state <= 103;
                end
            end
            102: begin
                //111111111100000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            103: begin
                //111111111100001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            104: begin
                //11111111110001
                if(bit == 0) begin
                    next_state <= 105;
                end else begin
                    next_state <= 106;
                end
            end
            105: begin
                //111111111100010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            106: begin
                //111111111100011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            107: begin
                //1111111111001
                if(bit == 0) begin
                    next_state <= 108;
                end else begin
                    next_state <= 111;
                end
            end
            108: begin
                //11111111110010
                if(bit == 0) begin
                    next_state <= 109;
                end else begin
                    next_state <= 110;
                end
            end
            109: begin
                //111111111100100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            110: begin
                //111111111100101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            111: begin
                //11111111110011
                if(bit == 0) begin
                    next_state <= 112;
                end else begin
                    next_state <= 113;
                end
            end
            112: begin
                //111111111100110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            113: begin
                //111111111100111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            114: begin
                //111111111101
                if(bit == 0) begin
                    next_state <= 115;
                end else begin
                    next_state <= 122;
                end
            end
            115: begin
                //1111111111010
                if(bit == 0) begin
                    next_state <= 116;
                end else begin
                    next_state <= 119;
                end
            end
            116: begin
                //11111111110100
                if(bit == 0) begin
                    next_state <= 117;
                end else begin
                    next_state <= 118;
                end
            end
            117: begin
                //111111111101000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            118: begin
                //111111111101001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            119: begin
                //11111111110101
                if(bit == 0) begin
                    next_state <= 120;
                end else begin
                    next_state <= 121;
                end
            end
            120: begin
                //111111111101010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            121: begin
                //111111111101011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            122: begin
                //1111111111011
                if(bit == 0) begin
                    next_state <= 123;
                end else begin
                    next_state <= 126;
                end
            end
            123: begin
                //11111111110110
                if(bit == 0) begin
                    next_state <= 124;
                end else begin
                    next_state <= 125;
                end
            end
            124: begin
                //111111111101100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            125: begin
                //111111111101101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            126: begin
                //11111111110111
                if(bit == 0) begin
                    next_state <= 127;
                end else begin
                    next_state <= 128;
                end
            end
            127: begin
                //111111111101110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            128: begin
                //111111111101111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            129: begin
                //11111111111
                if(bit == 0) begin
                    next_state <= 130;
                end else begin
                    next_state <= 146;
                end
            end
            130: begin
                //111111111110
                if(bit == 0) begin
                    next_state <= 131;
                end else begin
                    next_state <= 139;
                end
            end
            131: begin
                //1111111111100
                if(bit == 0) begin
                    next_state <= 132;
                end else begin
                    next_state <= 136;
                end
            end
            132: begin
                //11111111111000
                if(bit == 0) begin
                    next_state <= 133;
                end else begin
                    next_state <= 135;
                end
            end
            133: begin
                //111111111110000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            134: begin
                //1111111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            135: begin
                //111111111110001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            136: begin
                //11111111111001
                if(bit == 0) begin
                    next_state <= 137;
                end else begin
                    next_state <= 138;
                end
            end
            137: begin
                //111111111110010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            138: begin
                //111111111110011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            139: begin
                //1111111111101
                if(bit == 0) begin
                    next_state <= 140;
                end else begin
                    next_state <= 143;
                end
            end
            140: begin
                //11111111111010
                if(bit == 0) begin
                    next_state <= 141;
                end else begin
                    next_state <= 142;
                end
            end
            141: begin
                //111111111110100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            142: begin
                //111111111110101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            143: begin
                //11111111111011
                if(bit == 0) begin
                    next_state <= 144;
                end else begin
                    next_state <= 145;
                end
            end
            144: begin
                //111111111110110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            145: begin
                //111111111110111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            146: begin
                //111111111111
                if(bit == 0) begin
                    next_state <= 147;
                end else begin
                    next_state <= 154;
                end
            end
            147: begin
                //1111111111110
                if(bit == 0) begin
                    next_state <= 148;
                end else begin
                    next_state <= 151;
                end
            end
            148: begin
                //11111111111100
                if(bit == 0) begin
                    next_state <= 149;
                end else begin
                    next_state <= 150;
                end
            end
            149: begin
                //111111111111000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            150: begin
                //111111111111001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            151: begin
                //11111111111101
                if(bit == 0) begin
                    next_state <= 152;
                end else begin
                    next_state <= 153;
                end
            end
            152: begin
                //111111111111010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            153: begin
                //111111111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            154: begin
                //1111111111111
                if(bit == 0) begin
                    next_state <= 155;
                end else begin
                    next_state <= 158;
                end
            end
            155: begin
                //11111111111110
                if(bit == 0) begin
                    next_state <= 156;
                end else begin
                    next_state <= 157;
                end
            end
            156: begin
                //111111111111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            157: begin
                //111111111111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            158: begin
                //11111111111111
                if(bit == 0) begin
                    next_state <= 159;
                end else begin
                    next_state <= 160;
                end
            end
            159: begin
                //111111111111110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            160: begin
                //111111111111111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
        endcase
    end

endmodule//////////////////////////////////////////////////////////////////////////////////
// Module Name: AC Huffman Table
// Description: Maps encoded input sequence into output values (S-R values)
//              for AC by using Huffman algorithm
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module AC_Huffman_Table (
    input bit,                  //Encoded bit sequence
    input [7:0] state,
    output reg [3:0] s_value,   //Run length (Count of zeros before number)
    output reg [3:0] r_value,   //Number length (Bit length of the number after zeros)
    output reg is_valid,        //Indicates output values are valid
    output reg next_state
);

    //Maps input sequence to output values (S-R values)
    always @(*)begin
        s_value <= 4'b0;
        r_value <= 4'b0;
        next_state <= 0;

        case(state)
            0: begin
                //0
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            1: begin
                //1
                if(bit == 0) begin
                    next_state <= 2;
                end else begin
                    next_state <= 4;
                end
            end
            2: begin
                //10
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 3;
                end
            end
            3: begin
                //101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            4: begin
                //11
                if(bit == 0) begin
                    next_state <= 5;
                end else begin
                    next_state <= 7;
                end
            end
            5: begin
                //110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 6;
                end
            end
            6: begin
                //1101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            7: begin
                //111
                if(bit == 0) begin
                    next_state <= 38;
                end else begin
                    next_state <= 8;
                end
            end
            8: begin
                //1111
                if(bit == 0) begin
                    next_state <= 9;
                end else begin
                    next_state <= 11;
                end
            end
            9: begin
                //11110
                if(bit == 0) begin
                    next_state <= 10;
                end else begin
                    next_state <= 62;
                end
            end
            10: begin
                //111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            11: begin
                //11111
                if(bit == 0) begin
                    next_state <= 12;
                end else begin
                    next_state <= 14;
                end
            end
            12: begin
                //111110
                if(bit == 0) begin
                    next_state <= 13;
                end else begin
                    next_state <= 27;
                end
            end
            13: begin
                //1111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            14: begin
                //111111
                if(bit == 0) begin
                    next_state <= 15;
                end else begin
                    next_state <= 18;
                end
            end
            15: begin
                //1111110
                if(bit == 0) begin
                    next_state <= 88;
                end else begin
                    next_state <= 16;
                end
            end
            16: begin
                //11111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 17;
                end
            end
            17: begin
                //111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            18: begin
                //1111111
                if(bit == 0) begin
                    next_state <= 29;
                end else begin
                    next_state <= 19;
                end
            end
            19: begin
                //11111111
                if(bit == 0) begin
                    next_state <= 39;
                end else begin
                    next_state <= 20;
                end
            end
            20: begin
                //111111111
                if(bit == 0) begin
                    next_state <= 21;
                end else begin
                    next_state <= 97;
                end
            end
            21: begin
                //1111111110
                if(bit == 0) begin
                    next_state <= 22;
                end else begin
                    next_state <= 64;
                end
            end
            22: begin
                //11111111100
                if(bit == 0) begin
                    next_state <= 23;
                end else begin
                    next_state <= 47;
                end
            end
            23: begin
                //111111111000
                if(bit == 0) begin
                    next_state <= 24;
                end else begin
                    next_state <= 35;
                end
            end
            24: begin
                //1111111110000
                if(bit == 0) begin
                    next_state <= 25;
                end else begin
                    next_state <= 32;
                end
            end
            25: begin
                //11111111100000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 26;
                end
            end
            26: begin
                //111111111000001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            27: begin
                //1111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 28;
                end
            end
            28: begin
                //11111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            29: begin
                //11111110
                if(bit == 0) begin
                    next_state <= 54;
                end else begin
                    next_state <= 30;
                end
            end
            30: begin
                //111111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 31;
                end
            end
            31: begin
                //1111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            32: begin
                //11111111100001
                if(bit == 0) begin
                    next_state <= 33;
                end else begin
                    next_state <= 34;
                end
            end
            33: begin
                //111111111000010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            34: begin
                //111111111000011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            35: begin
                //1111111110001
                if(bit == 0) begin
                    next_state <= 36;
                end else begin
                    next_state <= 43;
                end
            end
            36: begin
                //11111111100010
                if(bit == 0) begin
                    next_state <= 37;
                end else begin
                    next_state <= 42;
                end
            end
            37: begin
                //111111111000100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            38: begin
                //1110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= 46;
                end
            end
            39: begin
                //111111110
                if(bit == 0) begin
                    next_state <= 134;
                end else begin
                    next_state <= 40;
                end
            end
            40: begin
                //1111111101
                if(bit == 0) begin
                    next_state <= 41;
                end else begin
                    next_state <= 72;
                end
            end
            41: begin
                //11111111010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            42: begin
                //111111111000101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            43: begin
                //11111111100011
                if(bit == 0) begin
                    next_state <= 44;
                end else begin
                    next_state <= 45;
                end
            end
            44: begin
                //111111111000110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            45: begin
                //111111111000111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            46: begin
                //11101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            47: begin
                //111111111001
                if(bit == 0) begin
                    next_state <= 48;
                end else begin
                    next_state <= 56;
                end
            end
            48: begin
                //1111111110010
                if(bit == 0) begin
                    next_state <= 49;
                end else begin
                    next_state <= 52;
                end
            end
            49: begin
                //11111111100100
                if(bit == 0) begin
                    next_state <= 50;
                end else begin
                    next_state <= 51;
                end
            end
            50: begin
                //111111111001000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            51: begin
                //111111111001001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            52: begin
                //11111111100101
                if(bit == 0) begin
                    next_state <= 53;
                end else begin
                    next_state <= 55;
                end
            end
            53: begin
                //111111111001010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            54: begin
                //111111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            55: begin
                //111111111001011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            56: begin
                //1111111110011
                if(bit == 0) begin
                    next_state <= 57;
                end else begin
                    next_state <= 60;
                end
            end
            57: begin
                //11111111100110
                if(bit == 0) begin
                    next_state <= 58;
                end else begin
                    next_state <= 59;
                end
            end
            58: begin
                //111111111001100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            59: begin
                //111111111001101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            60: begin
                //11111111100111
                if(bit == 0) begin
                    next_state <= 61;
                end else begin
                    next_state <= 63;
                end
            end
            61: begin
                //111111111001110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            62: begin
                //111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            63: begin
                //111111111001111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            64: begin
                //11111111101
                if(bit == 0) begin
                    next_state <= 65;
                end else begin
                    next_state <= 81;
                end
            end
            65: begin
                //111111111010
                if(bit == 0) begin
                    next_state <= 66;
                end else begin
                    next_state <= 74;
                end
            end
            66: begin
                //1111111110100
                if(bit == 0) begin
                    next_state <= 67;
                end else begin
                    next_state <= 70;
                end
            end
            67: begin
                //11111111101000
                if(bit == 0) begin
                    next_state <= 68;
                end else begin
                    next_state <= 69;
                end
            end
            68: begin
                //111111111010000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            69: begin
                //111111111010001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            70: begin
                //11111111101001
                if(bit == 0) begin
                    next_state <= 71;
                end else begin
                    next_state <= 73;
                end
            end
            71: begin
                //111111111010010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            72: begin
                //11111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            73: begin
                //111111111010011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            74: begin
                //1111111110101
                if(bit == 0) begin
                    next_state <= 75;
                end else begin
                    next_state <= 78;
                end
            end
            75: begin
                //11111111101010
                if(bit == 0) begin
                    next_state <= 76;
                end else begin
                    next_state <= 77;
                end
            end
            76: begin
                //111111111010100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            77: begin
                //111111111010101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            78: begin
                //11111111101011
                if(bit == 0) begin
                    next_state <= 79;
                end else begin
                    next_state <= 80;
                end
            end
            79: begin
                //111111111010110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            80: begin
                //111111111010111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            81: begin
                //111111111011
                if(bit == 0) begin
                    next_state <= 82;
                end else begin
                    next_state <= 90;
                end
            end
            82: begin
                //1111111110110
                if(bit == 0) begin
                    next_state <= 83;
                end else begin
                    next_state <= 86;
                end
            end
            83: begin
                //11111111101100
                if(bit == 0) begin
                    next_state <= 84;
                end else begin
                    next_state <= 85;
                end
            end
            84: begin
                //111111111011000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            85: begin
                //111111111011001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            86: begin
                //11111111101101
                if(bit == 0) begin
                    next_state <= 87;
                end else begin
                    next_state <= 89;
                end
            end
            87: begin
                //111111111011010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            88: begin
                //11111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            89: begin
                //111111111011011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            90: begin
                //1111111110111
                if(bit == 0) begin
                    next_state <= 91;
                end else begin
                    next_state <= 94;
                end
            end
            91: begin
                //11111111101110
                if(bit == 0) begin
                    next_state <= 92;
                end else begin
                    next_state <= 93;
                end
            end
            92: begin
                //111111111011100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            93: begin
                //111111111011101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            94: begin
                //11111111101111
                if(bit == 0) begin
                    next_state <= 95;
                end else begin
                    next_state <= 96;
                end
            end
            95: begin
                //111111111011110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            96: begin
                //111111111011111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            97: begin
                //1111111111
                if(bit == 0) begin
                    next_state <= 98;
                end else begin
                    next_state <= 129;
                end
            end
            98: begin
                //11111111110
                if(bit == 0) begin
                    next_state <= 99;
                end else begin
                    next_state <= 114;
                end
            end
            99: begin
                //111111111100
                if(bit == 0) begin
                    next_state <= 100;
                end else begin
                    next_state <= 107;
                end
            end
            100: begin
                //1111111111000
                if(bit == 0) begin
                    next_state <= 101;
                end else begin
                    next_state <= 104;
                end
            end
            101: begin
                //11111111110000
                if(bit == 0) begin
                    next_state <= 102;
                end else begin
                    next_state <= 103;
                end
            end
            102: begin
                //111111111100000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            103: begin
                //111111111100001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            104: begin
                //11111111110001
                if(bit == 0) begin
                    next_state <= 105;
                end else begin
                    next_state <= 106;
                end
            end
            105: begin
                //111111111100010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            106: begin
                //111111111100011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            107: begin
                //1111111111001
                if(bit == 0) begin
                    next_state <= 108;
                end else begin
                    next_state <= 111;
                end
            end
            108: begin
                //11111111110010
                if(bit == 0) begin
                    next_state <= 109;
                end else begin
                    next_state <= 110;
                end
            end
            109: begin
                //111111111100100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            110: begin
                //111111111100101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            111: begin
                //11111111110011
                if(bit == 0) begin
                    next_state <= 112;
                end else begin
                    next_state <= 113;
                end
            end
            112: begin
                //111111111100110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            113: begin
                //111111111100111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            114: begin
                //111111111101
                if(bit == 0) begin
                    next_state <= 115;
                end else begin
                    next_state <= 122;
                end
            end
            115: begin
                //1111111111010
                if(bit == 0) begin
                    next_state <= 116;
                end else begin
                    next_state <= 119;
                end
            end
            116: begin
                //11111111110100
                if(bit == 0) begin
                    next_state <= 117;
                end else begin
                    next_state <= 118;
                end
            end
            117: begin
                //111111111101000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            118: begin
                //111111111101001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            119: begin
                //11111111110101
                if(bit == 0) begin
                    next_state <= 120;
                end else begin
                    next_state <= 121;
                end
            end
            120: begin
                //111111111101010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            121: begin
                //111111111101011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            122: begin
                //1111111111011
                if(bit == 0) begin
                    next_state <= 123;
                end else begin
                    next_state <= 126;
                end
            end
            123: begin
                //11111111110110
                if(bit == 0) begin
                    next_state <= 124;
                end else begin
                    next_state <= 125;
                end
            end
            124: begin
                //111111111101100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            125: begin
                //111111111101101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            126: begin
                //11111111110111
                if(bit == 0) begin
                    next_state <= 127;
                end else begin
                    next_state <= 128;
                end
            end
            127: begin
                //111111111101110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            128: begin
                //111111111101111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            129: begin
                //11111111111
                if(bit == 0) begin
                    next_state <= 130;
                end else begin
                    next_state <= 146;
                end
            end
            130: begin
                //111111111110
                if(bit == 0) begin
                    next_state <= 131;
                end else begin
                    next_state <= 139;
                end
            end
            131: begin
                //1111111111100
                if(bit == 0) begin
                    next_state <= 132;
                end else begin
                    next_state <= 136;
                end
            end
            132: begin
                //11111111111000
                if(bit == 0) begin
                    next_state <= 133;
                end else begin
                    next_state <= 135;
                end
            end
            133: begin
                //111111111110000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            134: begin
                //1111111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            135: begin
                //111111111110001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            136: begin
                //11111111111001
                if(bit == 0) begin
                    next_state <= 137;
                end else begin
                    next_state <= 138;
                end
            end
            137: begin
                //111111111110010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            138: begin
                //111111111110011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            139: begin
                //1111111111101
                if(bit == 0) begin
                    next_state <= 140;
                end else begin
                    next_state <= 143;
                end
            end
            140: begin
                //11111111111010
                if(bit == 0) begin
                    next_state <= 141;
                end else begin
                    next_state <= 142;
                end
            end
            141: begin
                //111111111110100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            142: begin
                //111111111110101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            143: begin
                //11111111111011
                if(bit == 0) begin
                    next_state <= 144;
                end else begin
                    next_state <= 145;
                end
            end
            144: begin
                //111111111110110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            145: begin
                //111111111110111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            146: begin
                //111111111111
                if(bit == 0) begin
                    next_state <= 147;
                end else begin
                    next_state <= 154;
                end
            end
            147: begin
                //1111111111110
                if(bit == 0) begin
                    next_state <= 148;
                end else begin
                    next_state <= 151;
                end
            end
            148: begin
                //11111111111100
                if(bit == 0) begin
                    next_state <= 149;
                end else begin
                    next_state <= 150;
                end
            end
            149: begin
                //111111111111000
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            150: begin
                //111111111111001
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            151: begin
                //11111111111101
                if(bit == 0) begin
                    next_state <= 152;
                end else begin
                    next_state <= 153;
                end
            end
            152: begin
                //111111111111010
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            153: begin
                //111111111111011
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            154: begin
                //1111111111111
                if(bit == 0) begin
                    next_state <= 155;
                end else begin
                    next_state <= 158;
                end
            end
            155: begin
                //11111111111110
                if(bit == 0) begin
                    next_state <= 156;
                end else begin
                    next_state <= 157;
                end
            end
            156: begin
                //111111111111100
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            157: begin
                //111111111111101
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            158: begin
                //11111111111111
                if(bit == 0) begin
                    next_state <= 159;
                end else begin
                    next_state <= 160;
                end
            end
            159: begin
                //111111111111110
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
            160: begin
                //111111111111111
                if(bit == 0) begin
                    next_state <= None;
                end else begin
                    next_state <= None;
                end
            end
        endcase
    end

endmodule