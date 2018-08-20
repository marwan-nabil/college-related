
%%% signal_gen() function : builds time base signals from user input
% note that all user inputs used by main.m are returned by the function (not local)

function [signal_generated, time_base, sampling_freq, Nbreak, start_time, end_time] = signal_gen()

fprintf('Data entry for the time base signal:\n')

% initial signal structure is input by user
sampling_freq=input('enter the sampling frequency ');          
start_time=input('enter the signal start time ');                 
end_time=input('enter the signal end time ');    
time_base=linspace(start_time,end_time,(end_time-start_time)*sampling_freq);
Nbreak=input('enter the number of break points (other than start and end times) in signal definition ');

% save position of each break point
b=[];
if Nbreak>0
    b=zeros(1,Nbreak); % preallocation
    for j=1:Nbreak
        fprintf('enter the position (in time) of break point %d ',j);
        b(1,j)=input(' ');
    end
end
% this is the total break points vector (start and end times included)
bpos=[start_time b end_time]; 
fprintf('\n\n');

% signal generation
fprintf('assembling signal parts one by one: \n\n');
m=[]; % signal segments are accumulated in this vector
for i=1:Nbreak+1
    fprintf('signal segment no.%d \n',i);
    choice=menu('functions','DC','Ramp','exponential','sinusoidal');
    switch (choice)
        case 1      %DC signal
            Amp=input('enter the amplitude of DC  ');           
            m=[m Amp*ones(1,(bpos(1,i+1)-bpos(1,i))*sampling_freq)];
            % note that (bpos(1,i+1)-bpos(1,i)) is the time length of the
            % current segment
        
        case 2      %Ramp signal
            slope=input('enter the slope of Ramp  ');             
            intercept=input('enter the intercept  ');
            ttemp=linspace(0,(bpos(1,i+1)-bpos(1,i)),(bpos(1,i+1)-bpos(1,i))*sampling_freq);
            m=[m (slope*ttemp)+intercept];
        
        case 3      %exponential signal
            Amp=input('enter the amplitude  ');
            expo=input('enter the exponent  ');
            ttemp=linspace(0,(bpos(1,i+1)-bpos(1,i)),(bpos(1,i+1)-bpos(1,i))*sampling_freq);
            m=[m Amp*exp(expo*ttemp)];  
        
        case 4      %sinusoidal signal
            Amp=input('enter the amplitude  ');                 
            omega=input('enter the frequency of the sin  ');
            phi=input('enter the phase in degrees ');
            offset=input('enter the DC offset  ');
            phi=(phi)*pi/180; % degree to radian
            ttemp=linspace(0,(bpos(1,i+1)-bpos(1,i)),(bpos(1,i+1)-bpos(1,i))*sampling_freq);
            m=[m Amp*sin(2*pi*omega*ttemp+phi)+offset];
        
        otherwise 
            error('cant happen !');
    end
end
signal_generated=m;
return
end

