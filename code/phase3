clc;
clear;
close all;

%% DOPPLERLINK - PHASE 3
% Apply the HEO time-varying Doppler as a continuous carrier phase rotation.

rng(10);
Nbits = 5000;
EbN0_dB = 8;
fc = 2e9;
c = 3e8;

bits = randi([0 1],1,Nbits);
symbols = 2*bits - 1;

H = dl_heo_model(Nbits);
t = H.t;
fd = H.fd_2GHz;

EbN0 = 10^(EbN0_dB/10);
noise_sigma = sqrt(1/(2*EbN0));
noise = noise_sigma*(randn(1,Nbits) + 1j*randn(1,Nbits));

% Doppler phase = integral(2*pi*fd(t) dt)
doppler_phase = 2*pi*cumtrapz(t,fd);

% Complex baseband received signal
rx_doppler = symbols .* exp(1j*doppler_phase) + noise;

% Simple coherent detector without Doppler compensation
detected_bits = real(rx_doppler) >= 0;
bit_errors = sum(detected_bits ~= bits);
BER = bit_errors/Nbits;

fprintf('DOPPLERLINK - PHASE 3\n');
fprintf('===============================================\n');
fprintf('Number of bits       = %d\n',Nbits);
fprintf('Eb/N0                = %.2f dB\n\n',EbN0_dB);
fprintf('Baseline BPSK\n');
fprintf('Bit errors           = %d\n',sum((real(symbols + noise) >= 0) ~= bits));
fprintf('BER                  = %.6f\n\n',sum((real(symbols + noise) >= 0) ~= bits)/Nbits);
fprintf('With HEO Doppler\n');
fprintf('Bit errors           = %d\n',bit_errors);
fprintf('BER                  = %.6f\n',BER);

figure;
stem(1:40,symbols(1:40),'o','LineWidth',1.0);
hold on;
stem(1:40,real(rx_doppler(1:40)),'s','LineWidth',1.0);
grid on;
xlabel('Symbol Index');
ylabel('Amplitude');
title('BPSK Waveform Before vs After HEO Doppler');
legend('Original BPSK','Doppler + AWGN');

figure;
plot(real(rx_doppler),imag(rx_doppler),'.');
grid on;
xlabel('In-phase');
ylabel('Quadrature');
title('BPSK Constellation with HEO Doppler');
axis equal;

save('Phase3_HEO_Doppler.mat','bits','symbols','rx_doppler','doppler_phase', ...
    'fd','t','Nbits','EbN0_dB','fc','BER');

fprintf('Results saved to Phase3_HEO_Doppler.mat\n');

