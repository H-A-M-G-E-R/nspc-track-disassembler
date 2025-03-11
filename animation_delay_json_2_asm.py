# Converts JSON to ASM for animation delay data. Use "animation_delay_extractor.py" to extract the JSON.
# The ASM can be assembled with asar v1.8.1 on a Super Metroid ROM (https://github.com/RPGHacker/asar/releases/tag/v1.81).

import argparse
import json

parser = argparse.ArgumentParser(description='Converts animation delay data from JSON to ASM')
parser.add_argument('input', help='Path to JSON input')
parser.add_argument('output', help='Path to ASM output')
args = parser.parse_args()

jsonData = json.load(open(args.input, 'r'))
normalDelays = jsonData['normal_delays']
poseCount = len(normalDelays)

allBytes = []
for (i, commands) in normalDelays.items():
    poseBytes = []
    for command in commands.values():
        poseBytes.append(int(command, 16))
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
output.write(f'lorom\n\norg $91B010\nAnimationDelayTable:\ndw ') # vanilla location

output.write(','.join(f'AnimationDelays{i:02X}' for i in range(poseCount)) + '\n\n')

for (poseBytes, poses) in optimizedTable.values():
    for pose in sorted(poses):
        output.write(f'AnimationDelays{pose:02X}:\n')
    output.write('db ' + ','.join(f'${b:02X}' for b in poseBytes) + '\n\n')

runDelays = jsonData['run_delays']
output.write(f'org $91B5D1\nRunAnimationDelaysPointer:\ndw RunAnimationDelays\nRunAnimationDelays:\n') # vanilla location
output.write('db ' + ','.join(f'${int(command, 16):02X}' for command in runDelays.values()) + '\n\n')

speedBoostDelays = jsonData['speed_boost_delays']
output.write(f'org $91B5DE\nSpeedBoostAnimationDelayTable:\ndw ') # vanilla location

output.write(','.join(f'SpeedBoostAnimationDelays{i}' for i in range(len(speedBoostDelays))) + '\n\n')

for i in range(len(speedBoostDelays)):
    commands = []
    for command in speedBoostDelays[str(i)].values():
        commands.append(int(command, 16))
    output.write(f'SpeedBoostAnimationDelays{i}:\n')
    output.write('db ' + ','.join(f'${command:02X}' for command in commands) + '\n\n')
