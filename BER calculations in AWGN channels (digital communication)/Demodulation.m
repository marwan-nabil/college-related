function filtered= Demodulation (Delta_Mod,t, Start, End)
windowSize = 4;  %Width of the filter
b = (1/windowSize)*ones(1,windowSize); %Numerator Coefficients
a = 1; %Denominator Coefficients

y = filter(b,a,Delta_Mod); %Generating the LPF
filtered = (1/max(y)) *y; %Applying LPF to the staircase signal

%plot(t,Delta_Mod,'r')
%hold on

plot(t,filtered)
axis([Start End -2 2])
%legend('Input Data','Filtered Data')

end