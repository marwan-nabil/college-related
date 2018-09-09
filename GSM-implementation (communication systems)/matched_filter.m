%definition of the Matched-Filter
function ans = matched_filter(x,T,Samples)
t = (-T:T/Samples:T); 
BT = 0.3;
alpha = 2*pi*BT/(sqrt(log(2)));
Mfil = Q_Fun(alpha*(t-0.5)) - Q_Fun(alpha*(t+0.5)); % impulse response of Matched filter

% need to scale the filter, so that there is a phase change of pi/2 for
% every bit change.

K = pi/2/sum(Mfil);
Mfil = K*Mfil;

%convolve the filter with the signal(I or Q);

ans = conv(Mfil,x);

end