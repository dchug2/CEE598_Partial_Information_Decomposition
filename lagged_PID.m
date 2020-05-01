%% Plot for PID as a function of lag 
% this function computes components of PID given by PID.m as a 
% function of lags of the source variables (Y and Z) to 
% target variable (X) from 0 to -maxlag days

% and generates four plots, one each for U1, U2, S and R, v/s lag

% X, Y and Z are 1-D vectors (N x 1, each) with same temporal frequency
% Make sure all variables are standardized anomalies

% nbins is number of bins used to compute PDFs

function [U_Y, U_Z, S, R] = lagged_PID(X, Y, Z, nbins, maxlag)
    % initialize the array
    [U_Y, U_Z, S, R] = deal(zeros(maxlag+1, maxlag+1));
    
    % trim X from the start
    X_lag = X(maxlag+1:end);
    %start for loops for iterations over lag
    for lagY = 0:maxlag
        % trim Y by offsetting from X
        Y_lag = Y(maxlag+1-lagY:end-lagY);
        for lagZ = 0:maxlag
            iteration = lagY*(maxlag+1) + (lagZ+1)
            % trim Z by offsetting from X
            Z_lag = Z(maxlag+1-lagZ:end-lagZ);
            
            % compute PID components
            [U_Y(lagY+1, lagZ+1), U_Z(lagY+1, lagZ+1),...
                S(lagY+1, lagZ+1), R(lagY+1, lagZ+1)] = PID(X, Y, Z, nbins);
        end
    end
end