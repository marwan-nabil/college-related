clc
% 
% %% Part 1 
% Ts= 0.1; % The chosen sampling time of the modulation
% Step = 0.2; % The chosen step size of the modulation
% sig_start= 0; % Start time of the signal
% sig_end = 6; % End time of the signal
% t = sig_start:Ts:sig_end; %Time interval for the "Actual Signal" generation in ms
% 
% % For Sine Wave
% Act_Signal= sin(2*pi*500*(10^(-3)) *t);% The Actual Signal generation
% figure
% subplot(2,3,1)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,4)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% 
% % For DC Voltage
% Act_Signal= ones (1, ((sig_end-sig_start)/Ts)+1);% The Actual Signal generation
% subplot(2,3,2)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,5)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% % For Square Wave
% Act_Signal= square(2*pi*500*(10^(-3)) *t);% The Actual Signal generation
% subplot(2,3,3)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,6)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% 
% %% Part 2
% 
% Ts= 0.01; % The chosen sampling time of the modulation
% Step = 0.2; % The chosen step size of the modulation
% sig_start= 0; % Start time of the signal
% sig_end = 6; % End time of the signal
% t = sig_start:Ts:sig_end; %Time interval for the "Actual Signal" generation in ms
% 
% % For Sine Wave
% Act_Signal= sin(2*pi*500*(10^(-3)) *t);% The Actual Signal generation
% figure
% subplot(2,3,1)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,4)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% 
% % For DC Voltage
% Act_Signal= ones (1, ((sig_end-sig_start)/Ts)+1);% The Actual Signal generation
% subplot(2,3,2)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,5)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% 
% % For Square Wave
% Act_Signal= square(2*pi*500*(10^(-3)) *t);% The Actual Signal generation
% subplot(2,3,3)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,6)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% 
% 
% %% Part 3
% 
% Ts= 0.01; % The chosen sampling time of the modulation
% Step = 0.02; % The chosen step size of the modulation
% sig_start= 0; % Start time of the signal
% sig_end = 6; % End time of the signal
% t = sig_start:Ts:sig_end; %Time interval for the "Actual Signal" generation in ms
% 
% % For Sine Wave
% Act_Signal= sin(2*pi*500*(10^(-3)) *t);% The Actual Signal generation
% figure
% subplot(2,3,1)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,4)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% % For DC Voltage
% Act_Signal= ones (1, ((sig_end-sig_start)/Ts)+1);% The Actual Signal generation
% subplot(2,3,2)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,5)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation
% 
% 
% % For Square Wave
% Act_Signal= square(2*pi*500*(10^(-3)) *t);% The Actual Signal generation
% subplot(2,3,3)
% [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot
% Out_size= size (Out_Sign,2); 
% Output (Out_Sign,Ts, sig_start, sig_end) % Plotting the Output Signal
% subplot(2,3,6)
% y= Demodulation (Delta_Mod,t, sig_start, sig_end); % Demodulation & Plot
% Diff= (Act_Signal - y).^2; %Square Error
% Err= sum(Diff) .*(1/Out_size) %Mean Square Error Calculation


%% Variable Slope Delta Modulation
% For Sine Wave
Ts= 0.1; % The chosen sampling time of the modulation
Step_0 = 0.2; % The chosen step size of the modulation
sig_start= 0; % Start time of the signal
sig_end = 6; % End time of the signal
t = sig_start:Ts:sig_end; %Time interval for the "Actual Signal" generation in ms

Act_Signal= sin(2*pi*500*(10^(-3)) *t);% The Actual Signal generation
figure
[Out_Sign, Delta_Mod]= VarSlopeMod (Step_0,Ts,Act_Signal,sig_start, sig_end,t); % Delta Modulation & Plot


