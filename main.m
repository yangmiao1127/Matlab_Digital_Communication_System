clc;
clear;
close all;

%% init
M=16;   % size of signal constellation
k=log2(M);  % number of bits per symbol
n=30000;    % number of bits to process
numSamplePerSymbol=1;   % oversampling factor
rng default  % use default random number generator

dataIn=randi([0 1],n,1);    

%% plot the 40 bitin in a stem plot
stem(dataIn(1:40),'filled');
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary value');

%% Convert the Binary Signal to integer-valued signal
dataInMatrix = reshape(dataIn,length(dataIn)/k,k);
dataSymbolsIn = bi2de(dataInMatrix);

%% plot
figure;
stem(dataSymbolsIn(1:10));
title('Random Symbols');
xlabel('Symbol Index');
ylabel('Integer Value');

%% Modulate using 16-QAM
dataMod = qammod(dataSymbolsIn,M,'bin');    % Binary coding,phase offset=0

%% SNR
EbNo=10;
snr = EbNo+10*log10(k)-10*log10(numSamplePerSymbol);

%% Received from AWGN channel
receivedSignal= awgn(dataMod,snr,'measured');

%% Show constllation diagram
sPlotFig = scatterplot(receivedSignal,1,0,'g.');
hold on
scatterplot(dataMod,1,0,'k*',sPlotFig);

%% Demodulate 16-QAM
dataSymbolsOut = qamdemod(receivedSignal,M,'bin');

%% Convert the signal to Binary signal
dataOutMatrix=de2bi(dataSymbolsOut,k);
dataOut=dataOutMatrix(:);   % Return data in column vector

%% Compute system BER
[numErrors,ber] = biterr(dataIn,dataOut);
fprintf('\nThe binary coding bit error rate = %5.2e, based on %d errors\n', ...
    ber,numErrors);





