# Exports Samus spritemaps to PNGs.
# Known issues: The crystal flash palette is wrong, and there's no death animation.
import argparse
import pathlib
from PIL import Image
import numpy as np

snes2hex = lambda address: address >> 1 & 0x3F8000 | address & 0x7FFF
hex2snes = lambda address: address << 1 & 0xFF0000 | address & 0xFFFF | 0x808000
five2eight = lambda value: value << 3

def romRead(n = 1, address = None, byte = False):
    if address is not None:
        prevAddress = rom.tell()
        rom.seek(snes2hex(address))

    if byte:
        ret = rom.read(n)
    else:
        ret = int.from_bytes(rom.read(n), 'little')
    if address is not None:
        rom.seek(prevAddress)
        
    return ret

def romSeek(address):
    return rom.seek(snes2hex(address))

def romTell():
    return hex2snes(rom.tell())

''' Modified From SpriteSomething (https://github.com/Artheau/SpriteSomething) '''
def image_from_raw_data(tilemaps, DMA_writes):
    # expects:
    #  a list of tilemaps in the 5 byte format: essentially [
    #                                                        X position,
    #                                                        size + Xmsb,
    #                                                        Y,
    #                                                        index,
    #                                                        palette + indexmsb
    #                                                       ]
    #  a dictionary consisting of writes to the DMA and what should be there

    canvas = {}

    for tilemap in reversed(tilemaps):
        # tilemap[0] and the 0th bit of tilemap[1] encode the X offset
        x_offset = tilemap[0] - (0x100 if (tilemap[1] & 0x01) else 0)

        # tilemap[1] also contains information about whether the tile is
        #  8x8 or 16x16
        big_tile = (tilemap[1] & 0x80 == 0x80)

        # tilemap[2] contains the Y offset
        y_offset = (tilemap[2] & 0x7F) - (0x80 if (tilemap[2] & 0x80) else 0)

        # tilemap[3] contains the index of which tile to grab
        #  (or tiles in the case of a 16x16)
        # tilemap[4] also contains one bit of the same index,
        #  used to reference deep in OAM
        index = tilemap[3] + (0x100 if tilemap[4] & 0x01 else 0)

        # tilemap[4] contains palette info, priority info, and flip info
        v_flip = tilemap[4] & 0x80
        h_flip = tilemap[4] & 0x40
        # priority = (tilemap[4] //0x10) % 0b100
        # palette = (tilemap[4] //2) % 0b1000

        def draw_tile_to_canvas(new_x_offset, new_y_offset, new_index):
            tile_to_write = convert_tile_from_bitplanes(DMA_writes[new_index*32:new_index*32+32])
            if h_flip:
                tile_to_write = np.flipud(tile_to_write)
            if v_flip:
                tile_to_write = np.fliplr(tile_to_write)
            for (i, j), value in np.ndenumerate(tile_to_write):
                if value != 0:  # if not transparent
                    canvas[(new_x_offset + i, new_y_offset + j)] = int(value)

        if big_tile:  # draw all four 8x8 tiles
            draw_tile_to_canvas(x_offset + (8 if h_flip else 0),
                                y_offset + (8 if v_flip else 0), index)
            draw_tile_to_canvas(x_offset + (0 if h_flip else 8),
                                y_offset + (8 if v_flip else 0), index + 0x01)
            draw_tile_to_canvas(x_offset + (8 if h_flip else 0),
                                y_offset + (0 if v_flip else 8), index + 0x10)
            draw_tile_to_canvas(x_offset + (0 if h_flip else 8),
                                y_offset + (0 if v_flip else 8), index + 0x11)
        else:
            draw_tile_to_canvas(x_offset, y_offset, index)

    return to_image(canvas)


