
clc;
clear;
close all;

%% DOPPLERLINK - PHASE 4
% Ideal ephemeris-based Doppler compensation.

rng(10);
Nbits = 5000;
EbN0_dB = 8;

bits = randi([0 1],1,Nbits);
symbols = 2*bits - 1;

H = dl_heo_model(Nbits);
t = H.t;
fd = H.fd_2GHz;

EbN0 = 10^(EbN0_dB/10);
noise_sigma = sqrt(1/(2*EbN0));
noise = noise_sigma*(randn(1,Nbits) + 1j*randn(1,Nbits));

% Actual Doppler phase
doppler_phase = 2*pi*cumtrapz(t,fd);

rx = symbols .* exp(1j*doppler_phase) + noise;

% Ideal receiver knows the HEO Doppler phase from ephemeris
rx_comp = rx .* exp(-1j*doppler_phase);

det_no_comp = real(rx) >= 0;
det_comp = real(rx_comp) >= 0;

err_no_comp = sum(det_no_comp ~= bits);
err_comp = sum(det_comp ~= bits);

BER_no_comp = err_no_comp/Nbits;
BER_comp = err_comp/Nbits;

fprintf('DOPPLERLINK - PHASE 4\n');
fprintf('===============================================\n');
fprintf('Number of bits       = %d\n',Nbits);
fprintf('Eb/N0                = %.2f dB\n\n',EbN0_dB);
fprintf('Without Doppler Compensation\n');
fprintf('Bit errors           = %d\n',err_no_comp);
fprintf('BER                  = %.6f\n\n',BER_no_comp);
fprintf('With Doppler Compensation\n');
fprintf('Bit errors           = %d\n',err_comp);
fprintf('BER                  = %.6f\n',BER_comp);

figure;
plot(real(rx),imag(rx),'.');
grid on;
xlabel('In-phase');
ylabel('Quadrature');
title('Before Doppler Compensation');
axis equal;

figure;
plot(real(rx_comp),imag(rx_comp),'.');
grid on;
xlabel('In-phase');
ylabel('Quadrature');
title('After Doppler Compensation');
axis equal;

save('Phase4_Doppler_Compensation.mat','bits','symbols','rx','rx_comp', ...
    'doppler_phase','fd','t','BER_no_comp','BER_comp','Nbits','EbN0_dB');

fprintf('Results saved to Phase4_Doppler_Compensation.mat\n');
