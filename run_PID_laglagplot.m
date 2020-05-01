%% This script performs and plots PID components v/s lag
warning off MATLAB:lang:cannotClearExecutingFunction;
clear all;

%% Read data
SM = xlsread('SM_SACZ_1980-2018.csv');
Ta = xlsread('T2M_SACZ_1980-2018.csv');
H_data = xlsread('Z_250_500_850_925_SACZ_1980-2018.csv');
H925 = H_data(:, 4);

%% standardize the data with mean and stdev
Y = (SM-mean(SM))/std(SM);
X = (Ta-mean(Ta))/std(Ta);
Z = (H925-mean(H925))/std(H925);

%% perform PID computation
nbins = 20;
maxlag = 45;
[U_Y, U_Z, S, R] = lagged_PID(X, Y, Z, nbins, maxlag);