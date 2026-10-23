
function H = dl_heo_model(N)
% DL_HEO_MODEL
% Common HEO model used by Phases 2-8.
%
% Output fields:
% t, T, x, y, v, range, range_rate, fd_2GHz, doppler_rate_2GHz,
% Re, mu, a, e, rp, ra

if nargin < 1
    N = 5000;
end

Re = 6378e3;
mu = 3.986004418e14;

alt_perigee = 1000e3;
alt_apogee  = 39000e3;

rp = Re + alt_perigee;
ra = Re + alt_apogee;

a = (rp + ra)/2;
e = (ra - rp)/(ra + rp);

T = 2*pi*sqrt(a^3/mu);
t = linspace(0,T,N);

n = sqrt(mu/a^3);
M = n*t;

E = M;
for k = 1:20
    E = E - (E - e*sin(E) - M) ./ (1 - e*cos(E));
end

nu = 2*atan2(sqrt(1+e).*sin(E/2), ...
             sqrt(1-e).*cos(E/2));

r = a*(1-e*cos(E));

x = r.*cos(nu);
y = r.*sin(nu);

vx = -(sqrt(mu*a)./r).*sin(E);
vy =  (sqrt(mu*a)./r).*sqrt(1-e^2).*cos(E);
v = sqrt(vx.^2 + vy.^2);

ground_x = Re;
ground_y = 0;

range = sqrt((x-ground_x).^2 + (y-ground_y).^2);
range_rate = gradient(range,t);

c = 3e8;
fc = 2e9;

fd_2GHz = -(range_rate/c)*fc;
doppler_rate_2GHz = gradient(fd_2GHz,t);

H.Re = Re;
H.mu = mu;
H.rp = rp;
H.ra = ra;
H.a = a;
H.e = e;
H.T = T;
H.t = t;
H.x = x;
H.y = y;
H.v = v;
H.range = range;
H.range_rate = range_rate;
H.fd_2GHz = fd_2GHz;
H.doppler_rate_2GHz = doppler_rate_2GHz;
end
