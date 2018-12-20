function wav = makewav(f,t,s,Fs)
% f : 频率
% t : 时长
% Fs: 采样频率

    N = round(Fs*t); %总的采样点个数
    L = floor(Fs/f); %一个周期所含的采样数(整)
    part = rand(1,L)-0.5; %循环段
    np = floor(N/L); %总的循环次数

    r = 0.5; %平均权值

    wav=zeros(1,N);
    for i=1:np
        part = part * r + [part(end) part(1:end-1)] * (1 -r);   % 吉他音质算法
        pos = L * (i -1) + 1;
        wav(pos:pos+L-1) = part;
    end

    wav = wav.*linspace(1,0,length(wav));
    wav = wav * s;
end
