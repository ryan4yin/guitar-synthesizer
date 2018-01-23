Fs = 44100;
a1 = 440;  %标准音
r = nthroot(2,12); %12平均律的比值
t = .5; %1拍的时长

%主旋律 〈八辈子〉
song = [3 1; 5 1; 3 1; 3 .5; 5 .5; 10 1; 10 1; 10 .5; 7 .5; 5 .5; 7 .5; 5 1; 3 1; 3 1; 
   3 .5; 5 .5; 5 1; 3 1; 3 1; -2 .5; -2 .5;
];
%伴奏    〈八辈子〉
chords = [3 -2 3 5 7 5 10 7 3 -2 3 5 7 5 10 7 -2 -2 3 5 7 5 10 7 -2 -2 3 5 7 5 7 10];


l = sum(song(:,2)) * 2;
while length(chords) < l
    chords = [chords chords];
end
chords = chords(1:l);


wav =[];
for i=1:length(song)
    f = a1 * power(r,song(i,1));
    f_t = t * song(i,2);
    wav = [wav makewav(f ,f_t, 1, Fs)];
end

wav_c = [];
for i=1:length(chords)
    f = a1 * power(r,chords(i));
    f_t = t * .5;
    wav_c = [wav_c makewav(f ,f_t, .3, Fs)];
end


ll = min(length(wav), length(wav_c));
wav = wav(1:ll) + wav_c(1:ll);
%audiowrite('res.wav',wav,Fs);
sound(wav,Fs)