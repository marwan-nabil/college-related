function exp2()
global message_sig;
global tbase;
global fsamp;
global brkpoints;
global tstart;
global tend;

fprintf('step 2: acquiring the impulse response of sys. using signal generator func. \n\n');

[impulse_response,itbase,ifsamp,ibrkpoints,itstart,itend]=signal_gen(); 
try        % in case of frequency mismatch
    if ifsamp~=fsamp
        error('freq. mismatch');
    end
catch
    fprintf('sampling frequency mismatch, using the message freq. instead\n');
end  

% time domain plot of original signal
subplot(2,2,3);
stem(itbase,impulse_response);
title('Original signal in time domain');

% freq domain plot of original signal
subplot(2,2,4);
impulse_response_freq=abs(fftshift(fft(impulse_response)));
fvec=linspace(-fsamp/2,fsamp/2,length(impulse_response_freq)); % frequency base vector
stem(fvec,impulse_response_freq/length(impulse_response_freq));
title('Original signal in frequency domain');


% The output is a result of convolution of the input signal and an impulse signal
output=conv(impulse_response,message_sig)./fsamp;

% The required time interval of convolution
tn=linspace(tstart+itstart,tend+itend,length(output));

% plotting the output signal in the time domain
figure('Name','second experiment');
subplot(3,2,1),stem(tn,output);     
title('Convoluted signal in time domain');

% the output signal to be plotted in frequency domain
fvec=linspace(-fsamp/2,fsamp/2,length(output));   
OUTPUT=abs(fftshift(fft(output)));
subplot(3,2,2),stem(fvec,OUTPUT/length(output));
title('Convoluted signal in frequency domain');

% get the standard deviation for the noise you want to add to the output
sigma=input('enter the standard deviation of the noise signal ');
noise=sigma*randn(1,length(output));
noisysignal=output + noise;

% Plotting the noisy signal in the time domain
subplot(3,2,3),stem(tn,noisysignal);
title('Convoluted signal with noise in time domain')

% get the signal back by using deconvolution
if impulse_response(1)==0       % just to avoid deconv error
    impulse_response(1)=.01;
end
inverse=deconv(output,impulse_response).*fsamp; 

% plot the original (recovered) signal in the time domain
subplot(3,2,4),stem(tbase,inverse);
title('Original (recovered) signal in time domain')

% the original (recovered) signal to be plotted in frequency domain
inverse_freq=abs(fftshift(fft(inverse)));
fvec=linspace(-fsamp/2,fsamp/2,length(inverse_freq));   
subplot(3,2,5),stem(fvec,inverse_freq/length(inverse_freq));
title('Original (recovered) signal in frequency domain');



end

