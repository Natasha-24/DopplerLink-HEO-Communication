clc;
clear;
close all;

%% DOPPLERLINK - PHASE 2
% Generate binary data, BPSK symbols and AWGN signal.

rng(10);                         % Repeatable simulation
Nbits = 5000;
EbN0_dB = 8;

bits = randi([0 1],1,Nbits);

% BPSK mapping: 0 -> -1, 1 -> +1
symbols = 2*bits - 1;

% Unit-energy BPSK with AWGN
EbN0 = 10^(EbN0_dB/10);
noise_sigma = sqrt(1/(2*EbN0));
noise = noise_sigma*randn(1,Nbits);

rx_awgn = symbols + noise;

fprintf('DOPPLERLINK - PHASE 2\n');
fprintf('===============================================\n');
fprintf('Number of bits = %d\n',Nbits);
fprintf('Eb/N0           = %.2f dB\n',EbN0_dB);

figure;
stem(1:50,bits(1:50),'filled');
grid on;
ylim([-0.2 1.2]);
xlabel('Bit Index');
ylabel('Bit Value');
title('Transmitted Binary Data');

figure;
stem(1:50,symbols(1:50),'filled');
grid on;
ylim([-1.5 1.5]);
xlabel('Symbol Index');
ylabel('BPSK Amplitude');
title('BPSK Modulated Symbols');

figure;
stem(1:50,rx_awgn(1:50),'filled');
grid on;
xlabel('Symbol Index');
ylabel('Received Amplitude');
title('BPSK Signal after AWGN');

figure;
plot(real(rx_awgn),zeros(size(rx_awgn)),'.');
grid on;
xlabel('In-phase');
ylabel('Quadrature');
xlim([-2 2]);
ylim([-1 1]);
title('BPSK Constellation after AWGN');

save('Phase2_BPSK_AWGN.mat','bits','symbols','rx_awgn','Nbits','EbN0_dB');

fprintf('Phase 2 completed.\n');
fprintf('Results saved to Phase2_BPSK_AWGN.mat\n');

