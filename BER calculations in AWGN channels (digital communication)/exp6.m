function linecodestech()

%this function is used to develop several line codes techniques
%for any input vector x

%%% First non return to zero tech.
%if input equals 1 it will give a signal of value 1, else -1
x=randi([0 1],1,7);
n=length(x);
i=1;
t=0:0.01:n;
y1=zeros(1,length(t));
for j=1:length(t)
    if(t(j)<=i)
        
        if (x(i)==1) %if signal equals one then 
             y1(j)= 1; % output will be 1 for the bit duration
        else
            y1(j)=-1;  %if zero then it will be -1 the whole duration
        end
    else
        i=i+1;
    end
end
figure
subplot(6,1,1) %plotting the signal
plot(t,y1)
title('NRZ code');
 [Px1,F] = periodogram(y1,[],length(y1),1/0.01); %power spectral density calculation
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%second return to zero (III in PDF)
%%same as previous coding but alwas the second half bit duration is zero
i=1;
a=0; %for the bit begining
b=0.5; % to find the half bit duration
t=0:0.01:n;
y2=zeros(1,length(t));
for j=1:length(t)
    if(t(j)<=b && t(j)>=a) %less than half duration then same as NRZ
        
        if (x(i)==1)
             y2(j)= 1;
        else
            y2(j)=-1;
        end
    elseif(t(j)>b && t(j)<=i) %greater than half duration, generate zero
        y2(j)=0;
    else
        i=i+1;
        a=a+1;
        b=b+1;
   end
end

subplot(6,1,3) %plotting
plot(t,y2)
title('RZ coding');
[Px2,F] = periodogram(y2,[],length(y2),1/0.01); %PSD generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Third: manchester coding
%almost same as previus but at half bit duration return to the proper value
i=1;
a=0;
b=0.5;
t=0:0.01:n;
y3=zeros(1,length(t));
for j=1:length(t)
    if(t(j)<=i)
      
        if (x(i)==1)
            if (t(j)>=a && t(j)<= b)    %% first half interval of bit duration
                y3(j)=1;
            elseif(t(j)>b && t(j)<=i)  %%second half interval of bit durration
                y3(j)=-1;
            else
                i=i+1;
                a=a+1;
                b=b+1;
            end
        elseif(x(i)==0)     %%%if current bit is zero
            
             if (t(j)>=a && t(j)<= b)  
                y3(j)=-1;                   %%first half is -1
            elseif(t(j)>b && t(j)<=i)
                y3(j)=1;                    %%second half is 1
            else
                i=i+1;
                a=a+1;
                b=b+1;
            end
        
       end
    else
        i=i+1;
        a=a+1;
        b=b+1;
        
    end
end
subplot(6,1,5)
plot(t,y3) %plotting waveform
title('manchester coding');
 [Px3,F] = periodogram(y3,[],length(y3),1/0.01); %%psd calc.
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Forth: AMI
i=1;
t=0:0.01:n;
y4=zeros(1,length(t));
for j=1:length(t)
    if(t(j)<=i)
        
        if(x(i)==0)  %%if zero then generate a zero output
            y4(j)=0;
        elseif(x(i)== 1)  %%if ont then it might be +1 or -1
            if (i==1)    %%intial value
                y4(j)=1;
            else
            z=sum(x(1:i-1)); %%to know the number of ones before the input
            
            
                if (rem(z,2)==0)  %%condition to make it high
                y4(j)=1;
                else
                y4(j)=-1;
                end
            end
            
                
        end
    
    
    else 
        i=i+1;
    end
end
subplot(6,1,4)
plot(t,y4);     %%plotting waveform
title('AMI coding'); 

[Px4,F] = periodogram(y4,[],length(y4),1/0.01); %%PSD calc.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%fifth MLT-3
%%this code can be used if no more than four conseq. zeros occurs
%%always the condition of maximum conseq. zeros must be defined for this
%%modulation

