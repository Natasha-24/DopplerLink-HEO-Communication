
clc;
clear;
close all;

%% DOPPLERLINK - PHASE 5
% BER versus Eb/N0 for baseline AWGN, uncompensated HEO Doppler,
% and ideal ephemeris-based compensation.

rng(20);

Nbits = 10000;
EbN0_dB = 0:2:12;

H = dl_heo_model(Nbits);
t = H.t;
fd = H.fd_2GHz;
doppler_phase = 2*pi*cumtrapz(t,fd);

BER_baseline = zeros(size(EbN0_dB));
BER_doppler = zeros(size(EbN0_dB));
BER_comp = zeros(size(EbN0_dB));

bits = randi([0 1],1,Nbits);
symbols = 2*bits - 1;

for k = 1:length(EbN0_dB)

    EbN0 = 10^(EbN0_dB(k)/10);
    sigma = sqrt(1/(2*EbN0));

    % Use the same noise realization for the three cases
    noise = sigma*(randn(1,Nbits) + 1j*randn(1,Nbits));

    % Baseline AWGN
    rx0 = symbols + noise;
    det0 = real(rx0) >= 0;
    BER_baseline(k) = mean(det0 ~= bits);

    % HEO Doppler
    rxd = symbols.*exp(1j*doppler_phase) + noise;
    detd = real(rxd) >= 0;
    BER_doppler(k) = mean(detd ~= bits);

    % Ideal compensation
    rxc = rxd.*exp(-1j*doppler_phase);
    detc = real(rxc) >= 0;
    BER_comp(k) = mean(detc ~= bits);
end

fprintf('\n===============================================\n');
fprintf('DOPPLERLINK - PHASE 5 RESULTS\n');
fprintf('===============================================\n\n');
fprintf('Eb/N0(dB)    Baseline       Doppler       Compensated\n');
fprintf('-------------------------------------------------------\n');

for k = 1:length(EbN0_dB)
    fprintf('%5.0f       %10.4e     %10.4e     %10.4e\n', ...
        EbN0_dB(k),BER_baseline(k),BER_doppler(k),BER_comp(k));
end

% Theoretical BPSK BER
theory = 0.5*erfc(sqrt(10.^(EbN0_dB/10)));

figure;
semilogy(EbN0_dB,theory,'k--','LineWidth',1.5);
hold on;
semilogy(EbN0_dB,BER_baseline,'bo-','LineWidth',1.5);
semilogy(EbN0_dB,BER_doppler,'rs--','LineWidth',1.5);
semilogy(EbN0_dB,BER_comp,'g^-','LineWidth',1.5);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance Comparison');
legend('Theoretical BPSK','Baseline AWGN','Uncompensated HEO Doppler', ...
       'Compensated HEO Doppler','Location','southwest');
ylim([1e-5 1]);

results = [EbN0_dB(:),BER_baseline(:),BER_doppler(:),BER_comp(:)];
writematrix(results,'Phase5_BER_Results.csv');

save('Phase5_BER_Results.mat','EbN0_dB','BER_baseline','BER_doppler', ...
    'BER_comp','theory');

fprintf('\nResults saved to Phase5_BER_Results.csv\n');
