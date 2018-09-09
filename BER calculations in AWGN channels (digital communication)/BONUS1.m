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
object=fi(quantized_signal,1,5,2);
binary_bits=object.bin                       %%binary representation sequence

%%mean square error calculations
N=length(sampled_signal);
sum=0;
for i=1:length(sampled_signal)
    sum=sum+(1/N)*((quantized_signal(i)-sampled_signal(i)).^2);
end
MSE=sum                                     %%mean square error
