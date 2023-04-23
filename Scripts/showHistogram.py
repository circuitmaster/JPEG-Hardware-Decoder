with open("HistogramRam.txt", mode='rb') as file:
    print('Color'.ljust(7) + 'Count')
    for index, line in enumerate(file):
        print(f'{index}:'.ljust(7) + f'{int(line, 16)}')
