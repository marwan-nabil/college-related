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

quantized_signal=quantizenumeric(sampled_signal,1,16,14,'nearest'); %quantize the sampled signal to the nearest value

plot(quantized_signal);

%%converting the quantized signal to binary
object=fi(quantized_signal,1,16,14);
binary_bits=object.bin                       %%binary representation sequence


%%mean square error calculations
N=length(sampled_signal);
sum=0;
for i=1:length(input_signal)
    sum=sum+(1/N)*((quantized_signal(i)-sampled_signal(i)).^2);
end
MSE=sum                %%mean square error
