clc;
clear;
close all;

%% DOPPLERLINK - FINAL PRESENTATION FIGURES
% This script creates six presentation-ready plots from the same
% HEO/BPSK/Doppler model.
%
% Important:
% These are visualization plots only. They do not change the Phase 1
% orbital model or the underlying phase simulations.

rng(100);

%% Common parameters
Nbits = 5000;
EbN0_dB = 8;
fc = 2e9;
c = 3e8;

H = dl_heo_model(Nbits);
t = H.t;
T = H.T;
x = H.x;
y = H.y;
fd = H.fd_2GHz;
fd_rate = H.doppler_rate_2GHz;
range_rate = H.range_rate;

%% ---------------------------------------------------------
% Graph 1: HEO trajectory
% ----------------------------------------------------------
figure('Name','Graph 1 - HEO Trajectory');

plot(x/1000,y/1000,'LineWidth',1.5);
hold on;
plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','y');
plot(x(1)/1000,y(1)/1000,'ro','MarkerSize',7,'MarkerFaceColor','r');
plot(x(round(Nbits/2))/1000,y(round(Nbits/2))/1000,'mo', ...
    'MarkerSize',7,'MarkerFaceColor','m');

grid on;
axis equal;
xlabel('In-Plane X (km)');
ylabel('In-Plane Y (km)');
title('Graph 1: Highly Elliptical Orbit (HEO) Trajectory');
legend('HEO Trajectory','Earth','Start/Perigee Reference','Apogee Reference', ...
    'Location','best');

%% ---------------------------------------------------------
% Graph 2: Doppler and Doppler rate
% ----------------------------------------------------------
figure('Name','Graph 2 - Time-Varying Doppler');

yyaxis left
plot(t/3600,fd/1000,'LineWidth',1.5);
ylabel('Doppler Shift f_d (kHz)');

yyaxis right
plot(t/3600,fd_rate,'--','LineWidth',1.2);
ylabel('Doppler Rate df_d/dt (Hz/s)');

grid on;
xlabel('Orbit Time (hours)');
title('Graph 2: Time-Varying Doppler Shift and Doppler Rate (f_c = 2 GHz)');

%% ---------------------------------------------------------
% Graph 3: BPSK waveform before/after Doppler
% ----------------------------------------------------------
bits = randi([0 1],1,Nbits);
symbols = 2*bits - 1;

EbN0 = 10^(EbN0_dB/10);
sigma = sqrt(1/(2*EbN0));
noise = sigma*(randn(1,Nbits) + 1j*randn(1,Nbits));

doppler_phase = 2*pi*cumtrapz(t,fd);
rx = symbols.*exp(1j*doppler_phase) + noise;

show = 40;

figure('Name','Graph 3 - BPSK Before and After Doppler');

stem(1:show,symbols(1:show),'o','LineWidth',1.0);
hold on;
stem(1:show,real(rx(1:show)),'s','LineWidth',1.0);
stem(1:show,imag(rx(1:show)),'^','LineWidth',1.0);

grid on;
xlabel('Symbol Index');
ylabel('Normalized Amplitude');
title('Graph 3: BPSK Waveform Before vs After Doppler');
legend('Original BPSK','Doppler In-Phase (I)','Doppler Quadrature (Q)', ...
    'Location','best');

%% ---------------------------------------------------------
% Graph 4: BER vs Eb/N0
% ----------------------------------------------------------
EbN0_sweep = 0:2:12;

BER_base = zeros(size(EbN0_sweep));
BER_dopp = zeros(size(EbN0_sweep));
BER_comp = zeros(size(EbN0_sweep));

for k = 1:length(EbN0_sweep)

    snrLin = 10^(EbN0_sweep(k)/10);
    sig = sqrt(1/(2*snrLin));

    n = sig*(randn(1,Nbits) + 1j*randn(1,Nbits));

    r0 = symbols + n;
    rd = symbols.*exp(1j*doppler_phase) + n;
    rc = rd.*exp(-1j*doppler_phase);

    BER_base(k) = mean((real(r0)>=0) ~= bits);
    BER_dopp(k) = mean((real(rd)>=0) ~= bits);
    BER_comp(k) = mean((real(rc)>=0) ~= bits);
end

theory = 0.5*erfc(sqrt(10.^(EbN0_sweep/10)));

figure('Name','Graph 4 - BER Comparison');

semilogy(EbN0_sweep,theory,'k:','LineWidth',1.5);
hold on;
semilogy(EbN0_sweep,BER_base,'bo-','LineWidth',1.5);
semilogy(EbN0_sweep,BER_dopp,'rs--','LineWidth',1.5);
semilogy(EbN0_sweep,BER_comp,'g^-','LineWidth',1.5);

grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('Graph 4: BER vs E_b/N_0 Performance Comparison');
legend('Theoretical BPSK','Baseline AWGN','Uncompensated Doppler', ...
    'Compensated Doppler','Location','southwest');
ylim([1e-5 1]);

%% ---------------------------------------------------------
% Graph 5: Constellation recovery
% ----------------------------------------------------------
rx_comp = rx.*exp(-1j*doppler_phase);

figure('Name','Graph 5 - Constellation Recovery');

plot(real(rx),imag(rx),'.','MarkerSize',5);
hold on;
plot(real(rx_comp),imag(rx_comp),'.','MarkerSize',5);
plot([-1 1],[0 0],'ko','MarkerSize',8,'MarkerFaceColor','y');

grid on;
axis equal;
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title('Graph 5: Constellation Recovery via Doppler Compensation');
legend('Uncompensated (Smeared)','Compensated (Clusters)','Ideal BPSK', ...
    'Location','best');

%% ---------------------------------------------------------
% Graph 6: Carrier frequency dependence
% ----------------------------------------------------------
carrier_GHz = [0.9 2 5];
carrier_Hz = carrier_GHz*1e9;

maxFd = zeros(size(carrier_Hz));
maxFdRate = zeros(size(carrier_Hz));

for k = 1:length(carrier_Hz)

    fd_k = -(range_rate/c)*carrier_Hz(k);
    rate_k = gradient(fd_k,t);

    maxFd(k) = max(abs(fd_k))/1000;
    maxFdRate(k) = max(abs(rate_k));
end

figure('Name','Graph 6 - Carrier Frequency Effect');

yyaxis left
plot(carrier_GHz,maxFd,'o-','LineWidth',1.5);
ylabel('Maximum Doppler Shift (kHz)');

yyaxis right
plot(carrier_GHz,maxFdRate,'s-','LineWidth',1.5);
ylabel('Maximum Doppler Rate (Hz/s)');

grid on;
xlabel('Carrier Frequency (GHz)');
title('Graph 6: Maximum Doppler Shift and Rate vs Carrier Frequency');

fprintf('\n===============================================\n');
fprintf('DOPPLERLINK - FINAL PRESENTATION SUMMARY\n');
fprintf('===============================================\n');
fprintf('HEO period = %.3f hours\n',T/3600);
fprintf('Eccentricity = %.4f\n',H.e);
fprintf('2 GHz max Doppler = %.2f kHz\n',max(abs(fd))/1000);
fprintf('2 GHz max Doppler rate = %.2f Hz/s\n',max(abs(fd_rate)));

fprintf('\nCarrier Frequency Results:\n');
fprintf('Carrier (GHz)   Max Doppler (kHz)   Max Doppler Rate (Hz/s)\n');
for k = 1:length(carrier_GHz)
    fprintf('%8.1f        %12.2f          %12.2f\n', ...
        carrier_GHz(k),maxFd(k),maxFdRate(k));
end

fprintf('\nFinal presentation figures generated successfully.\n');

