function [Out_Sign, Delta_Mod]= Modulation (Step,Ts,Act_Signal,Start, End,t)

Delta_Mod= zeros(1,((End/Ts)+1)); %Creating a variable to hold Delta Modulated Signal's values
Out_Sign = zeros(1,((End/Ts)+1));%Creating a variable to hold Output Signal's values
for i=2:(((End-Start)/Ts)+1) 
    if Act_Signal(i-1) >  Delta_Mod (i-1); %Actual Signal is increasing 
        Out_Sign (i) = 1; 
        Delta_Mod (i) = Delta_Mod(i-1) + Step;
    else %Actual Signal is decreasing 
        Out_Sign (i) = 0;
         Delta_Mod (i) = Delta_Mod(i-1) - Step;
         
    end   
end

%plot (t,Act_Signal,'r')% Temp: Actual Signal Plot
%grid on
%hold on % Drawing Actual & Delta-Modulated Signals on the same plot

stairs (t,Delta_Mod) % Generating the complete Delta-Modulated Approximation Signal in staircase form
axis([Start End -2 2]) %Adjusting the plot range
title('Modulated and Output Signals')
hold on
end


