# Converts Super Metroid NSPC files to SPC files.
# Data format:
#     ssss dddd [xx xx...] (data block 0)
#     ssss dddd [xx xx...] (data block 1)
#     ...
#     0000 aaaa
# Where:
#     s = data block size in bytes
#     d = destination address
#     x = data
#     a = entry address. Ignored by SPC engine after first APU transfer
import argparse

parser = argparse.ArgumentParser(description='Converts Super Metroid NSPC files to SPC files')
parser.add_argument('-t', '--track', default=5, help='Track number. Default: 5')
parser.add_argument('nspc', help='Path to NSPC input')
parser.add_argument('spc', help='Path to SPC output')
args = parser.parse_args()

nspc = open(args.nspc, 'rb')
spc = open(args.spc, 'wb')
smorg = open('smorg.spc', 'rb')

spc.write(smorg.read()) # Copy smorg to spc

while True:
    size = int.from_bytes(nspc.read(2), 'little')
    dest = int.from_bytes(nspc.read(2), 'little')
    if size == 0:
        break

    spc.seek(dest+0x100)
    spc.write(nspc.read(size))

spc.seek(0x1F4)
spc.write(bytes([args.track]))
