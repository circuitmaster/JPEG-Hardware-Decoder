with open("hexValues.txt", mode='r') as file:
    i = 0
    while idct_value := file.read(2):
        idct_value = int(idct_value, 16)
        idct_value = idct_value if idct_value < 128 else idct_value-256
        print(str(idct_value), end='\t')
        if i == 7:
            i = 0
            print()
        else:
            i += 1

print('done')