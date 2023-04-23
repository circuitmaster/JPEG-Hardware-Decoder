with open("HistogramRam.txt", mode='rb') as file:
    for line in file:
        print(int(line, 16), end=' ')
