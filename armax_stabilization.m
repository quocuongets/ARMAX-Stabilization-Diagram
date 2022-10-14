clear all;
close all;
clc;
load Fz_mod
load Ay_mod

X=Fz_mod;   % grinding force - input signal
Y=Ay_mod;   % acceleration - output signal

[Ly,ny]=size(Y);  % 6000
[Lu,nu]=size(X);  % 6000
Ts=1/512;
d=ny;

%Structure de donnee
Z=iddata(Y,X,Ts);
Fs = 512;
NFFT = 2^nextpow2(length(X)); % Next power of 2 from length of y

f = Fs/2*linspace(0,1,NFFT/2+1); % Le vecteur des fréquences
w = 2*pi*f;

% ARMAX model

p1 = 25 % model order
na1=p1*ones(ny,ny);
nb1=p1*ones(ny,nu);
nc1 = p1*ones(ny,nu); % nc must be ny-by-1
nk1=2*ones(ny,nu);

sys1 = armax(Z,[na1 nb1 nc1 nk1]);

H1=freqresp(sys1,w);

H1xx=[];
for i=1:size(H1,3)
    H1xx(i)=H1(1,1,i);
end

% figure
% subplot(2,1,1)
% plot(f,abs(Txx),'b--','LineWidth',1.0)
% hold on
frf=abs(H1xx)';
modalsd(frf,f',Fs,'MaxModes',50)