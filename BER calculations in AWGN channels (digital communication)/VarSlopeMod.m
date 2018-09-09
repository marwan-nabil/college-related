function [Out_Sign, Delta_Mod]= VarSlopeMod (Step,Ts,Act_Signal,Start, End,t)

Delta_Mod= zeros(1,((End/Ts)+1)); %Creating a variable to hold Delta Modulated Signal's values
Out_Sign = zeros(1,((End/Ts)+1));%Creating a variable to hold Output Signal's values
for i=2:(((End-Start)/Ts)+1) 
    Slope =  (Act_Signal(i) -  Act_Signal(i-1))/Ts;
    if Act_Signal(i-1) >  Delta_Mod (i-1);
        if Slope < 0.7 && Slope > 0  ; 
        Out_Sign (i) = 1;
        Delta_Mod (i) = Delta_Mod(i-1) + Step;
        end 
   
    elseif  Slope > 0.7 ;
          Out_Sign (i) = 1;
        Delta_Mod (i) = Delta_Mod(i-1) + 2*Step;

    else
        Out_Sign (i) = 0;
         Delta_Mod (i) = Delta_Mod(i-1) - Step;
         
    end   
end

plot (t,Act_Signal,'r')% Temp: Actual Signal Plot
grid on
hold on % Drawing Actual & Delta-Modulated Signals on the same plot

stairs (t,Delta_Mod) % Generating the complete Delta-Modulated Approximation Signal in staircase form
axis([Start End -4 4])
title('Modulated and Output Signals')
hold on
end


