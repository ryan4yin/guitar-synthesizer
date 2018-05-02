import numpy as np

from python.tone import generate_song
from python.wav_writer import WaveWriter

# 主旋律：八辈子
song = [[3, 1], [5, 1], [3, 1], [3, .5],
        [5, .5], [10, 1], [10, 1], [10, .5],
        [7, .5], [5, .5], [7, .5], [5, 1],
        [3, 1], [3, 1], [3, .5], [5, .5],
        [5, 1], [3, 1], [3, 1], [-2, .5], [-2, .5]]

# 伴奏：八辈子
chords = [3, -2, 3, 5, 7, 5, 10, 7,
          3, -2, 3, 5, 7, 5, 10, 7,
          -2, -2, 3, 5, 7, 5, 10, 7,
          -2, -2, 3, 5, 7, 5, 7, 10]

if __name__ == "__main__":
    # generate wav
    wav = generate_song(song, .5)
    chords = generate_song([[chord, 1] for chord in chords], .25, amplitude=0.5)

    # 和弦循环至歌曲结束
    while len(chords) < len(wav):
        chords = np.append(chords, chords)
    chords = chords[:len(wav)]

    wav = (wav + chords) / 2

    # write wav into a file
    writer = WaveWriter('test.wav')
    writer.set_header(nchannels=1)
    writer.write_wave(wav)
    writer.close()
