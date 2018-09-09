%% This code evaluate BER of 16QAM mod. tech.
%constealtion of a 16QAM tech stored in c
c = [-3-3i -3-1i -3+3i -3+1i -1-3i -1-1i -1+3i -1+1i 3-3i 3-1i 3+3i 3+1i 1-3i 1-1i 1+3i 1+1i ];  
M = length(c); %which is 16
data = randi([0 M-1],10000,1); %random sequence of symbols fro 0 to 15
TX_QAM = genqammod(data,c);  %mod of 16QAM using the built in fn.
ber_QAM=[]; %prepare the ber arrays 

for snr = 0:2:30
%%here we add awgn and we also use measured to calc the power beacuae
    %%it's not unity
        RX_QAM = awgn(TX_QAM,snr,'measured');
        RX_QAM = genqamdemod(RX_QAM,c);  %Demod of 16QAM using the built in fn.
        %% here we compare the sent and detected bits using biterr function 
        %to find BER which we're interested in
        [n1,BER1] = biterr (data,RX_QAM); 
        %% here we save them in a matrix for each snr
        ber_QAM = [ber_QAM BER1];
end

%%here we plot snr vs BER
snr = (0:2:30)';
semilogy(snr,ber_QAM)
xlabel ('SNR') ; ylabel ('BER') ; legend('16QAM') ; grid
%%the following if we're interested in plotting the constelation of 16QAM
%  h = scatterplot(TX_QAM);
%  hold on
%  scatterplot(c,[],[],'r*',h)
%  grid 