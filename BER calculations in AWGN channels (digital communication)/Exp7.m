%Generating random sequence 
transmitted = randi([0,1],1,1e6);
ber3 = zeros(16,3);
repNum = [3,5,11];
snr = 0:2:30;
%looping for repetition numbers 3, 5 & 11
for j = 1:3,
    sentSeq = repmat(transmitted,repNum(j),1); %Repeating the matrix N times
    sentSeq = sentSeq(:)'; %Converting the column matrix to row matrix by taking the transpose 
    output = zeros(1,size(transmitted,2)); %Output matrix is the same size of transmitted sequence
    
    %%looping on snr values from 0dB to 30dB with step size 2dB%%
    for l = 1:length(snr),   
       received = awgn(sentSeq,snr(l),'measured'); %received sequence after adding AWGN to the sent sequence
       vth = sqrt(1/repNum(j))/2;
       %applying simple detector to the received sequence with threshold 0.5
       for r=1:size(received,2),  
           if  received(r) >= vth, %if the received bit is >= 0.5 then the output is 1
                  received(r) = 1;
           else,                   %if the received bit is < 0.5 then the output is 0   
                  received(r) = 0;
           end
       end
       
       %applying repetition detection, 
       for i= 0:(size(transmitted,2)-1),
           countOnes  =0; %counter for number of ones
           countZeros =0; %counter for number of zeros
           
           %looping on N bits(repetition number) of the sequence
           for k=1:repNum,
               if received((repNum(j)*i)+k) == 1,  %if there is 1, increment ones counter
                   countOnes = countOnes +1;
               else,                            %if there is 0, increment zeros counter
                   countZeros = countZeros + 1;
               end
           end
           %if number of ones > number of zeros, then the output is 1,
           %otherwise, the output is zero
           if countOnes > countZeros,
               output(i+1) = 1;
           else,
               output(i+1) = 0;
           end
       end
       
       %using biterr function to detect the bit rate error ratio
       [num,ber3(l,j)] = biterr(transmitted,output);
    end
    
    %Drawing the snr with the bit error rate at different repetition nums
    
end
figure(1);semilogy(snr, ber3)
grid on 
legend('Rep=3','Rep=5','Rep=11')
title(['Repetition number = ',num2str(repNum)]);
xlabel ('snr(dB)')
ylabel ('bite rate error')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%linear
%Preprocessing 
n=7; %length of the codeword
k=4; %length of the message
ber1=[];   %empty array of bit error rate
polynomial = cyclpoly(n,k);  %generating cyclic polynmial which is used to calculate the remainder and populate the parity check matrix
parityCheckMat = cyclgen(n,polynomial);  %generating parity check matrix (H) which is in the form H=[I|P']
generatingMat = gen2par(parityCheckMat); %calculating the generating matrix from parity check matrix which is in the form G=[P|I]
trt = syndtable(parityCheckMat);  %producing decoding table for an error-correcting binary code having codeword length n and message length k
encData = encode(transmitted,n,k,'linear/binary',generatingMat); %Encoding the transmitted sequence as linear block code
sentSeq = pskmod(encData, 2);
%looping on snr values from 0dB to 30dB with step size 2dB
for i=1:length(snr),
   received = awgn(sentSeq,snr(i),'measured'); %adding noise to the encoded data 
   demod = pskdemod(received,2);
   
   %decoding the received sequence with the same format(linear block code)
   %as the encoded signal
   decData = decode(demod,n,k,'linear/binary',generatingMat,trt);
   decData = decData(1:1e6);
   %calculating the bit error rate between transmitted sequence and the
   %decoded data
   [nums,ratio] = biterr (transmitted,decData);
   ber1 = [ber1 ratio]; %concatenating bit error rate ratios
end

%Drawing the relation between snr at different values and bit error rate
figure(2),semilogy (snr, ber1)
title('Linear Block Code')
xlabel ('snr(dB)')
ylabel ('bit error rate')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%convolution
%Encoding using convolution code
constLength = 7;  
traceBack = 5*constLength;
trellis = poly2trellis(7,[171 133]);
%trellis = poly2trellis(9,[657 435]);
x = convenc(transmitted,trellis);
sentSeq = pskmod(x, 2);
ber2 = []; %bit error rate array

%looping on snr values from 0dB to 30dB with step size 2dB
for i=1:length(snr),
   received = awgn(sentSeq,snr(i),'measured');  %adding AWGN to the received sequence
   
   demod = pskdemod(received, 2);
   
   %decoding the received sequence using vitdec
   %'trunc' measns that the encoder is assumed to have started at the all-zeros state
   %'hard' means that the code contains binary input values.
   demod = pskdemod(received, 2);
   output = vitdec(demod,trellis,traceBack,'trunc','hard');
   [num,ratio] = biterr (transmitted,output);
   ber2 = [ber2 ratio];   %concatenating bit error rate ratios
end

%Drawing the relation between snr at different values and bit error rate
figure(3),semilogy (snr, ber2)
title(['Covolution code with constraint length ',num2str(constLength)])
xlabel ('snr(dB)')
ylabel ('bit error rate')
