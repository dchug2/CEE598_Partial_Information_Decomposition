%% function for calculating partial information from Y, Z to X
% XYZ_pdf is joint PDF of X, Y and Z (N x N x N)
% YZ_pdf is joint PDF of Y and Z (N x N)
% X_pdf is the 1-d PDF of X (N x 1)
function I_YZ_X = partialinfo_YZ_X(XYZ_pdf, YZ_pdf, X_pdf)
    i = 1; j = 1; k = 1; I_YZ_X = 0;
    N = length(X_pdf);
    while i <= N
        while j <= N
            while k <= N
                if XYZ_pdf(i,j,k)~=0 && YZ_pdf(i,j)~=0 && X_pdf(k)~=0
                    temp = XYZ_pdf(i,j,k)*log2(XYZ_pdf(i,j,k)/(YZ_pdf(i,j)*X_pdf(k)));
                    I_YZ_X = I_YZ_X + temp;
                end
                k=k+1;
            end
            j = j+1; k = 1;
        end
        i = i+1; j = 1; k = 1;
    end
end
    