
function [fitparams, fitcurve, fitcurve_var, fitcurve_eq] = fitFP(FPdata, timevec, minfit, maxfit)

background = 0.9; % what proportion of fluorescence is estimated to be background

% find indices (minfit and maxfit should be integers)
% minidx = find(timevec == minfit);
% maxidx = find(timevec == maxfit);

% % this is a better way to do it, but there's a bug that I'm not going to
% % track down
% minidx = findClosest(timevec, minfit);
% maxidx = findClosest(timevec, maxfit);

% % exponential fit
% fitparams = fit(timevec(minidx:maxidx), FPdata(minidx:maxidx), 'exp1');
% fitcurve = fitparams.a * exp(fitparams.b * timevec);

% exponential fit with constant
max_val = max(FPdata(minfit:maxfit));
a_init = (1 - background) * max_val;
b_init = 0;
c_init = background * max_val;


% abc_fit = fittype('a * exp(b*x) + c','coeff',{'a','b','c'});
abc_fit = fittype('a * exp(b*x) + c');

fitparams = fit(timevec(minfit:maxfit), FPdata(minfit:maxfit), abc_fit, 'StartPoint', [a_init, b_init, c_init]);
fitcurve = fitparams.a * exp(fitparams.b * timevec) + fitparams.c;

fitcurve_var = [fitparams.a, fitparams.b, fitparams.c]
fitcurve_eq = strcat(string(fitparams.a), {' * exp('}, string(fitparams.b), {'*x) + '}, string(fitparams.c));
% % for testing
% close all
% plot(timevec, FPdata, 'g'); hold on
% plot(timevec(minidx:maxidx), FPdata(minidx:maxidx), 'r');
