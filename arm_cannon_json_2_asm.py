# Converts JSON to ASM for arm cannon data. Use "arm_cannon_extractor.py" to extract the JSON.
# The ASM can be assembled with asar v1.8.1 on a Super Metroid ROM (https://github.com/RPGHacker/asar/releases/tag/v1.81).

import argparse
import json

signed2byte = lambda n: n if n >= 0 else 0x100 + n

parser = argparse.ArgumentParser(description='Converts arm cannon data from JSON to ASM')
parser.add_argument('-a', '--addr', default=0x90C7DF, help='Location in ROM to put the table in')
parser.add_argument('-w', '--warnaddr', default=0x90CC21, help='Warn if pc is over this address')
parser.add_argument('input', help='Path to JSON input')
parser.add_argument('output', help='Path to ASM output')
args = parser.parse_args()

directions = {
    'up_facing_right': 0,
    'up_right': 1,
    'right': 2,
    'down_right': 3,
    'down_facing_right': 4,
    'down_facing_left': 5,
    'down_left': 6,
    'left': 7,
    'up_left': 8,
    'up_facing_left': 9
}

modes = {
    'none': 0,
    'over_samus': 1,
    'under_samus': 2
}

jsonData = json.load(open(args.input, 'r'))
poseCount = len(jsonData)

allBytes = []
for (i, poseData) in jsonData.items():
    poseBytes = [directions[poseData['direction']], modes[poseData['mode']]]
    if 'direction2' in poseData and 'mode2' in poseData:
        poseBytes[0] |= 0x80
        poseBytes += [directions[poseData['direction2']], modes[poseData['mode2']]]
    if 'offsets' in poseData:
        offsets = poseData['offsets']
        for offset in offsets.values():
            poseBytes += [signed2byte(offset['x']), signed2byte(offset['y'])]
    allBytes.append((poseBytes, int(i, 16)))

allBytes.sort()

superset = allBytes[-1][0]
optimizedTable = {0: (superset, [allBytes[-1][1]])}
i = 0

for j in range(poseCount-2, -1, -1):
    if allBytes[j][0] != superset[:len(allBytes[j][0])]:
        superset = allBytes[j][0]
        i += 1
        optimizedTable[i] = (superset, [allBytes[j][1]])
    else:
        optimizedTable[i][1].append(allBytes[j][1])

output = open(args.output, 'w')
output.write(f'lorom\n\norg ${args.addr:06X}\nArmCannonData:\ndw ')

output.write(','.join(f'ArmCannon{i:02X}' for i in range(poseCount)) + '\n\n')

for (poseBytes, poses) in optimizedTable.values():
    for pose in sorted(poses):
        output.write(f'ArmCannon{pose:02X}:\n')
    output.write('db ' + ','.join(f'${b:02X}' for b in poseBytes) + '\n\n')

output.write(f'warnpc ${args.warnaddr:06X}\n')