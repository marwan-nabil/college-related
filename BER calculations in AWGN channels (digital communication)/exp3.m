%% This code compares the performance of different mod. tech. (ASK - PSK -FSK)
TX = randi([0,1],1,10000); %random sequence of zeros and ones 
TX_ASK = TX;               %OOK is the same sequence
TX_PSK = (2*TX-1); %BPSK, can be done this way to rebresent 1's and 0's as 1's and -1's
TX_FSK = zeros(1,length(TX)); %we need to use for loop to do it, so we prepare the array of 0's here first
ber_ASK=[];ber_PSK=[];ber_FSK=[]; %prepare the ber arrays for every mod. tech.

%%FSK generation
for i= 1:length(TX)
    if TX(i) == 0  
        TX_FSK(i) = 1;       
    else       
        TX_FSK(i) = j; %where j is the complex number sqrt(-1)
    end
end    
for snr = 0:2:30
%%here we add awgn and we also use measured to calc the power beacuae
    %%it's not unity
        RX_ASK = awgn (TX_ASK,snr,'measured'); RX_PSK = awgn (TX_PSK,snr,'measured');
        RX_FSK = awgn (TX_FSK,snr,'measured'); %NOTE :  If TX_FSK is complex, awgn adds 
        %complex noise whish is the case here
        
%%here we make a decision the bits were 1's or 0's depends on each
  %mod. tech.
       for i= 1:length(TX)
        %for ASK the threshold is 0.5
            if  RX_ASK(i) <= 0.5 
                RX_ASK(i) = 0;
            else                    
                RX_ASK(i) = 1;
            end
            
        %for BPSK the threshold is 0
            if RX_PSK(i) <=0
                RX_PSK(i)=0;
            else
                RX_PSK(i)=1;
            end
            
         %for FSK the threshold is real 0.5 and imag 0.5 because we deal
         %here with complex numbers and both parts are affected as
         %mentioned
            if imag(RX_FSK(i)) <= 0.5 && real(RX_FSK(i)) >= 0.5
                RX_FSK(i)=0;
            else
                RX_FSK(i)=1;
            end
        end
        
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
xlabel ('SNR'); ylabel ('BER'); legend('ASK','PSK','FSK'); grid
