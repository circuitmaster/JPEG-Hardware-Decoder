import math

HEADER = 0xBACD
EDGE_DETECTION = 0xA010
EDGE_ENHANCEMENT = 0xA020
NOISE_FILTERING = 0xA030
HISTOGRAM_STATISTICS = 0xA040
HISTOGRAM_EQUALIZATION = 0xA050
BOUNDARY_EXTRACTION = 0xA060


def get_bit_str(number):
    number_str = "{0:b}".format(number)
    number_str_len = number_str.__len__()
    padding = number_str_len+8-number_str_len%8 if number_str_len%8 != 0 else 0
    number_str = f"{{0:0{padding}b}}".format(number)
    line_break_index = 0
    bit_str = ''
    while line_break_index + 7 < number_str.__len__():
        bit_str += number_str[line_break_index:line_break_index+8] + '\n'
        line_break_index += 8
    return bit_str


with open("EncodedImage.bin", mode='rb') as input_file:
    with open("EncodedImage.txt", "w") as output_file:
        file_content = input_file.read()

        for byte in file_content:
            output_file.write(get_bit_str(byte))


print("done")