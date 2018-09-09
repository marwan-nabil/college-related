%%%% simulation parameters
num_bits = 1e6;
snr_range = linspace(0,30,16); % array of SNR's
m = 10; % samples per waveform
T = 10 ; % sampling instant
S1(1:m) = 1;
S2(1:m) = 0; % the two known waveforms
BER(1:16) = 0; % initialization for BER results vector
g = S1-S2;
reverse_g = g(end:-1:1); % time reverse g, like g(-t)
MF = filter(reverse_g,1,g); % the matched filter
%%%% averaging loop (16 iterations) one for each SNR and resulying BER
for i = 1:16
data = randi([0 1],1,num_bits); % random message data bits (source)
message = repelem(data,m); % m samples per bit
rx_sequence = awgn(message,snr_range(i)-10*log10(m),'measured'); % adding GN on a sample basis
% at the receiver end
filtered_signal=conv(rx_sequence,MF); % convoluting with MF
sampled_filtered = filtered_signal(T : T : end); % sampling
% comparator
receieved_message = (sampled_filtered > 0.5); % comparing to the threshold
result = xor(receieved_message,data); % detecting errors (1's)
BER(i) = sum(result)/num_bits; % calculating BER
end
semilogy(snr_range,BER);
xlabel('SNR');
ylabel('BER');
