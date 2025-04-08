import os.path, sys

def spcRead(n = 1, address = None):
    if address is not None:
        prevAddress = spc.tell()
        spc.seek(address + 0x100)

    ret = int.from_bytes(spc.read(n), 'little')
    if address is not None:
        spc.seek(prevAddress)

    return ret

def aramTell():
    return spc.tell() - 0x100

def aramSeek(address):
    spc.seek(address + 0x100)
spc = open(sys.argv[1], 'rb')

def decodeSamplesAndInstruments(p_instrumentTable):
    fp = os.path.splitext(sys.argv[1])[0]

    asm = open(fp + '_instruments.asm', 'w')
    asm.write('norom : org 0\n\n')

    spc.seek(0x1015D)
    p_sampleTable = spcRead(1)*0x100

    p_samples = []
    samples = {}
    sharedSamples = {}
    for sample_i in range(0x100):
        aramSeek(p_sampleTable+4*sample_i)
        p_start = spcRead(2)
        p_loop = spcRead(2)
        if p_start == 0xFFFF and p_loop == 0xFFFF:
            break

        aramSeek(p_start)
        sample = bytearray()
        while True:
            header = spcRead(1)
            sample.append(header)
            sample.extend(spc.read(8))

            if header & 1: # end of sample
                loop = header & 2
                break

        p_samples.append((p_start, p_loop))
        if p_start in samples:
            sharedSamples[p_start].append(sample_i)
        else:
            samples[p_start] = sample
            sharedSamples[p_start] = [sample_i]

    max_sample = sample_i-1

    asm.write(f'spcblock ${p_sampleTable:04X} nspc ; sample table\n')
    for (p_start, p_loop) in p_samples:
        label = f'Sample{'_'.join(f'{i:02X}' for i in sharedSamples[p_start])}'
        asm.write(f'  dw {label},{label}{'' if p_loop-p_start == 0 else f'+${p_loop-p_start:04X}'}\n')
    asm.write('endspcblock\n')

    asm.write(f'spcblock ${p_samples[0][0]:04X} nspc ; sample data\n')
    for (p_start, sample) in samples.items():
        idxs = '_'.join(f'{i:02X}' for i in sharedSamples[p_start])
        asm.write(f'  Sample{idxs}: incbin "{os.path.split(fp)[-1]}_{idxs}.brr"\n')
        brr = open(f'{fp}_{idxs}.brr', 'wb')
        brr.write(samples[p_start])
    asm.write('endspcblock\n')

    aramSeek(p_instrumentTable)
    asm.write(f'spcblock ${p_instrumentTable:04X} nspc ; instruments\n')
    for instrument_i in range(0x100):
        instrument = [spcRead(1) for _ in range(6)]
        if instrument[0] > max_sample:
            break
        asm.write(f'  db {','.join(f'${b:02X}' for b in instrument)}\n')
    asm.write('endspcblock\n')

if len(sys.argv) > 2:
    decodeSamplesAndInstruments(int(sys.argv[2], 16))
else:
    # find the p_instrumentTable
    for i in range(0x100, 0x10000-6+1):
        aramSeek(i)
        b = [spcRead(1) for _ in range(6)]
        # scan for a 'adc $14,#$ll : adc $15,#$hh' where hhll = p_instrumentTable
        if b[0] == 0x98 and b[2] == 0x14 and b[3] == 0x98 and b[5] == 0x15:
            decodeSamplesAndInstruments(b[1]+b[4]*0x100)
            break
