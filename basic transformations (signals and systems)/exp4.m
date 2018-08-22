function exp4()
fprintf('step 4: sound processing experiment \n\n');
%Read the input sound and play it
sound=wavread('comic010.wav');
wavplay(sound,44100);

figure('Name','fourth experiment');

%plot the sound signal in time domain
subplot(2,3,1)
stem(sound);
title('sound signal in time domain ');

% applying fourier transform on sound signal and plotting the magnitude
% frequency response
%Fourier=(fft(sound));
sound_fourier=abs(fftshift(fft(sound)));
%the sound file is 4sec long, so the frequency is 44100/4=11025
Fvec=linspace(-44100/2,44100/2,length(sound));

%plotting the magnitude frequency response
subplot(2,3,2)
stem(Fvec,sound_fourier);
title('sound signal in frequency domain');

%defining the system impulse response function h(t)

impulse_response =[1 zeros(1,44100) 0.6];

%plotting the impulse respose h(t)
t=[0 linspace(0,1,44100) 1];
subplot(2,3,3)
stem(t,impulse_response)
title('impluse response of the system');

%convolving input sound signal with h(t)
s_out=conv(sound,impulse_response);
subplot(2,3,4)
stem(s_out)
title('output signal from the system ');

%playing the output waveform sound 

wavplay(s_out,44100);

%comment :input sound is duplicated,delayed and the delay part is 
%attenuated to 0.6 of the input signal when it passed throught the system

sound_fourier(8000:end) = sound_fourier(8000:end)*0;
sound_fourier(1:5800)= sound_fourier(1:5800)*0 ;
subplot(2,3,5)
stem(Fvec,sound_fourier)
title('signal after passing the filter');
sound2=real(ifft(sound_fourier));
subplot(2,3,6)
stem(sound2)
title('sound in time domain after filtering');
wavplay(sound2,4000);



 