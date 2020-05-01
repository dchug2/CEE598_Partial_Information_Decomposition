%% Partial information decomposition (PID) for 3-variable system
% this function computes uncertainty reduction in target variable (X)
% due to the knowledge of two source variables (Y, Z), by calculating
% components of PID - 
% U1 (unique information from source1 to target)
% U2 (unique information from source2 to target)
% S (synergistic information from source1 and source2 to target)
% R (redundant information shared by all variables)

% X, Y and Z are 1-D vectors (N x 1, each) with same temporal frequency
% Make sure all variables are standardized anomalies

% nbins is number of bins used to compute PDFs

function [U_Y, U_Z, S, R] = PID(X, Y, Z, nbins)
    % compute 1-d PDFs
    X_pdf = histcounts(X, nbins, 'Normalization', 'probability');
    Y_pdf = histcounts(Y, nbins, 'Normalization', 'probability');
    Z_pdf = histcounts(Z, nbins, 'Normalization', 'probability');
    
    % compute 2-d PDFs
    XY_pdf = histcounts2(X, Y, [nbins, nbins], 'Normalization', 'probability');
    YZ_pdf = histcounts2(Y, Z, [nbins, nbins], 'Normalization', 'probability');
    XZ_pdf = histcounts2(X, Z, [nbins, nbins], 'Normalization', 'probability');
    
    % compute 3-d PDF
    % we will use histcn function by Bruno Loung (2020)
    [XYZ_counts, ~, ~, ~] = histcn([X, Y, Z], nbins-1, nbins-1, nbins-1);
    XYZ_pdf = XYZ_counts/sum(sum(sum(XYZ_counts)));
    
    % Entropy 1-d
    H_X = entropy(X_pdf);
    H_Y = entropy(Y_pdf);
    H_Z = entropy(Z_pdf);
    
    % Mutual information between 2 variables
    % I_XY = I(X,Y)
    I_XY = mutualinfo_XY(X_pdf, Y_pdf, XY_pdf);
    I_YZ = mutualinfo_XY(Y_pdf, Z_pdf, YZ_pdf);
    I_XZ = mutualinfo_XY(X_pdf, Z_pdf, XZ_pdf);
    
    % Partial mutual information I(Y,Z;X), X is target
    % I_YZ_X = I(Y,Z;X)
    I_YZ_X = partialinfo_YZ_X(XYZ_pdf, YZ_pdf, X_pdf);
    
    % Conditional mutual information I(X,Y|Z), X is target
    % I_XY_given_Z = I(X,Y|Z)
    % I(X,Y|Z)= p(x,y,z)log(p(z)*p(x,y,z)/(p(x,z)*p(y,z)))
    I_XY_given_Z = condinfo_XY_Z(XYZ_pdf, XZ_pdf, YZ_pdf, Z_pdf);
    
    % Mutual information between 3 variables
    % I_XYZ = I(X;Y;Z) = I(X,Y|Z)-I(X,Y)
    I_XYZ = I_XY_given_Z - I_XY;
    
    %% calculate rescaled Redundancy, Rs
    Rmin = max(0,-I_XYZ);
    Rmmi = min(I_XY, I_XZ);
    % scale factor, Is
    Is = I_YZ/min(H_Y ,H_Z);
    % Rescaled redundancy
    Rs = Rmin + Is*(Rmmi-Rmin);
    
    %% Partial information decomposition
    % I_YZ_X = U_Y + U_Z + R + S, where R = Rs
    % I_XY = U_Y + R
    % I_XZ = U_Z + R
    R = Rs;
    U_Y = I_XY - R;
    U_Z = I_XZ - R;
    S = I_YZ_X - U_Y -U_Z - R;
end