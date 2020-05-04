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
SM_anom = (SM-mean(SM))/std(SM); SM_anom = movmean(SM_anom, window); SM_anom = SM_anom(trunc+1:end-trunc);
Ta_anom = (Ta-mean(Ta))/std(Ta); Ta_anom = movmean(Ta_anom, window); Ta_anom = Ta_anom(trunc+1:end-trunc);
H_anom = (H925-mean(H925))/std(H925); H_anom = movmean(H_anom, window); H_anom = H_anom(trunc+1:end-trunc);

% Subset to season of interest, NDJFM
t1 = datetime(1980, 1, 1, 0, 0, 0);
t2 = datetime(2018, 12, 31, 18, 0, 0);
dt_arr = t1:hours(6):t2; dt_arr = dt_arr(trunc+1:end-trunc);
NDJFM =  (month(dt_arr) >= 11) | (month(dt_arr) <= 3) ;

%% Assign variables
% X is target, Y is source1, Z is source2
X = H_anom;
Y = Ta_anom;
Z = SM_anom;

%% perform PID computation
nbins = 20;
lag_days = 45;
maxlag = (lag_days+1)*4-1; %multiple of 4 takes care of data resolution (6-hourly)
[U_Y, U_Z, S, R] = lagged_PID(X, Y, Z, nbins, maxlag);

%% plot results
% Change strings here
lag_Y = linspace(0, lag_days, maxlag+1);
lag_Z = linspace(0, lag_days, maxlag+1);
ylab = 'Ta anom lag (minus days)'; % source1, Y
U1_title = 'Unique, U(H925; Ta)';
xlab = 'SM anom lag (minus days)';% source2, Z
U2_title = 'Unique, U(H925; SM)'
plot_dir = 'C:\Users\dchug2\Downloads\Academics\Spring 2020\CEE598_NLH\Project\Plots\';
plot_name = 'PID_targetH925_NDJFM_runmean30.jpg';
% --------------------------------
% Do not change past this line

figure(1); clf;

subplot(2, 2, 3);
imagesc(lag_Z, lag_Y, S);
title('Synergy, S'); xlabel(xlab);
ylabel(ylab); colorbar();
set(gca, 'fontsize', 12);

subplot(2, 2, 4);
imagesc(lag_Z, lag_Y, R);
title('Redundancy, R'); xlabel(xlab);
ylabel(ylab); colorbar();
set(gca, 'fontsize', 12);

subplot(2, 2, 1);
imagesc(lag_Z, lag_Y, U_Y);
title(U1_title); xlabel(xlab);
ylabel(ylab); colorbar();
set(gca, 'fontsize', 12);

subplot(2, 2, 2);
imagesc(lag_Z, lag_Y, U_Z);
title(U2_title); xlabel(xlab);
ylabel(ylab); colorbar();
set(gca, 'fontsize', 12);

export_fig(strcat(plot_dir, plot_name));
