%%%%%%%%%%----- Deomdulation -----------%%%%%%%%%%
% The input to this function is the received modulated signal
%The output to this function is the sequence of 1s and -1s
%% Defining Some Parameters
Tbit = 1; %Bit duration
Samples_Symbol = 32; %Number of samples per each symbol
size=length(OutputTx);
t=-size/2:1:(size/2)-1;
%% Separating I and Q Components 

I_Branch=2*real(OutputTx).*cos(2*pi*890.1*1000000*t);
Q_Branch=2*imag(OutputTx).*sin(2*pi*890.1*1000000*t);

%% Filtering I and Q Components

I_Component = matched_filter(I_Branch,Tbit,Samples_Symbol);
Q_Component = matched_filter(Q_Branch,Tbit,Samples_Symbol);

%%
% obtaining the phase of the analog signal
phase = atan2(Q_Component,I_Component);
derivative = diff(phase);
Test = downsample(derivative,Samples_Symbol);
Trimmed= Test(4: (length(Test))-3);
for i = 1:length(Trimmed)
    if Trimmed(i) <0
        Trimmed(i)=-1;
    else
        Trimmed(i)=1;
    end
end
OutputRx = -Trimmed;
figure
stem (OutputRx)
title('After Demod Stream');
xlabel('Time');
ylabel('Amplitude');

%%%%%%%%%%%%%%%---------- Deinterleaving-------%%%%%%%%%%%

burst_code2=vec2mat((0.5*(OutputRx+1)),156);

%for the deinterleaver
dec_data=zeros(segno2,114*2);
dec_data1=zeros(segno2,114*4);

%demuxing and removing the framing bits
   %concatenating first 4 parts of A,B,C and also the second parts   
   
       for l=0:4:(4)*(segno2-1)
        dec_data(floor(((l+1)/4)+1),:)=[burst_code2(l+1,[4:60]),burst_code2(l+2,[4:60]),burst_code2(l+3,[4:60]),burst_code2(l+4,[4:60])];
        dec_data1(floor(((l+1)/4)+1),:)=[dec_data(floor(((l+1)/4)+1),:),burst_code2((l+5),[89:145]),burst_code2((l+6),[89:145]),burst_code2((l+7),[89:145]),burst_code2((l+8),[89:145])];%A
       end

       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VETERBI DECODER
data_rec_fin=[];
% for segno3=1:1:size(dec_data1,1)
for segno3=1:1:segno2
same=  dec_data1(end-77 :end); %%%class 2 

dec_in=enc_out(1:end-78);


decode=vitdec(dec_in,poly2trellis(5,[31 33]),1,'trunc','hard'); %%not sure about 1

class1a_rec=decode(1:50)';

class1b_rec=decode(54:end-4)';

data_rec=[class1a_rec class1b_rec same];
data_rec_fin(segno3,:)=data_rec;
end

%%%%%%% Breaking the 260 bits to recover the original samples 


temporary_block=[];
stream_after_channel_decoding=[];
for k=1:length(data_rec_fin)
    temporary_block=[];
    for m=1:13:260
        temporary_block=[temporary_block; data_rec_fin(k,m:m+12)];
    end
    stream_after_channel_decoding = [stream_after_channel_decoding ; temporary_block];
end
quatized_stream = bi2de(stream_after_channel_decoding)';