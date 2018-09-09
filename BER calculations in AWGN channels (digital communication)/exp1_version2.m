%%%% simulation parameters
num_bits = 1e6;
snr_range = linspace(0,30,16); % array of SNR's
BER(1:16)=0;
%%%% averaging loop (16 iterations) one for each SNR and resulying BER
for i = 1:16
message = randi([0 1],1,num_bits); % random message data (source)
rx_sequence = awgn(message,snr_range(i),'measured'); % adding GN
receieved_message = (rx_sequence > 0.5); % comparing to the threshold
result = xor(receieved_message,message); % detecting errors (1's)
BER(i) = sum(result)/num_bits; % calculating BER
end
semilogy(snr_range,BER);
xlabel('SNR');
ylabel('BER');
