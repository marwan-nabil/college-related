%% This code compares the performance of different mod. tech. (ASK - PSK - FSK)
M=2;  % Modulation order
TX = randi([0,1],1,10000); %random sequence of zeros and ones 
TX_ASK = TX;               %OOK is the same sequence
ber_ASK=[];ber_PSK=[];ber_FSK=[]; %prepare the ber arrays for every mod. tech.
TX_PSK = pskmod(TX,M,pi); %mod of psk using the built in fn.
TX_FSK = fskmod(TX,M,1,2,4); %mod of fsk using the built in fn.

for snr = 0:2:30
%%here we add awgn and we also use measured to calc the power beacuae
    %%it's not unity
        RX_ASK = awgn (TX_ASK,snr,'measured');
        RX_PSK = awgn (TX_PSK,snr,'measured');
        RX_FSK = awgn (TX_FSK,snr,'measured'); %NOTE :  If TX_FSK is complex, awgn adds 
        %complex noise whish is the case here
        
%%here we make a decision the bits were 1's or 0's
  %for ASK the threshold is 0.5
        for i= 1:length(TX)
             if  RX_ASK(i) <= 0.5 
                 RX_ASK(i) = 0;
             else                    
                 RX_ASK(i) = 1;
             end
        end
        RX_FSK = fskdemod(RX_FSK,M,1,2,4);  %Demod of fsk using the built in fn.
        RX_PSK = pskdemod(RX_PSK,M,pi);     %Demod of psk using the built in fn.
        %% here we compare the sent and detected bits using biterr function 
        %to find BER which we're interested in all cases
        [n1,BER1] = biterr (TX,RX_ASK);  [n2,BER2] = biterr (TX,RX_PSK);  [n3,BER3] = biterr (TX,RX_FSK);
        %% here we save them in a matrix for each snr
        ber_ASK = [ber_ASK BER1];ber_PSK = [ber_PSK BER2];   ber_FSK = [ber_FSK BER3];

end
    
%%here we plot snr vs each BER together on the same figure to be able to
%%compare
snr = (0:2:30)';
semilogy(snr,[(ber_ASK)' (ber_PSK)' (ber_FSK)'])
xlabel ('SNR');ylabel ('BER');legend('ASK','PSK','FSK');grid
