# Extracts animation delay data to JSON.
# Format (from https://patrickjohnston.org/bank/91#fB010)
# Positive values are animation delay durations, negative values are instructions (first nybble ignored):
#     F6:                  Go to beginning if [Samus health] >= 30
#     F7:                  Set drained Samus movement handler
#     F8 pp:               Enable auto-jump hack and transition to pose p if not jumping
#     F9 eeee gg aa GG AA: Transition to pose G/A if item e equipped, otherwise g/a, and to pose g/G if Y speed = 0, otherwise a/A
#     FA gg aa:            Transition to pose g if Y speed = 0, otherwise a
#     FB:                  Select animation delay sequence for wall-jump
#     FC eeee pp PP:       Transition to pose P if item e equipped, otherwise p
#     FD pp:               Transition to pose p
#     FE nn:               Go back n bytes
#     FF:                  Go to beginning

import argparse
import json

snes2hex = lambda address: address >> 1 & 0x3F8000 | address & 0x7FFF
hex2snes = lambda address: address << 1 & 0xFF0000 | address & 0xFFFF | 0x808000

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

parser = argparse.ArgumentParser(description='Exports animation delay data to JSON')
parser.add_argument('-s', '--start', default=0x91B010, help='Location of start of normal animation delay table in ROM')
parser.add_argument('-e', '--end', default=0x91B5D1, help='Location of end of normal animation delay table in ROM')
parser.add_argument('--runstart', default=0x91B5D1, help='Location of start of run animation delay table in ROM')
parser.add_argument('--runend', default=0x91B5DE, help='Location of end of run animation delay table in ROM')
parser.add_argument('--speedbooststart', default=0x91B5DE, help='Location of start of speed boost animation delay table in ROM')
parser.add_argument('--speedboostend', default=0x91B61F, help='Location of end of speed boost animation delay table in ROM')
parser.add_argument('rom', help='Path to unheadered Super Metroid JU ROM')
parser.add_argument('out', help='Path to JSON output')
args = parser.parse_args()

poseCount = 0xFD
speedBoostDelayCount = 5

rom = open(args.rom, 'rb')

romSeek(args.start)
pointerTable = [romRead(2) for i in range(poseCount)] + [args.end & 0xFFFF]

tojson = {}
normalDelays = {}

for pose_i in range(poseCount):
    romSeek(args.start & 0xFF0000 | pointerTable[pose_i])

    delays = {0: f'0x{romRead(1):02X}'}
    i = 1
    while romTell() & 0xFFFF not in pointerTable:
        delays[i] = f'0x{romRead(1):02X}'
        i += 1
    
    normalDelays[f'0x{pose_i:02X}'] = delays

tojson['normal_delays'] = normalDelays

runDelays = {}
romSeek(args.runstart)
romSeek(args.runstart & 0xFF0000 | romRead(2))

i = 0
while romTell() < args.runstart & 0xFF0000 | (args.runend & 0xFFFF):
    runDelays[i] = f'0x{romRead(1):02X}'
    i += 1

tojson['run_delays'] = runDelays

speedBoostDelays = {}
romSeek(args.speedbooststart)
speedBoostDelayPointers = [romRead(2) for i in range(speedBoostDelayCount)] + [args.speedboostend & 0xFFFF]

for delay_i in range(speedBoostDelayCount):
    romSeek(args.speedbooststart & 0xFF0000 | speedBoostDelayPointers[delay_i])

    delays = {0: f'0x{romRead(1):02X}'}
    i = 1
    while romTell() & 0xFFFF not in speedBoostDelayPointers:
        delays[i] = f'0x{romRead(1):02X}'
        i += 1
    
    speedBoostDelays[delay_i] = delays

tojson['speed_boost_delays'] = speedBoostDelays

json.dump(tojson, open(args.out, 'w'), indent=4)
