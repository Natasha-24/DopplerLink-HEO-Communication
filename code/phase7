
clc;
clear;
close all;

%% DOPPLERLINK - PHASE 7
% Sensitivity to Doppler-estimation error.
% The receiver uses an intentionally imperfect estimate of the Doppler phase.

rng(40);

Nbits = 5000;
EbN0_dB = 8;
fc = 2e9;
error_percent = [0 1 2 5 10 20];
c = 3e8;

H = dl_heo_model(Nbits);
t = H.t;
range_rate = H.range_rate;

fd_true = -(range_rate/c)*fc;
phase_true = 2*pi*cumtrapz(t,fd_true);

bits = randi([0 1],1,Nbits);
symbols = 2*bits - 1;

EbN0 = 10^(EbN0_dB/10);
sigma = sqrt(1/(2*EbN0));
noise = sigma*(randn(1,Nbits) + 1j*randn(1,Nbits));

rx = symbols.*exp(1j*phase_true) + noise;

BER = zeros(size(error_percent));

for k = 1:length(error_percent)

    err = error_percent(k)/100;

    % Multiplicative Doppler-estimation error
    fd_est = fd_true*(1+err);
    phase_est = 2*pi*cumtrapz(t,fd_est);

    rx_comp = rx.*exp(-1j*phase_est);

    BER(k) = mean((real(rx_comp) >= 0) ~= bits);
end

fprintf('\n===============================================\n');
fprintf('DOPPLERLINK - PHASE 7 RESULTS\n');
fprintf('===============================================\n');
fprintf('Carrier frequency = %.1f GHz\n',fc/1e9);
fprintf('Eb/N0 = %.2f dB\n\n',EbN0_dB);

fprintf('Estimation Error       BER\n');
fprintf('-----------------------------\n');

for k = 1:length(error_percent)
    fprintf('%8.1f %%             %.6f\n',error_percent(k),BER(k));
end

figure;
semilogy(error_percent,BER,'o-','LineWidth',1.5);
grid on;
xlabel('Doppler Estimation Error (%)');
ylabel('BER');
title('BER Sensitivity to Doppler Estimation Error');
ylim([1e-5 1]);

results = [error_percent(:),BER(:)];
writematrix(results,'Phase7_Doppler_Estimation_Results.csv');
save('Phase7_Doppler_Estimation_Results.mat','error_percent','BER');

fprintf('\nResults saved to Phase7_Doppler_Estimation_Results.csv\n');
