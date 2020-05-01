%% function for calculating conditional mutual information 
% mutual information between X and Y given Z
% XYZ_pdf is joint PDF of X, Y and Z (N x N x N)
% XZ_pdf is joint PDF of X and Z (N x N)
% YZ_pdf is joint PDF of Y and Z (N x N)
% Z_pdf is the 1-d PDF of Z (N x 1)
function I_XY_given_Z = condinfo_XY_Z(XYZ_pdf, XZ_pdf, YZ_pdf, Z_pdf)
    i = 1; j = 1; k = 1; I_XY_given_Z = 0;
    N = length(Z_pdf);
    while i <= N
        while j <= N
            while k <= N
                if XYZ_pdf(i,j,k)~=0 && XZ_pdf(i,j)~=0 && YZ_pdf(i,j)~=0 && Z_pdf(k)~=0
                    temp = XYZ_pdf(i,j,k)*log2(Z_pdf(k)*XYZ_pdf(i,j,k)/(XZ_pdf(i,k)*YZ_pdf(j,k)));
                    I_XY_given_Z = I_XY_given_Z + temp;
                end
                k=k+1;
            end
            j = j+1; k = 1;
        end
        i = i+1; j = 1; k = 1;
    end
end