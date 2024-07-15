# Put the path to the SPC file using the standard N-SPC engine (e.g. Super Metroid, EarthBound and Star Fox, but not Super Mario World or Super Castlevania IV) as the first argument.
# If it results in nothing, or disassembles the wrong song, put the track pointer as the second argument, given by VGMTrans or by using Mesen2's debugger on the SPC.
# Based on https://patrickjohnston.org/ASM/ROM data/Super Metroid/music disassembler.py.
import sys

formatValue = lambda v: f'{v:X}' + ('h' if v >= 0xA else '')

def romRead(n = 1, address = None):
    if address is not None:
        prevAddress = rom.tell()
        rom.seek(address + 0x100)

    ret = int.from_bytes(rom.read(n), 'little')
    if address is not None:
        rom.seek(prevAddress)

    return ret

def tellAram():
    return rom.tell() - 0x100

def aramSeek(address):
    rom.seek(address + 0x100)
rom = open(sys.argv[1], 'rb')

usedInstruments = set()
i_instruments = 0

def decodeTracker(p_tracker):
    
    def decodeTrack(p_track, p_nextTrack, label):
        global usedInstruments
        global i_instruments
    
        if tellAram() != p_track:
            print(f'; Missing track data at ${tellAram():04X}..${p_track:04X}', file = sys.stderr)
            aramSeek(p_track)
            
        trackCommands = []
        subsectionPointers = set()
        while tellAram() < p_nextTrack:
            p_command = tellAram()
            commandId = romRead()
            parameters = []
            parameterSizes = None
            comment = None
            
            if 1 <= commandId < 0x80:
                comment = f'Note length = {formatValue(commandId)} tics'
                if romRead(1, tellAram()) < 0x80:
                    v = romRead()
                    parameters = [v]
                    volume = [0x19, 0x32, 0x4C, 0x65, 0x72, 0x7F, 0x8C, 0x98, 0xA5, 0xB2, 0xBF, 0xCB, 0xD8, 0xE5, 0xF2, 0xFC][v & 0xF]
                    ringLength = [0x32, 0x65, 0x7F, 0x98, 0xB2, 0xCB, 0xE5, 0xFC][v >> 4 & 7]
                    comment += f', note volume multiplier = {formatValue(volume)} / 100h, note ring length multiplier = {formatValue(ringLength)} / 100h'
            elif 0x80 <= commandId < 0xC8:
                octave = (commandId - 0x80) // 12 + 1
                note = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'][(commandId - 0x80) % 12]
                comment = f'Note {note}_{octave}'
            elif commandId == 0xC8:
                comment = 'Tie'
            elif commandId == 0xC9:
                comment = 'Rest'
            elif 0xCA <= commandId < 0xE0:
                comment = f'Percussion note {formatValue(commandId - 0xCA)}'
                usedInstruments |= {commandId}
            else:
                if commandId == 0xE0:
                    v = romRead()
                    parameters = [v]
                    if v >= 0xCA:
                        comment = f'Select percussion instrument {formatValue(v - 0xCA)}'
                    else:
                        comment = f'Select instrument {formatValue(v)}'
                    usedInstruments |= {v}
                elif commandId == 0xE1:
                    v = romRead()
                    parameters = [v]
                    inversion = ['no', 'right side', 'left side', 'both side'][v >> 6]
                    comment = f'Panning bias = {formatValue(v & 0x1F)} / 14h with {inversion} phase inversion'
                elif commandId == 0xE2:
                    timer = romRead()
                    bias = romRead()
                    parameters = [timer, bias]
                    comment = f'Dynamic panning over {formatValue(timer)} tics with target panning bias {formatValue(bias)} / 14h'
                elif commandId == 0xE3:
                    delay = romRead()
                    rate = romRead()
                    extent = romRead()
                    parameters = [delay, rate, extent]
                    comment = f'Static vibrato after {formatValue(delay)} tics at rate {formatValue(rate)} with extent {formatValue(extent)}'
                elif commandId == 0xE4:
                    comment = 'End vibrato'
                elif commandId == 0xE5:
                    volume = romRead()
                    parameters = [volume]
                    comment = f'Music volume multiplier = {formatValue(volume)} / 100h'
                elif commandId == 0xE6:
                    timer = romRead()
                    volume = romRead()
                    parameters = [timer, volume]
                    comment = f'Dynamic music volume over {formatValue(timer)} tics with target volume multiplier {formatValue(volume)} / 100h'
                elif commandId == 0xE7:
                    tempo = romRead()
                    parameters = [tempo]
                    ticRate = tempo / (0x100 * 0.002)
                    comment = f'Music tempo = {ticRate} tics per second'
                elif commandId == 0xE8:
                    timer = romRead()
                    tempo = romRead()
                    parameters = [timer, tempo]
                    ticRate = tempo / (0x100 * 0.002)
                    comment = f'Dynamic music tempo over {formatValue(timer)} tics with target tempo {ticRate} tics per second'
                elif commandId == 0xE9:
                    transpose = romRead()
                    parameters = [transpose]
                    comment = f'Set music transpose of {formatValue(transpose)} semitones'
                elif commandId == 0xEA:
                    transpose = romRead()
                    parameters = [transpose]
                    comment = f'Set transpose of {formatValue(transpose)} semitones'
                elif commandId == 0xEB:
                    delay = romRead()
                    rate = romRead()
                    extent = romRead()
                    parameters = [delay, rate, extent]
                    comment = f'Tremolo after {formatValue(delay)} tics at rate {formatValue(rate)} with extent {formatValue(extent)}'
                elif commandId == 0xEC:
                    comment = 'End tremolo'
                elif commandId == 0xED:
                    volume = romRead()
                    parameters = [volume]
                    comment = f'Volume multiplier = {formatValue(volume)} / 100h'
                elif commandId == 0xEE:
                    timer = romRead()
                    volume = romRead()
                    parameters = [timer, volume]
                    comment = f'Dynamic volume over {formatValue(timer)} tics with target volume multiplier {formatValue(volume)} / 100h'
                elif commandId == 0xEF:
                    p_subsection = romRead(2)
                    counter = romRead()
                    parameters = [p_subsection, counter]
                    parameterSizes = [2, 1]
                    subsectionPointers |= {p_subsection}
                    comment = f'Play subsection ${p_subsection:04X} {formatValue(counter)} times'
                elif commandId == 0xF0:
                    length = romRead()
                    parameters = [length]
                    comment = f'Dynamic vibrato over {formatValue(length)} tics with target extent 0'
                elif commandId == 0xF1:
                    delay = romRead()
                    length = romRead()
                    extent = romRead()
                    parameters = [delay, length, extent]
                    comment = f'Slide out after {formatValue(delay)} tics for {formatValue(length)} tics by {formatValue(extent)} semitones'
                elif commandId == 0xF2:
                    delay = romRead()
                    length = romRead()
                    extent = romRead()
                    parameters = [delay, length, extent]
                    comment = f'Slide in after {formatValue(delay)} tics for {formatValue(length)} tics by {formatValue(extent)} semitones'
                elif commandId == 0xF3:
                    comment = 'End slide'
                elif commandId == 0xF4:
                    subtranspose = romRead()
                    parameters = [subtranspose]
                    comment = f'Set subtranspose of {formatValue(subtranspose)} / 100h semitones'
                elif commandId == 0xF5:
                    enable = romRead()
                    left = romRead()
                    right = romRead()
                    parameters = [enable, left, right]
                    voices = '/'.join(f'{i}' for i in range(8) if enable & 1 << i) or '(none)'
                    comment = f'Static echo on voices {voices} with echo volume left = {formatValue(left)} and echo volume right = {formatValue(right)}'
                elif commandId == 0xF6:
                    comment = 'End echo'
                elif commandId == 0xF7:
                    delay = romRead()
                    feedback = romRead()
                    i_fir = romRead()
                    parameters = [delay, feedback, i_fir]
                    comment = f'Set echo parameters: echo delay = {formatValue(delay)}, echo feedback volume = {formatValue(feedback)}, echo FIR filter index = {formatValue(i_fir)}'
                elif commandId == 0xF8:
                    timer = romRead()
                    left = romRead()
                    right = romRead()
                    parameters = [timer, left, right]
                    comment = f'Dynamic echo volume after {formatValue(timer)} tics with target echo volume left = {formatValue(left)} and target echo volume right = {formatValue(right)}'
                elif commandId == 0xF9:
                    delay = romRead()
                    length = romRead()
                    target = romRead()
                    parameters = [delay, length, target]
                    comment = f'Pitch slide after {formatValue(delay)} tics over {formatValue(length)} tics by {formatValue(target)} semitones'
                elif commandId == 0xFA:
                    i_instruments = romRead()
                    parameters = [i_instruments]
                    comment = f'Percussion instruments base index = {formatValue(i_instruments)}'
                elif commandId == 0xFB:
                    #parameters = [romRead()]
                    comment = 'Skip byte'
                elif commandId == 0xFC:
                    comment = 'Skip all new notes'
                elif commandId == 0xFD:
                    comment = 'Stop sound effects and disable music note processing'
                elif commandId == 0xFE:
                    comment = 'Resume sound effects and enable music note processing'
                elif commandId == 0xFF:
                    comment = 'Crash'
            
            if not parameterSizes:
                parameterSizes = [1] * len(parameters)
                
            trackCommands += [(p_command, commandId, parameters, parameterSizes, comment)]
            if commandId == 0 or commandId == 0xFF:
                break
        
        print()
        print(label)
        print('{', end = '')
        i = 0
        for (p_command, commandId, parameters, parameterSizes, comment) in trackCommands:
            print()
            if p_command == p_track:
                print(f'Track{p_command:04X}:           db ', end = '')
            else:
                print('                        ', end = '')
                
            print(f'${commandId:02X}', end = '')
            if commandId == 0xEF:
                print(f' : dw Track{parameters[0]:04X} : db ${parameters[1]:02X}', end = '')
            elif commandId == 0xE0:
                print(f',!Instrument{parameters[0]:02X}', end = '')
            else:
                for (parameter, parameterSize) in zip(parameters, parameterSizes):
                    print(',${{:0{}X}}'.format(parameterSize * 2).format(parameter), end = '')
                
            if comment:
                if i != len(trackCommands)-1:
                    print(',', end = '')
                print(' ' * (9 - sum(parameterSizes) * 2 - len(parameterSizes)), end = '')
                print(f' ; {comment}', end = '')
            i += 1
    
        print()
        print('}')
        
        return subsectionPointers
    
    trackerCommands = []
    trackerDestinations = [p_tracker]
    trackSetPointers = []
    aramSeek(p_tracker)
    lowestPattern = 0x10000
    while True:
        p_command = tellAram()
        commandId = romRead(2)
        parameters = []
        if commandId >= 0x100:
            trackSetPointers += [commandId]
            lowestPattern = min(lowestPattern, commandId)
        elif commandId >= 0x01:
            parameters = [romRead(2)]
            trackerDestinations += parameters 
        trackerCommands += [(p_command, commandId, parameters)]
        if commandId == 0 or tellAram() == lowestPattern:
            break
    
    print()
    print(f'; Tracker commands', end = '')
    for (p_command, commandId, parameters) in trackerCommands:
        if p_command in trackerDestinations:
            print()
            print(f'Destination{p_command:04X}:     dw ', end = '')
        else:
            print(',')
            print('                        ', end = '')

        if commandId >= 0x100:
            print(f'Pattern{commandId:04X}', end = '')
        else:
            print(f'${commandId:04X}', end = '')
            for parameter in parameters:
                print(f',Destination{parameter:04X}', end = '')
    
    print()
    if tellAram() != lowestPattern:
        print(f'; Missing commands at ${tellAram():04X}..${lowestPattern:04X}', file = sys.stderr)
        aramSeek(lowestPattern)
    print()
    print(f'; Track pointers')
    trackPointers = []
        
    while True:
        p_trackSet = tellAram()
        rowTrackPointers = [(p_trackSet, i_track, romRead(2)) for i_track in range(8)]
        trackPointers += [(p_trackSet, i_track, p_track) for (p_trackSet, i_track, p_track) in rowTrackPointers if p_track != 0]
        
        print(f'Pattern{p_trackSet:04X}:         dw ', end = '')
        print(', '.join(f'Track{p_track:04X}' if p_track >= 0x100 else f'${p_track:04X}' for (_, _, p_track) in rowTrackPointers), end = '\n' if p_trackSet in trackSetPointers else ' ; Unused\n')
        
        if tellAram() >= max(trackSetPointers) + 16:
            break
        
    trackPointers.sort(key = lambda trackPointer: trackPointer[2])
    subsectionPointers = set()
    for ((p_trackSet, i_track, p_track), (_, _, p_nextTrack)) in zip(trackPointers, trackPointers[1:] + [(None, None, 0x10000)]):
        label = f'; Track set ${p_trackSet:04X}, track {i_track} commands'
        if p_nextTrack == 0x10000 and len(subsectionPointers) > 0:
            p_nextTrack = min(subsectionPointers)
        subsectionPointers |= decodeTrack(p_track, p_nextTrack, label)
        '''if tellAram() != p_nextTrack and tellAram() not in subsectionPointers and (subsectionPointers or p_nextTrack != 0x10000):
            print(f'; Printing unused track at ${tellAram():04X}', file = sys.stderr)
            decodeTrack(tellAram(), p_nextTrack, '; Unused track commands')
            if tellAram() > p_nextTrack:
                print(f'; Printed too much tracker data (tell = ${tellAram():04X})', file = sys.stderr)'''
    
    while subsectionPointers:
        newSubsectionPointers = set()
        for p_subsection in sorted(subsectionPointers):
            newSubsectionPointers |= decodeTrack(p_subsection, 0x10000, '; Repeated subsection')
        
        subsectionPointers = newSubsectionPointers

