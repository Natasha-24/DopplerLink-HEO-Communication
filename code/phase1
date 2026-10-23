clc;
clear;
close all;

%% DopplerLink - HEO Orbital Model
% Phase 1: HEO orbital and Doppler model
% This file preserves the original Phase-1 model used in the project.

% Earth parameters
Re = 6378e3;              % Earth radius (m)
mu = 3.986004418e14;      % Earth gravitational parameter (m^3/s^2)

% HEO parameters
alt_perigee = 1000e3;     % Perigee altitude
alt_apogee  = 39000e3;    % Apogee altitude

rp = Re + alt_perigee;
ra = Re + alt_apogee;

% Orbital parameters
a = (rp + ra)/2;
e = (ra - rp)/(ra + rp);

fprintf('HEO PARAMETERS\n');
fprintf('-------------------------\n');
fprintf('Perigee radius       = %.2f km\n', rp/1000);
fprintf('Apogee radius        = %.2f km\n', ra/1000);
fprintf('Semi-major axis      = %.2f km\n', a/1000);
fprintf('Eccentricity         = %.4f\n', e);

%% Orbital period
T = 2*pi*sqrt(a^3/mu);

fprintf('Orbital period       = %.2f hours\n', T/3600);

%% Time vector
N = 5000;
t = linspace(0,T,N);

%% Mean motion
n = sqrt(mu/a^3);

%% Mean anomaly
M = n*t;

%% Solve Kepler's equation
% M = E - e*sin(E)
E = M;

for k = 1:20
    E = E - (E - e*sin(E) - M) ./ (1 - e*cos(E));
end

%% True anomaly
nu = 2*atan2( ...
    sqrt(1+e).*sin(E/2), ...
    sqrt(1-e).*cos(E/2));

%% Orbital radius
r = a*(1 - e*cos(E));

%% Satellite position in orbital plane
x = r .* cos(nu);
y = r .* sin(nu);

%% Satellite velocity
vx = -(sqrt(mu*a) ./ r) .* sin(E);
vy =  (sqrt(mu*a) ./ r) .* sqrt(1-e^2) .* cos(E);

v = sqrt(vx.^2 + vy.^2);

%% Ground station
ground_x = Re;
ground_y = 0;

%% Range
range = sqrt((x - ground_x).^2 + (y - ground_y).^2);

figure;
plot(t/3600, range/1000, 'LineWidth', 1.5);
grid on;
xlabel('Time (hours)');
ylabel('Slant range (km)');
title('Satellite-to-Ground Station Range');

%% Range rate
range_rate = gradient(range, t);

figure;
plot(t/3600, range_rate/1000, 'LineWidth', 1.5);
grid on;
xlabel('Time (hours)');
ylabel('Range rate (km/s)');
title('Range Rate between Satellite and Ground Station');

%% Satellite velocity
figure;
plot(t/3600, v/1000, 'LineWidth', 1.5);
grid on;
xlabel('Time (hours)');
ylabel('Satellite velocity (km/s)');
title('Satellite Velocity in HEO');

%% HEO trajectory
figure;
plot(x/1000,y/1000,'LineWidth',1.5);
hold on;
plot(0,0,'o','MarkerSize',10,'MarkerFaceColor','y');
grid on;
axis equal;
xlabel('x position (km)');
ylabel('y position (km)');
title('Highly Elliptical Satellite Orbit');
legend('HEO trajectory','Earth');

%% Doppler
c = 3e8;
fc = 2e9;

fd = -(range_rate/c) * fc;

figure;
plot(t/3600, fd/1000, 'LineWidth', 1.5);
grid on;
xlabel('Time (hours)');
ylabel('Doppler frequency (kHz)');
title('Time-Varying Doppler Shift in HEO');

%% Doppler rate
doppler_rate = gradient(fd, t);

figure;
plot(t/3600, doppler_rate, 'LineWidth', 1.5);
grid on;
xlabel('Time (hours)');
ylabel('Doppler rate (Hz/s)');
title('Doppler Rate in HEO');

save('Phase1_HEO_Model.mat','Re','mu','rp','ra','a','e','T','t','x','y','v', ...
    'range','range_rate','fc','fd','doppler_rate');

fprintf('\nPhase 1 completed. Results saved to Phase1_HEO_Model.mat\n');

