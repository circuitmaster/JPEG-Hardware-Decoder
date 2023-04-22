import numpy as np
from PIL import Image

with open("ImageProcessorImageRam.txt", mode='rb') as file:
    data = np.zeros((240,320))

    lines = file.readlines()
    for line_index, line in enumerate(lines):
        pixels = line.split()
        for pixel_index, pixel in enumerate(pixels):
            pixel_value = int(pixel, 16)
            data[line_index][pixel_index] = pixel_value

    image = Image.fromarray(data)
    image.show()