if len(sys.argv) > 2:
    decodeTracker(int(sys.argv[2], base=16))
else:
    for p_table in range(0xFFFC):
        if romRead(5, tellAram()) == 0x0C028F40DA: # Scans for a 'movw $40,ya : mov $0C,#$02'. Works for most games with some exceptions like Kirby Super Star.
            p_table -= 2
            if p_table == 0x0AF6 and romRead(2, address=p_table) == 0x1FD6: # F-Zero's case
                songIndex = romRead(1, address=0x04)
            else:
                songIndex = romRead(1, address=0xF4)
                if songIndex == 0:
                    songIndex = romRead(1, address=0x00)
                if songIndex == 0:
                    songIndex = romRead(1, address=0x04)
            if songIndex != 0:
                decodeTracker(romRead(2, address=romRead(2, address=p_table)+2*songIndex))
            break
        if romRead(5) == 0x0D028F40DA: # Super Mario All-Stars instead has 'movw $40,ya : mov $0D,#$02'.
            p_table -= 2
            songIndex = romRead(1, address=0xF6)
            if songIndex == 0:
                songIndex = romRead(1, address=0x02)
            if songIndex == 0:
                songIndex = romRead(1, address=0x06)
            if songIndex != 0:
                decodeTracker(romRead(2, address=romRead(2, address=p_table)+2*songIndex))
            break
        aramSeek(p_table+1)
print('; Used instruments: ' + ', '.join(f'{formatValue(instrumentID)} ({formatValue(instrumentID - 0xCA + i_instruments)})' if instrumentID >= 0xCA else f'{formatValue(instrumentID)}' for instrumentID in sorted(usedInstruments)), file = sys.stderr)
