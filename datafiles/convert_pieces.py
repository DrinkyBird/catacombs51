# This is a dumb hack necessary due to GM's lack of binary file I/O on HTML5

import os
from PIL import Image

DATAFILES_DIR = os.path.dirname(os.path.realpath(__file__))
INPUT_DIR = os.path.join(DATAFILES_DIR, "pieces")
OUTPUT_DIR = os.path.join(DATAFILES_DIR, "pieces_text")

if __name__ == "__main__":
    for f in os.listdir(INPUT_DIR):
        in_path = os.path.join(INPUT_DIR, f)
        out_path = os.path.join(OUTPUT_DIR, f.replace(".bmp", ".txt"))
        
        print(f" * {in_path}")
        print(f"-> {out_path}")
        
        im = Image.open(in_path)
        arr = im.load()
        
        with open(out_path, "w") as h:
            h.write(f"{im.width} {im.height} ")
            
            val = -1
            count = 0
            total = 0
            
            for x in range(im.width):
                for y in range(im.height):
                    col = (arr[x, y][2]) | (arr[x, y][1] << 8) | (arr[x, y][0] << 16)
                    
                    h.write(f"{col} ")