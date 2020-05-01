%% This script performs and plots PID components v/s lag
warning off MATLAB:lang:cannotClearExecutingFunction;
clear all;

%% Read data
SM = xlsread('SM_SACZ_1980-2018.csv');
Ta = xlsread('T2M_SACZ_1980-2018.csv');
H_data = xlsread('Z_250_500_850_925_SACZ_1980-2018.csv');
H925 = H_data(:, 4);

%% preprocessing
%standardize the data with mean and stdev, 
% and perform 31-day rolling mean
window = 31; trunc = (window-1)/2; 
Y = (SM-mean(SM))/std(SM); Y = movmean(Y, window); Y = Y(trunc+1:end-trunc);
X = (Ta-mean(Ta))/std(Ta); X = movmean(X, window); X = X(trunc+1:end-trunc);
Z = (H925-mean(H925))/std(H925); Z = movmean(Z, window); Z = Z(trunc+1:end-trunc);

% Subset to season of interest, NDJFM
t1 = datetime(1980, 1, 1, 0, 0, 0);
t2 = datetime(2018, 12, 31, 18, 0, 0);
dt_arr = t1:hours(6):t2;

%% perform PID computation
nbins = 20;
lag_days = 45;
maxlag = (lag_days+1)*4-1; %multiple of 4 takes care of data resolution (6-hourly)
[U_Y, U_Z, S, R] = lagged_PID(X, Y, Z, nbins, maxlag);

%% plot results
lag_Y = linspace(0, lag_days, maxlag+1);
lag_Z = linspace(0, lag_days, maxlag+1);

figure(1); clf;

subplot(2, 2, 3);
imagesc(lag_Z, lag_Y, S);
title('Synergy, S(Ta; SM, H925)'); xlabel('H925 lag (minus days)');
ylabel('SM lag (minus days)'); colorbar();
set(gca, 'fontsize', 12);

subplot(2, 2, 4);
imagesc(lag_Z, lag_Y, R);
title('Redundancy, R(Ta; SM, H925)'); xlabel('H925 lag (minus days)');
ylabel('SM lag (minus days)'); colorbar();
set(gca, 'fontsize', 12);

subplot(2, 2, 1);
imagesc(lag_Z, lag_Y, U_Y);
title('Unique Info, U(Ta; SM)'); xlabel('H925 lag (minus days)');
ylabel('SM lag (minus days)'); colorbar();
set(gca, 'fontsize', 12);

subplot(2, 2, 2);
imagesc(lag_Z, lag_Y, U_Z);
title('Unique Info, U(Ta; H925)'); xlabel('H925 lag (minus days)');
ylabel('SM lag (minus days)'); colorbar();
set(gca, 'fontsize', 12);
