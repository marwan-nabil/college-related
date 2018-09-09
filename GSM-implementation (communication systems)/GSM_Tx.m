
clc;
close all;
clear all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%---------- ADC STEP-----------%%%%%%%%%%%%


%%%%%recording sound 

recObj1 = audiorecorder;
%%%%record for 5 seconds for user 
disp('Start speaking')
recordblocking(recObj1, 5);
disp('End of Recording ');
sig1 = getaudiodata(recObj1);

%%resampling step
sig1=resample(sig1,8000,3400);

%%%quantization step

max1=max(sig1);
min1=min(sig1);

delta1=(max1-min1)/8191 ; % step size

part1= [min1:delta1:max1];
code1=[1:1:8193];
 
%%%Encoding
[~,sig1q] = quantiz(sig1,part1,code1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%----- SEGMENTATION AND SPEECH CODING STEP ------%%%%%%%%
%%%&&&&&&&&&&&&&&&&&&&&&&&&&&& Segmentation and Speech Coding Part &&&&&&&&&&&&&&&&&&&&&&&&&&
%%%%%%%%%%%%%%%%%%%%%%%%55 Segmentation Part &&&&&&&&&&&&&&&&&&&&&&&&&

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trasmitter Side %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% we will use downsampling concept to reduce data rate 
down_sampled_signal = downsample(sig1q,8);  %Downsample the quantized_samples (ADC signal o/p) as required to have 260 bits/segment
down_sampled_signal = [down_sampled_signal  zeros(20-mod(length(down_sampled_signal),20),1)'];  %%appending zero samples in order to have chunks of 20 samples
output_stream = de2bi(down_sampled_signal,13); %% encoding the results

%%%%%%%%%%%%%%%% Concatinating samples belong to the same segment (20 ms) %%%%%%%%%%%%%%%%%%%%% 
temporary_block=[];
blocks_before_channel_coding=[];
for k=1:20:length(output_stream) %%concatenate every 20 samples to have 20*13 bits for every 20ms
    temporary_block=[];
    for m=k:k+19
        temporary_block=[temporary_block output_stream(m,:)];
    end
    blocks_before_channel_coding=[blocks_before_channel_coding ; temporary_block];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%----------CHANNEL CODING---------%%%%%%%%%%%%%
enc_out_fin=[];
for segno=1:1:size(blocks_before_channel_coding,1) %take segment after segment
voicebits =  blocks_before_channel_coding(segno,:)'; %%should be modified after segmentation
%%CRC for first 50 bits of class 1a
c1a=voicebits(1:50);
crc_obj = comm.CRCGenerator([1 0 1 1],'ChecksumsPerFrame',1);
crc_out = step(crc_obj,c1a);

y=[crc_out; voicebits(51:51+131);0;0;0;0];
%trellis1 = poly2trellis(5,[31 33]);
code1 = convenc(y,poly2trellis(5,[31 33]));

%length(code1)

% %%convolution code for 189 bits (class 1a and 1b)
% y=[crc_out; voicebits(51:51+131);0;0;0;0];
% 
% c=zeros(2*189,1);
% 
% %intial conditions
% c(1,1)=0;
% 
% c(2,1)=y(1,1);
% c(3,1)=y(1,1);
% 
% c(4,1)=y(2,1);
% c(5,1)=rem(y(2,1)+y(1,1),2);
% 
% c(6,1)=y(3,1);
% c(7,1)=rem(y(3,1)+y(2,1),2);
% 
% c(8,1)=rem(y(4,1)+y(1,1),2);
% c(9,1)=rem(y(4,1)+y(3,1)+y(1,1),2);
% 
% %general condition
% for i=5:189
%     c(2*i,1)= rem(y(i)+y(i-3)+y(i-4),2);
%     c(2*i + 1,1)= rem(y(i)+y(i-1)+y(i-3)+y(i-4),2);
% end
% 
% c=c(1:2*189);

enc_out=[code1;voicebits(51+131+1:end)];
enc_out_fin(segno,:)=enc_out';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%------- INTERLEAVING---------%%%%%%%%%%%%%
%%interleaver first level
int_1st_fin=[];
for segno2=1:1:size(enc_out_fin,1) %take segment after segment


temp=enc_out_fin(segno2,:);
int_1st=vec2mat(temp,8);
int_1st_fin(:,:,segno2)=int_1st;

end

%2nd level interleaving 

tail_bits=[0;0;0]';
flag_bit=0;
training_bits=[1;1;1;1;1;0;0;1;1;0;1;0;1;0;0;0;0;0;1;1;0;0;1;0;1;0]';
guard_band=[1;1;1;1;1;1;1;1]';
%3D matrix
%data is having 200 segments A,B,C,D,....
enc_data=zeros(57,8,segno2);
for k=1:segno2
enc_data(:,:,k)=int_1st_fin(:,:,segno2); % 3D matrix
end
zero=zeros(1,57);
rows=57;
cols=8;
%framing the data "interleaving"
 burst_code1=zeros((segno2+1)*4,156);
%for the deinterleaver
% dec_data=zeros(width,114*2);
% dec_data1=zeros(width,114*4);

%%start boundry which has zeros (first 4 segments)
for i=1:4
   burst_code1(i,:) = [tail_bits,enc_data(:,i,1)',flag_bit,training_bits,flag_bit,zero,tail_bits,guard_band];
end
%%general
for j=1:segno2 -1
    for k=1:4        
        burst_code1(4*j+k,:)=[tail_bits,enc_data(:,k,j+1)',flag_bit,training_bits,flag_bit,enc_data(:,k+4,j)',tail_bits,guard_band]; 
    end
end
 %%end boundry (last 4 segments) last is 804
 for m=0:3
   burst_code1(((segno2+1)*4)-m,:) = [tail_bits,enc_data(:,8-m,segno2)',flag_bit,training_bits,flag_bit,zero,tail_bits,guard_band];
 end
 
 %%%%%%%%%%%%%%%%%%%%--------Modulation-----%%%%%%%%%%%%%%%%%%%
 mat2vec=(2*burst_code1 - 1); %convert to 1s and -1s
 Input=mat2vec(:)'; 

%This functions gets an "Input" of a sequence of 1s and -1s

%% Defining Some Parameters
Tbit = 1; %Bit duration
BT = 0.3; % Bandwidth-Time product of Gaussian Filter
Samples_Symbol = 32; %Number of samples per each symbol
Ts= Tbit / Samples_Symbol; %Sample Period
Time=(-2*Tbit : Ts : 2*Tbit);

%% Sequence Generation and Plot

Data =  Input; % Waiting for sequence of 1 and -1
figure 
stem(Data);
title('Input Stream');
xlabel('Time');
ylabel('Amplitude');

%% Filtering the Data using Gaussian Filter and Plot

%Getting the impulse response of the filter
Alpha = 2*pi*BT/(sqrt(log(2)));
Gauss = Q_Fun(Alpha*(2*Time-0.5)) - Q_Fun(Alpha*(2*Time+0.5)); % The impulse response of Gaussian Filter
K=pi/2/sum(Gauss); % Normalizing Filter to ensure phase transitions of pi/2
Gauss = K*Gauss;

%Upsampling and Filtering
New_Data = upsample(Data,Samples_Symbol); %Upsampling for more accurate results
Filtered_Data = conv(Gauss, New_Data); % filter the nrz data
figure
plot(Filtered_Data);
title('Data after Gaussian Filtering');
xlabel('Time');
ylabel('Amplitude');

%% Integration of Filtered Data and Plot

Integration = cumsum(Filtered_Data); % integrate the data.
figure
plot(Integration);
title('Filtered Data after Integration');
xlabel('Time');
ylabel('Amplitude');

%% Generation of I and Q components 

IQcomponents = exp(1i*Integration); % To get the sine and cosine of previous stage output
I = real(IQcomponents);
Q = imag(IQcomponents);
figure
plot(Q);
title('I and Q channels of modulated NRZ');
xlabel('Time');
ylabel('Amplitude');
hold on
plot(I,'r');

%% Generation of Output Signal by Adding Carrier

size=length(I);
t=-size/2:1:(size/2)-1;
OutputTx= I .*cos(2*pi*890.1*1000000*t)-1i*Q.*sin(2*pi*890.1*1000000*t);
figure
plot(t,abs(OutputTx));
title(' Modulated Output Signal');
xlabel('Time');
ylabel('Amplitude');

 

