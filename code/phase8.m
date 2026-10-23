
clc;
clear;
close all;

%% DOPPLERLINK - PHASE 8
% Communication performance in different orbital regions.
% The full HEO orbit is divided into 10 equal time regions.

rng(50);

Nbits = 10000;
EbN0_dB = 8;
fc = 2e9;
c = 3e8;
nRegions = 10;

H = dl_heo_model(Nbits);
t = H.t;
T = H.T;
range_rate = H.range_rate;

fd = -(range_rate/c)*fc;
fd_rate = gradient(fd,t);
phase = 2*pi*cumtrapz(t,fd);

bits = randi([0 1],1,Nbits);
symbols = 2*bits - 1;

EbN0 = 10^(EbN0_dB/10);
sigma = sqrt(1/(2*EbN0));
noise = sigma*(randn(1,Nbits) + 1j*randn(1,Nbits));

rx = symbols.*exp(1j*phase) + noise;

region = zeros(nRegions,1);
time_hr = zeros(nRegions,1);
avg_range_rate = zeros(nRegions,1);
max_doppler = zeros(nRegions,1);
max_doppler_rate = zeros(nRegions,1);
BER_no_comp = zeros(nRegions,1);
BER_comp = zeros(nRegions,1);

for k = 1:nRegions

    idx1 = floor((k-1)*Nbits/nRegions)+1;
    idx2 = floor(k*Nbits/nRegions);

    idx1t = floor((k-1)*length(t)/nRegions)+1;
    idx2t = floor(k*length(t)/nRegions);

    idx = idx1:idx2;
    idt = idx1t:idx2t;

    region(k) = k;
    time_hr(k) = mean(t(idt))/3600;

    avg_range_rate(k) = mean(range_rate(idt))/1000;
    max_doppler(k) = max(abs(fd(idt)))/1000;
    max_doppler_rate(k) = max(abs(fd_rate(idt)));

    BER_no_comp(k) = mean((real(rx(idx)) >= 0) ~= bits(idx));

    % Compensate using the exact phase for the same region
    rx_comp = rx(idx).*exp(-1j*phase(idx));
    BER_comp(k) = mean((real(rx_comp) >= 0) ~= bits(idx));
end

fprintf('\n===============================================\n');
fprintf('DOPPLERLINK - PHASE 8 RESULTS\n');
fprintf('===============================================\n');
fprintf('Carrier frequency = %.1f GHz\n',fc/1e9);
fprintf('Eb/N0 = %.2f dB\n',EbN0_dB);
fprintf('Number of orbital regions = %d\n\n',nRegions);

fprintf('Region   Time(hr)   Avg Range Rate   Max Doppler   Max Doppler Rate   BER No Comp   BER Comp\n');
fprintf('---------------------------------------------------------------------------------------\n');

for k = 1:nRegions
    fprintf('%3d     %8.3f      %8.3f        %8.2f          %8.2f       %8.5f      %8.5f\n', ...
        region(k),time_hr(k),avg_range_rate(k),max_doppler(k), ...
        max_doppler_rate(k),BER_no_comp(k),BER_comp(k));
end

figure;
subplot(2,1,1);
plot(time_hr,avg_range_rate,'o-','LineWidth',1.5);
grid on;
xlabel('Orbital Time (hours)');
ylabel('Average Range Rate (km/s)');
title('Range Rate by Orbital Region');

subplot(2,1,2);
semilogy(time_hr,BER_no_comp,'rs-','LineWidth',1.5);
hold on;
semilogy(time_hr,BER_comp,'go-','LineWidth',1.5);
grid on;
xlabel('Orbital Time (hours)');
ylabel('BER');
title('BER by Orbital Region');
legend('Without Compensation','With Compensation','Location','best');
ylim([1e-5 1]);

results = [region,time_hr,avg_range_rate,max_doppler,max_doppler_rate, ...
           BER_no_comp,BER_comp];

writematrix(results,'Phase8_Orbit_Communication_Results.csv');
save('Phase8_Orbit_Communication_Results.mat','region','time_hr', ...
    'avg_range_rate','max_doppler','max_doppler_rate','BER_no_comp','BER_comp');

fprintf('\nResults saved to Phase8_Orbit_Communication_Results.csv\n');
