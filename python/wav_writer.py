import wave
import numpy as np
from struct import pack
from itertools import zip_longest


class WaveWriter:
    def __init__(self, filename, beat_duration=0.5):
        self.song = wave.open(filename, 'wb')
        self.sampwidth = 1

    def set_header(self, nchannels, sampwidth=2, framrate=44100,
                   nframes=0, comptype='NONE', compname='no compression'):
        """
        set wave's header

        :param nchannels: the number of channels contained in the file
        :param sampwidth: Set the sample width to n bytes.(8*n bits), 2 for default.
        :param framrate:  also been known as fs(frequency of sampling). 44100 for default.
        :param nframes:   the number of frames. just set it to 0, it will be change automatically.
        :param comptype:  the compression type, it can only be 'NONE' At the moment.
        :param compname:  the compression description, because of above, it should been set to ’no compression‘
        :return: None
        """
        self.sampwidth = sampwidth
        self.song.setparams((nchannels, sampwidth, framrate, nframes, comptype, compname))

    def write_wave(self, wav):
        """
        write wave into the wav_file
        :param wav: float list(-1 ~ 1), all for 1 channel, or "L1R1L2R2L3R3..." for 2 channels.
        :return: None
        """
        buffersize = 2048
        max_amplitude = pow(2, self.sampwidth * 8 - 1) - 1  # 振幅是由sampwidth界定，而且是有符号数

        group = zip_longest(*[iter(wav)] * buffersize)  # 以 2048 为一组，做分组。提高写入效率。

        for chunk in group:
            # convert integer list to bytes string
            frames = b''.join(pack('h', int(num * max_amplitude)) for num in chunk if num is not None)
            self.song.writeframes(frames)

    def close(self):
        self.song.close()
