function exp1()
global message_sig;
global tbase;
global fsamp;
global brkpoints;
global tstart;
global tend;

fprintf('step 1: acquiring the original message and its time base using the signal generator func. \n\n');

% signal_gen() returns the generated message + all user inputs used in main
[message_sig,tbase,fsamp,brkpoints,tstart,tend]=signal_gen(); 
fprintf('step 2: plotting the original message in time and freq. domains \n\n');

% creating a figure
figure('Name','first experiment');

% time domain plot of original signal
subplot(2,2,1);
stem(tbase,message_sig);
title('Original signal in time domain');

% freq domain plot of original signal
subplot(2,2,2);
message_sig_freq=abs(fftshift(fft(message_sig)));
fvec=linspace(-fsamp/2,fsamp/2,length(message_sig_freq)); % frequency base vector
stem(fvec,message_sig_freq/length(message_sig_freq));
title('Original signal in frequency domain');

end