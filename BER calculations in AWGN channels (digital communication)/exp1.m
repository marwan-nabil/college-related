num_bit=1e6;                              %Signal length 
SNRdB=0:2:30;                             %Signal to Noise Ratio (in dB)
SNR=10.^(SNRdB/10);                        %begin from 1 to 16 as indices
 for count=1:16                             %Beginning of loop for different SNR
         No=1/SNR(count);                   %Calculate noise power from SNR
         Error=0;     
         data=randi([0 1],1,num_bit);        %Generate binary data source 
         N=sqrt(No)*randn(1,num_bit);        %Generate AWGN
         Y=data+N;                           %Received Signal
         for k=1:num_bit                     %Taking decision and deciding error
             if ((Y(k)> 0.5 && data(k)==0)||(Y(k)<0.5 && data(k)==1))
                 Error=Error+1;
             end
         end
         Error=Error/num_bit;             %Calculate error/bit
         BER_sim(count)=Error;     %Calculate BER for a particular SNR 
 end                                      %Termination of loop for different SNR 
 semilogy(SNRdB,BER_sim);
 axis([min(SNRdB) max(SNRdB) 10^-4 1]);
 Pt=norm(data,2)^2/length(data);