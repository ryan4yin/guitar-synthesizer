function makewave(f::Int64, t::Float32; amplitude::Float32=1, fs::Int64=44100)
    # f : 频率，单位 HZ
    # t : 时长，单位秒
    # amplitude: 振幅，默认为 1
    # Fs: 采样频率，默认为 44100

    N = ceil(Int64, Fs*t) # 总的采样点个数
    L = floor(Int64, Fs/f) # 一个周期所含的采样数(整)
    part = rand(L, 1) - 0.5 # 循环段
    np = floor(Int64, N/L) # 总的循环次数

    r = 0.5; # 平均权值

    wave=zeros(N, 1)
    for i in 1:np
        part = part .* r + [part[end]; part[1:end-1]] .* (1 - r)   # 吉他音质算法
        pos = L * (i -1) + 1
        wave[pos:pos+L-1] = part
    end

    wave = wave .* range(1, stop=0, length=length(wave))  # 归一化

    wave * amplitude
end




# 需要用到第三方模块：WAV
using WAV

Fs = 44100
a1 = 440;  #标准音
r = 2^(1/12); #12平均律的比值
t = .5; #1拍的时长，半秒

#主旋律 〈八辈子〉
song = [3 1; 5 1; 3 1; 3 .5; 5 .5; 10 1; 10 1; 10 .5; 7 .5; 5 .5; 7 .5; 5 1; 3 1; 3 1
   3 .5; 5 .5; 5 1; 3 1; 3 1; -2 .5; -2 .5]

#伴奏    〈八辈子〉
chords = [3 -2 3 5 7 5 10 7 3 -2 3 5 7 5 10 7 -2 -2 3 5 7 5 10 7 -2 -2 3 5 7 5 7 10]'
t_chord = 0.5  # 所有伴奏音符的时长都为半拍

beats = sum(song[:,2])

l = Int(beats * 2); # 伴奏每个音符都只有半拍，所以长度乘个二
while length(chords) < l
    chords = [chords; chords]
end
chords = chords[1:l]

wave =[]
for i = 1:size(song, 1)
    f = a1 * r^song[i,1]
    f_t = t * song[i,2]

    tone = makewave(f, f_t, 1, Fs)
    wave = isempty(wave) ? tone : [wave; tone]
end

wave_c = []
for i = 1:size(chords, 1)
    f = a1 * r^chords[i]
    f_t = t * .5;  # 伴奏每个音符都只有半拍

    tone = makewave(f, f_t, .3, Fs)
    wave_c = isempty(wave_c) ? tone : [wave_c; tone]
end

ll = min(length(wave), length(wave_c))

wav = wave[1:ll] + wave_c[1:ll]
wavplay(wav, Fs)
