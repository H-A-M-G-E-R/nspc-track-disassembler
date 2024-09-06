# Exports enemy spritemaps to PNG, centered at the middle, straight from the ROM!
# Doesn't support extended spritemaps (e.g. pirates and most bosses)
# Uses code from SpriteSomething to turn the spritemap into an image (https://github.com/Artheau/SpriteSomething)
# Example:
#   Exports all of the atomic's spritemaps
#   rom.sfc atomic -e 0xE9FF -s 0xA8E489 -b

import argparse
from PIL import Image
import numpy as np

snes2hex = lambda address: address >> 1 & 0x3F8000 | address & 0x7FFF
hex2snes = lambda address: address << 1 & 0xFF0000 | address & 0xFFFF | 0x808000
five2eight = lambda value: (value << 3) + (value >> 2) # Mesen2's method

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

''' Modified From SpriteSomething (https://github.com/Artheau/SpriteSomething) '''
def image_from_raw_data(tilemaps, DMA_writes, tile_offset = 0):
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
        index = tilemap[3] + (0x100 if tilemap[4] & 0x01 else 0) - tile_offset

        # tilemap[4] contains palette info, priority info, and flip info
        v_flip = tilemap[4] & 0x80
        h_flip = tilemap[4] & 0x40
        # priority = (tilemap[4] //0x10) % 0b100
        # palette = (tilemap[4] //2) % 0b1000

        def draw_tile_to_canvas(new_x_offset, new_y_offset, new_index):
            tile_to_write = convert_tile_from_bitplanes(DMA_writes[new_index])
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

parser = argparse.ArgumentParser(description='Exports enemy spritemaps to PNG')
parser.add_argument('-e', '--enemy', default='0xCEBF', help='Enemy ID')
parser.add_argument('-s', '--spritemap', default='0x88DA', help='Spritemap pointer in enemy bank (to find them look at PJ\'s banklogs (https://patrickjohnston.org/bank/index.html))')
parser.add_argument('-b', '--bulk', action = 'store_true', help='Export all spritemaps back-to-back starting from the specified spritemap pointer')
parser.add_argument('rom', help='Path to unheadered Super Metroid JU ROM')
parser.add_argument('out_image', help='Name of image(s) to save')
args = parser.parse_args()

rom = open(args.rom, 'rb')
enemy_id = int(args.enemy, 16)

enemy_bank = romRead(1, 0xA0000C+enemy_id)
palette_address = (enemy_bank<<16)+romRead(2, 0xA00002+enemy_id)

romSeek(palette_address+2)
palette555 = [romRead(2) for i in range(15)]

palettergba = [0,0,0,0]
for color555 in palette555:
    palettergba += [five2eight(color555 & 0x1F), five2eight(color555 >> 5 & 0x1F), five2eight(color555 >> 10 & 0x1F), 255]

tiles = []
tiles_address = romRead(3, 0xA00036+enemy_id)
tile_count = (romRead(2, 0xA00000+enemy_id) & 0x7FFF)//0x20

romSeek(tiles_address)
for i in range(tile_count):
    tiles.append([romRead() for j in range(0x20)])

spritemap_pointer = (enemy_bank<<16)|int(args.spritemap, 16)
romSeek(spritemap_pointer)
image_index = 0
while True:
    spritemap = []
    sprite_count = romRead(2)
    if sprite_count > 128:
        break
    for i in range(sprite_count):
        spritemap.append(romRead(5, byte = True))

    image = image_from_raw_data(spritemap, tiles, 0x100)
    image.putpalette(palettergba, 'RGBA')
    if args.bulk:
        image.save(args.out_image + str(image_index) + '.png')
        image_index += 1
    else:
        image.save(args.out_image + '.png')
        break

