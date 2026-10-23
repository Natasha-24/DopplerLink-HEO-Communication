
clc;
clear;
close all;

%% DOPPLERLINK - PHASE 6
% Effect of carrier frequency on maximum Doppler and Doppler rate.
% Communication BER is also evaluated at Eb/N0 = 8 dB.

rng(30);

Nbits = 5000;
EbN0_dB = 8;
carrier_GHz = [0.9 2 5];
carrier_Hz = carrier_GHz*1e9;
c = 3e8;

H = dl_heo_model(Nbits);
t = H.t;
range_rate = H.range_rate;

max_doppler = zeros(size(carrier_Hz));
max_doppler_rate = zeros(size(carrier_Hz));
BER_no_comp = zeros(size(carrier_Hz));
BER_comp = zeros(size(carrier_Hz));

bits = randi([0 1],1,Nbits);
symbols = 2*bits - 1;

EbN0 = 10^(EbN0_dB/10);
sigma = sqrt(1/(2*EbN0));
noise = sigma*(randn(1,Nbits) + 1j*randn(1,Nbits));

for k = 1:length(carrier_Hz)

    fc = carrier_Hz(k);

    fd = -(range_rate/c)*fc;
    fd_rate = gradient(fd,t);

    max_doppler(k) = max(abs(fd));
    max_doppler_rate(k) = max(abs(fd_rate));

    phase = 2*pi*cumtrapz(t,fd);

    rx = symbols.*exp(1j*phase) + noise;
    rx_comp = rx.*exp(-1j*phase);

    BER_no_comp(k) = mean((real(rx) >= 0) ~= bits);
    BER_comp(k) = mean((real(rx_comp) >= 0) ~= bits);
end

fprintf('\n===============================================\n');
fprintf('DOPPLERLINK - PHASE 6 RESULTS\n');
fprintf('===============================================\n');
fprintf('Eb/N0 = %.2f dB\n\n',EbN0_dB);

fprintf('Carrier       Max Doppler       Max Doppler Rate\n');
fprintf('Frequency        (kHz)              (Hz/s)\n');
fprintf('---------------------------------------------------\n');

for k = 1:length(carrier_Hz)
    fprintf('%5.1f GHz       %8.2f          %10.2f\n', ...
        carrier_GHz(k),max_doppler(k)/1e3,max_doppler_rate(k));
end

fprintf('\nCarrier       BER without       BER with\n');
fprintf('Frequency     Compensation      Compensation\n');
fprintf('---------------------------------------------------\n');

for k = 1:length(carrier_Hz)
    fprintf('%5.1f GHz        %.6f          %.6f\n', ...
        carrier_GHz(k),BER_no_comp(k),BER_comp(k));
end

figure;
yyaxis left
plot(carrier_GHz,max_doppler/1e3,'o-','LineWidth',1.5);
ylabel('Maximum Doppler Shift (kHz)');

yyaxis right
plot(carrier_GHz,max_doppler_rate,'s-','LineWidth',1.5);
ylabel('Maximum Doppler Rate (Hz/s)');

grid on;
xlabel('Carrier Frequency (GHz)');
title('Maximum Doppler Shift and Doppler Rate vs Carrier Frequency');

figure;
semilogy(carrier_GHz,BER_no_comp,'ro-','LineWidth',1.5);
hold on;
semilogy(carrier_GHz,BER_comp,'gs-','LineWidth',1.5);
grid on;
xlabel('Carrier Frequency (GHz)');
ylabel('BER');
title('BER vs Carrier Frequency');
legend('Without Compensation','With Compensation','Location','best');
ylim([1e-5 1]);

results = [carrier_GHz(:),max_doppler(:)/1e3,max_doppler_rate(:), ...
           BER_no_comp(:),BER_comp(:)];

writematrix(results,'Phase6_CarrierFrequency_Results.csv');
save('Phase6_CarrierFrequency_Results.mat','carrier_GHz','max_doppler', ...
    'max_doppler_rate','BER_no_comp','BER_comp');

fprintf('\nResults saved to Phase6_CarrierFrequency_Results.csv\n');