def to_image(canvas):
    # Returns an image centered at the midpoint
    if canvas.keys():
        x_min = min([x for (x, y) in canvas.keys()])
        y_min = min([y for (x, y) in canvas.keys()])
        x_max = max([x for (x, y) in canvas.keys()]) + 1
        y_max = max([y for (x, y) in canvas.keys()]) + 1

        width = max(abs(x_min), abs(x_max)) * 2
        height = max(abs(y_min), abs(y_max)) * 2

        image = Image.new("P", (width, height), 0)

        pixels = image.load()

        for (i, j), value in canvas.items():
            pixels[(i + width//2, j + height//2)] = value

    else:  # the canvas is empty
        image = Image.new("P", (2, 2), 0)

    return image

def convert_tile_from_bitplanes(raw_tile):
    # an attempt to make this ugly process mildly efficient
    tile = np.zeros((8, 8), dtype=np.uint8)

    tile[:, 4] = raw_tile[31:15:-2]
    tile[:, 5] = raw_tile[30:14:-2]
    tile[:, 6] = raw_tile[15::-2]
    tile[:, 7] = raw_tile[14::-2]

    shaped_tile = tile.reshape(8, 8, 1)

    tile_bits = np.unpackbits(shaped_tile, axis=2)
    fixed_bits = np.packbits(tile_bits, axis=1)
    returnvalue = fixed_bits.reshape(8, 8)
    returnvalue = returnvalue.swapaxes(0, 1)
    returnvalue = np.fliplr(returnvalue)
    return returnvalue

poseCount = 0xFD

parser = argparse.ArgumentParser(description='Exports Samus spritemaps to PNG')
parser.add_argument('rom', help='Path to unheadered Super Metroid JU ROM')
parser.add_argument('path', help='Path to save the images')
args = parser.parse_args()

rom = open(args.rom, 'rb')

romSeek(0x9B9402) # Power suit palette
palette555 = [romRead(2) for i in range(15)]

palettergba = [0,0,0,0]
for color555 in palette555:
    palettergba += [five2eight(color555 & 0x1F), five2eight(color555 >> 5 & 0x1F), five2eight(color555 >> 10 & 0x1F), 255]

# Count frames
romSeek(0x92D94E)
tileAnimationDefinitionPointers = [romRead(2) for i in range(poseCount)] + [0xED24]
frameCounts = []
for pose_i in range(poseCount):
    romSeek(0x920004 + tileAnimationDefinitionPointers[pose_i])
    count = 1
    while romTell() & 0xFFFF not in tileAnimationDefinitionPointers:
        count += 1
        romRead(4)
    frameCounts.append(count)

# Export spritemaps
for pose_i in range(poseCount):
    for frame_i in range(frameCounts[pose_i]):
        # Load tiles
        tiles = [0]*32*512
        romSeek(0x920000 + tileAnimationDefinitionPointers[pose_i] + frame_i*4)
        indices = [romRead(1) for i in range(4)]

        # Top tiles
        romSeek(0x92D91E+2*indices[0])
        romSeek(0x920000+romRead(2)+7*indices[1])

        tilesPointer = romRead(3)
        tophalfSize = romRead(2)
        bottomhalfSize = romRead(2)

        romSeek(tilesPointer)
        tiles[0:tophalfSize] = romRead(tophalfSize, byte=True)
        tiles[32*16:32*16+bottomhalfSize] = romRead(bottomhalfSize, byte=True)

        # Bottom tiles
        romSeek(0x92D938+2*indices[2])
        romSeek(0x920000+romRead(2)+7*indices[3])

        tilesPointer = romRead(3)
        tophalfSize = romRead(2)
        bottomhalfSize = romRead(2)

        romSeek(tilesPointer)
        tiles[32*8:32*8+tophalfSize] = romRead(tophalfSize, byte=True)
        tiles[32*24:32*24+bottomhalfSize] = romRead(bottomhalfSize, byte=True)

        # Spritemap
        spritemap = []
        for pointer in [0x929263, 0x92945D]: # top half then bottom half
            romSeek(pointer+2*pose_i)
            romSeek(0x92808D+2*(romRead(2)+frame_i))
            spritemapPointer = romRead(2)
            if spritemapPointer == 0: # null spritemap
                continue
            romSeek(0x920000+spritemapPointer) # location of spritemap

            for i in range(romRead(2)):
                spritemap.append([romRead(1) for j in range(5)])

            if pose_i == 0 and frame_i >= 2 and pointer == 0x929263:
                # draw stupid tile between top and bottom
                romSeek(0x9AD200+32*0x20)
                tiles[32*0x20:32*0x22] = romRead(32*2, byte=True)
                spritemap.append([0xF9,0x81,0xF0,0x21,0x38])

        if spritemap != []: # if spritemap isn't empty
            image = image_from_raw_data(spritemap, tiles)
            image.putpalette(palettergba, 'RGBA')
            image.save(str(pathlib.PurePath(args.path, f'0x{pose_i:02X}_{frame_i}.png')))
