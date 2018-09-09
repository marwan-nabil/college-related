%% Generate the sine wave with Amplitude=1 V and Freq=2 Hz
fm=2;                             %%Frequency of sinusoid
t=0:1/(100*fm):2/fm;              %%time index with two cycles
input_signal=cos(2*pi*fm*t);
figure
plot(t,input_signal)
 
%%sampling the input signal at fs=4000 Hz
fs=4e3;                           %% sampling rate
ts=0:1/fs:2/fm;                   %%time index
sampled_signal=cos(2*pi*fm*ts);
 
figure
plot(t,input_signal);             %%plotting the input signal
hold on;
stem(ts,sampled_signal);          %%plotting the generated signal

%%Quantization process
n=3;                               %%try n= 4 , 5, 10 
m=(2*n)+1;
a=double(fi(sampled_signal,1,m,n));       
quantized_signal=a;            %%quantized signal                    
figure
plot(quantized_signal);

%%converting the quantized signal to binary
object=fi(quantized_signal,1,16,14);
binary_bits=object.bin                       %%binary representation sequence

%%mean square error calculations
N=length(sampled_signal);
sum=0;
for i=1:length(sampled_signal)
    sum=sum+(1/N)*((quantized_signal(i)-sampled_signal(i)).^2);
end
MSE=sum                %%mean square error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Reconstruction from oversampling%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=0:0.001:1;                              %%sampling frequency(fs) =1000 Hz
y=2*cos(2*pi*5*t);                        %%fm=5 Hz
[B,A]=butter(3,1000/100000,'low');        %%low pass filter 
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
    zero_added_signal(i*10)=y(i);
end

zero_added_signal(1:9)=[];
t=linspace(0,1,length(zero_added_signal));
filtered_signal=filter(B,A,zero_added_signal);  %%filter the signal with low pass fiter and put the result in zero_added_signal 
figure
plot(t,filtered_signal,'r')
xlabel('time')
ylabel('oversampled signals')

s=fft(filtered_signal);
s=fftshift(s);
fs=1000;                %%as it is an over sampling
freq=linspace(-fs/2,fs/2,length(s));
figure
plot(freq,abs(s))
xlabel('freq')
ylabel('mag of over sampled signal')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Reconstruction from minimum sampling(critical)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=0:0.1:1;                     %%as f2=(2*5)=10 Hz
y=2*cos(2*pi*5*t);
[B,A]=butter(10,0.1,'low');
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
    zero_added_signal(i*10)=y(i);
end

zero_added_signal(1:9)=[];
t=linspace(0,1,length(zero_added_signal));
filtered_signal=filter(B,A,zero_added_signal);
figure
plot(t,filtered_signal,'r')
xlabel('time')
ylabel('minimum sampled signals')

s=fft(filtered_signal);
s=fftshift(s);
fs=10;                %%as it is a minimum sampling
freq=linspace(-fs/2,fs/2,length(s));
figure
plot(freq,abs(s))
xlabel('freq')
ylabel('mag of minimum sampled signal')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Reconstruction from undersampling%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=0:0.2:1;                           %%fs=5 Hz
y=2*cos(2*pi*5*t);
[B,A]=butter(10,0.2,'low');
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
    zero_added_signal(i*10)=y(i);
end

zero_added_signal(1:9)=[];
t=linspace(0,1,length(zero_added_signal));
filtered_signal=filter(B,A,zero_added_signal);
figure
plot(t,filtered_signal,'r')
xlabel('time')
ylabel('under sampled signals')

s=fft(filtered_signal);
s=fftshift(s);  
fs=5;                           %%as it is an under sampling
freq=linspace(-fs/2,fs/2,length(s));
figure
plot(freq,abs(s))
xlabel('freq')
ylabel('mag of under sampled signal')
 