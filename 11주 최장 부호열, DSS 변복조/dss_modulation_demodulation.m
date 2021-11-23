%% DSS plot
Fmax=2e6; Fc=1e6; Tc=2e-6;

% 기저대역 신호
Tp=10e-3; Tw=20e-3;
[t, a_t] = voice_gen(Fmax, Tp, Tw, 'a');

% DSB 변조
dsb_t = (a_t)'.*cos(2*pi*Fc*t);

% DSS 변조
m=10; sw=3;
ds_t=DSS(Fmax, dsb_t, Tc, m, sw);

% DSS 복조
ds_dem=DSS(Fmax, ds_t, Tc, m, sw);

% plot
figure(1);
subplot(3,1,1)
plot(abs(fft(dsb_t)), 'b'); ylabel('DSB'); grid on;
xlim([0 40000]); ylim([0 2000]);

subplot(3,1,2)
plot(abs(fft(ds_t)), 'r'); ylabel('DSS'); grid on;
xlim([0 40000]); ylim([0 2000]);

subplot(3,1,3)
plot(abs(fft(ds_dem)), 'g'); ylabel('복조된 스펙트럼'); grid on;
xlim([0 40000]); ylim([0 2000]);