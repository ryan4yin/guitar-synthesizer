function wav = makewav(f,t,s,Fs)
% f : Ƶ��
% t : ʱ��
% Fs: ����Ƶ��

    N = round(Fs*t); %�ܵĲ��������
    L = floor(Fs/f); %һ�����������Ĳ�����(��)
    part = rand(1,L)-0.5; %ѭ����
    np = floor(N/L); %�ܵ�ѭ������

    r = 0.5; %ƽ��Ȩֵ

    wav=zeros(1,N);
    for i=1:np
        part = part * r + [part(end) part(1:end-1)] * (1 -r);   % ���������㷨
        pos = L * (i -1) + 1;
        wav(pos:pos+L-1) = part;
    end

    wav = wav.*linspace(1,0,length(wav));
    wav = wav * s;
end