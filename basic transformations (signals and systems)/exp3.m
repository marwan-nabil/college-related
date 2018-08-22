
function exp3()
global message_sig;
global tbase;
global fsamp;

fprintf('step 3: acquiring the response of sys. using Difference equation \n\n');

N=input('enter the number of denominator coefficients not including a0 ');
M=input('enter the number of numerator  coefficients ');

A=[1 zeros(1,N)]; % denominator coeffs Y
B=zeros(1,M);     % numerator coeffs   X

for i=1:N
    fprintf('The a %d coefficient = ',i);
    A(1,i+1)=input('');
end
for i=1:M
    fprintf('The b %d coefficient = ',i);
    B(1,i)=input('');
end

output_sig=filter(B,A,message_sig);
% inverse system
Ainv=B;
Binv=A;

figure('Name','third experiment');
%%%%%%%%%%%%%%%%%%%%% plotting system responses %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[H,W] = freqz(B,A);  %frequency response of the channel
[h,t_response] = impz(B,A);       %impulse response of the channel

subplot(3,2,1),stem(W/pi,20*log10(abs(H)));  %plotting freq response
title('freq response of channel');

subplot(3,2,2),stem(t_response,h);           %plotting impulse response
title('impulse response of channel');

%%%%%%%%%%%%%%%%%%%%% plotting Output signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting output in time domain
subplot(3,2,3),stem(tbase,output_sig);
title('output in time domain');

% plotting output in frequency domain
output_sig_freq=abs(fftshift(fft(output_sig)));
fvec=linspace(-fsamp/2,fsamp/2,length(output_sig_freq));
subplot(3,2,4),stem(fvec,output_sig_freq);
title('output in frequency domain');

%%%%%%%%%%%%%%%%%%%%% plotting responses of recovery system %%%%%%%%%%%%%%%%%%

[H,W] = freqz(Binv,Ainv);  %frequency response of the recovery channel
[h,t_response] = impz(Binv,Ainv);       %impulse response of the recovery channel

subplot(3,2,5),stem(W/pi,20*log10(abs(H)));  %plotting freq response
title('freq response of recovery channel');

subplot(3,2,6),stem(t_response,h);           %plotting impulse response
title('impulse response of recovery channel');

%%%%%%%%%%%%%%%%%%%%% checking the stability of the system %%%%%%%%%%%%%%%%
figure('name','stability of the channel');
zplane(B,A);
sys=filt(B,A);
if isstable(sys)
    fprintf('system is stable\n');
else
    fprintf('system is unstable\n');
end




end
