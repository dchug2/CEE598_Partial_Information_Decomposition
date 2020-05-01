%% function for calculating mutual information between X and Y
% X_pdf and Y_pdf are 1-D PDFs of same size (nbins X 1)
% XY_pdf is the joint PDF of X and Y (nbins x nbins)
function MI = mutualinfo_XY(X_pdf, Y_pdf, XY_pdf)
    HX = entropy_X(X_pdf);
    HY = entropy_X(Y_pdf);
    HXY = entropy_XY(XY_pdf);
    MI = HX + HY - HXY;
end
    