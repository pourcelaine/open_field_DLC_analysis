% function to load in the photometry data

function [timevec, green, red] = loadFP(basedir, which_chan, freq, LPfreq, downsamp_factor)

% parameters - can make these arguments if necessary
% freq = 20000; % 20 kHz
% LPfreq = 10;  % 70 Hz
% downsamp_factor = 1000; % downsample by factor of 100
num_channels = 2; % how many channels in dat file

% function starts here

curr_dir = pwd;
cd(basedir);
dt = 1/freq;

Fdata = bz_LoadBinary('amplifier_analogin_auxiliary_int16.dat', 'nChannels', num_channels, 'frequency', freq);
timevec = 0:dt:dt*size(Fdata,1);
timevec = timevec(1:end-1);
timevec = timevec(:);

% plot(timevec, Fdata(:, which_chan), 'k'); hold on

% filter and downsample
green = lowpass(double(Fdata(:, which_chan)), LPfreq, freq);
green = decimate(green, downsamp_factor);
timevec = downsample(timevec, downsamp_factor);

cd(curr_dir);

% plot(timevec, green, 'g');