i=1;
t=0:0.01:n;
x2=zeros(1,n);
y5=zeros(1,length(t));
%%this part is used to generate a sequence of 5 values, corresponding to 4
%%types of transition and a value for keeping the same waveform as previous
for i=1:n
    if(x(i)==0)
        x2(i)=0;
    elseif(x(i)==1)
        l=sum(x(1:i));
        z=rem(l,4);
        if(z==1)
            x2(i)=4;
        elseif(z==2)
            x2(i)=1;
        elseif(z==3)
            x2(i)=2;
        else
            x2(i)=3;
        end
    end
end
i=1;

%%in this part the values generated previously are used to generte the output 
%%waveform
for j=1:length(t)
    if(t(j)<=i)
        
        if(x2(i)==1)
            y5(j)=0;
        elseif(x2(i)==2)
            y5(j)=-1;
        elseif(x2(i)==3)
            y5(j)=0;
        elseif(x2(i)==4)
            y5(j)=1;
          %%%this part is used to generate the same sequence given the input is equal zero  
        elseif(x(i-1)==1)
            if(x2(i-1)==1)
            y5(j)=0;
            elseif(x2(i-1)==2)
            y5(j)=-1;
            elseif(x2(i-1)==3)
            y5(j)=0;
            elseif(x2(i-1)==4)
            y5(j)=1;
            end
            elseif(x(i-2)==1)
            if(x2(i-2)==1)
            y5(j)=0;
            elseif(x2(i-2)==2)
            y5(j)=-1;
            elseif(x2(i-2)==3)
            y5(j)=0;
            elseif(x2(i-2)==4)
            y5(j)=1;
            end
           elseif(x(i-3)==1)
            if(x2(i-3)==1)
            y5(j)=0;
            elseif(x2(i-3)==2)
            y5(j)=-1;
            elseif(x2(i-3)==3)
            y5(j)=0;
            elseif(x2(i-3)==4)
            y5(j)=1;
            end
            elseif(x(i-4)==1)
            if(x2(i-4)==1)
            y5(j)=0;
            elseif(x2(i-4)==2)
            y5(j)=-1;
            elseif(x2(i-4)==3)
            y5(j)=0;
            elseif(x2(i-4)==4)
            y5(j)=1;
            end
        end
    
    
    else 
        i=i+1;
    end
end 
subplot(6,1,6)
plot(t,y5)  %%plotting waveform
title('MLT-3 coding');
[Px5,F] = periodogram(y5,[],length(y5),1/0.01); %%PSD calc.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Lastly: NRZ-I 
%%in this modulation bit 1 reverses the waveform while zero keeps it the same

i=1;
t=0:0.01:n;
y6=zeros(1,length(t));

for j=1:length(t)
    if(t(j)<=i)
        if(x(i)==1)
            if(i==1)
                y6(j)=-1;
            else
                z3=sum(x(1:i-1));
                if(rem(z3,2)==0)
                    y6(j)=-1;
                else
                    y6(j)=1;
                end
            end
        end
        
        if(x(i)==0)
            if(i==1)
                y6(j)=1;
            else
                z4=sum(x(1:i-1));
                if(rem(z4,2)==0)
                    y6(j)=1;
                else
                    y6(j)=-1;
                end
            end
        end
        
             
    
    else
        i=i+1;
    end
    
end
subplot(6,1,2)
plot(t,y6);  %%plotting
title('NRZ-I');

 [Px6,F] = periodogram(y6,[],length(y6),1/0.01); %%psd calc.

 
 %%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%plotting power spectral density of all the previous modulation
 
 
 %PSD of NRZ
 figure
 subplot(6,1,1)
 plot(F,Px1);
 title('NRZ psd');
 
 %psd of RZ
 subplot(6,1,3)
 plot(F,Px2);
 title('RZ psd');
 
 %psd on manchester
 subplot(6,1,5)
 plot(F,Px3);
 title('manchester psd')
 
 
 %psd of AMI
 subplot(6,1,4)
 plot(F,Px4);
 title('AMI psd')
 
 
 %PSD of MLT-3
 subplot(6,1,6)
 plot(F,Px5);
 title('MLT-3 psd');
 
 %PSD of NRZ-I
 subplot(6,1,2)
 plot(F,Px6);
 title('NRZ-I psd');