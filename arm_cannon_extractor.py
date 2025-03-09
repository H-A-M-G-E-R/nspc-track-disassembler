# Extracts arm cannon drawing data to JSON.
# Format (from https://patrickjohnston.org/bank/90#C7DF):
#     dd aa
#     [DD aa] # If d & 80h != 0
#     [xx yy]...
#
# where
#     d: Direction
#     D: Direction if [Samus animation frame] != 0
#     {
#         0: Up, facing right
#         1: Up-right
#         2: Right
#         3: Down-right
#         4: Down, facing right
#         5: Down, facing left
#         6: Down-left
#         7: Left
#         8: Up-left
#         9: Up, facing left
#     }
#     a: Arm cannon drawing mode
#     {
#         0: Arm cannon isn't drawn
#         1: Arm cannon is drawn over Samus
#         2: Arm cannon is drawn under Samus
#     }
#     x/y: X/Y offsets, indexed by [Samus animation frame]

import argparse
import json

snes2hex = lambda address: address >> 1 & 0x3F8000 | address & 0x7FFF
hex2snes = lambda address: address << 1 & 0xFF0000 | address & 0xFFFF | 0x808000
byte2signed = lambda byte: byte if byte <= 0x7F else byte - 0x100

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

parser = argparse.ArgumentParser(description='Exports arm cannon data to JSON')
parser.add_argument('-s', '--start', default=0x90C7DF, help='Location of start of arm cannon data table in ROM')
parser.add_argument('-e', '--end', default=0x90CC21, help='Location of end of arm cannon data table in ROM')
parser.add_argument('rom', help='Path to unheadered Super Metroid JU ROM')
parser.add_argument('out', help='Path to JSON output')
args = parser.parse_args()

directions = {
    0: 'up_facing_right',
    1: 'up_right',
    2: 'right',
    3: 'down_right',
    4: 'down_facing_right',
    5: 'down_facing_left',
    6: 'down_left',
    7: 'left',
    8: 'up_left',
    9: 'up_facing_left'
}

modes = {
    0: 'none',
    1: 'over_samus',
    2: 'under_samus'
}

rom = open(args.rom, 'rb')

poseCount = 0xFD

romSeek(args.start)
pointerTable = [romRead(2) for i in range(poseCount)] + [args.end & 0xFFFF]

tojson = {}

for pose_i in range(poseCount):
    romSeek(args.start & 0xFF0000 | pointerTable[pose_i])

    direction = romRead(1)
    mode = romRead(1)
    poseData = {'direction': directions[direction & 0x7F], 'mode': modes[mode]}

    if direction & 0x80:
        direction = romRead(1)
        mode = romRead(1)
        poseData['direction2'] = directions[direction & 0x7F]
        poseData['mode2'] = modes[mode]

    offsets = {}
    i = 0
    while romTell() & 0xFFFF not in pointerTable:
        offsets[i] = {'x': byte2signed(romRead(1)), 'y': byte2signed(romRead(1))}
        i += 1

    if offsets != {}:
        poseData['offsets'] = offsets

    tojson[f'0x{pose_i:02X}'] = poseData

json.dump(tojson, open(args.out, 'w'), indent=4)