function Output (Out_Sign,Ts, Start, End)

Out_size= size (Out_Sign,2); %Getting the size to use it in iteration
i=1;
Output=[];
while i<Out_size+1
     temp = i-1:Ts:i-Ts; %Generating a large number of sample betwwen each two signal samples to get an accurate output signal
     temp= temp.*Ts; %Adjusting the scale to fit with the signal scale
      if Out_Sign(i)==1 %Reading the output signal
        Output=square(temp*(10^(-3)));  %Draw a square wave if it's 1 
    else
        Output=0;
      end
     hold on 
     plot(temp,Output,'r')
     hold on; 
    axis([Start End -2 2])
     i=i+1;
end

end 
